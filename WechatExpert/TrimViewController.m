//
//  TrimViewController.m
//  WechatExpert
//
//  Created by User #⑨ on 14-4-17.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import "TrimViewController.h"

@interface TrimViewController ()

@end

@implementation TrimViewController
@synthesize VideoName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(done:)];

    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.myActivityIndicator.hidden = YES;

    UIButton *yuan = [UIButton buttonWithType:0];
    [yuan setFrame:CGRectMake(16, 250, 82, 44)];
    [yuan setTitle:@"原视频" forState:UIControlStateNormal];
    [yuan setBackgroundColor:[UIColor redColor]];
    [yuan addTarget:self action:@selector(showOriginalVideo:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:yuan];

    UIButton *yulan = [UIButton buttonWithType:0];
    [yulan setFrame:CGRectMake(119, 250, 82, 44)];
    [yulan setTitle:@"预览" forState:UIControlStateNormal];
    [yulan setBackgroundColor:[UIColor redColor]];
    [yulan addTarget:self action:@selector(showTrimmedVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yulan];

    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, 320, 30)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:18.f];
    self.timeLabel.text = @"0s - 0s";
    [self.view addSubview:self.timeLabel];

//    NSString *tempDir = NSTemporaryDirectory();
//    self.tmpVideoPath = [tempDir stringByAppendingPathComponent:VideoName];

    self.tmpVideoPath = [NSString stringWithFormat:@"%@/%@",[ShareData dataPath],VideoName];

//    self.tmpVideoPath = self.originalVideoPath;

//    NSBundle *mainBundle = [NSBundle mainBundle];
//    self.originalVideoPath = [mainBundle pathForResource: @"201443165314" ofType: @"mp4"];
//    self.originalVideoPath = @"/var/mobile/Applications/EB5DA3D6-DB42-4CDC-A622-AD342F4761D7/Documents/image/2014417173031.mp4";
//    NSURL *videoFileUrl = [NSURL fileURLWithPath:self.originalVideoPath];

    NSURL *videoFileUrl = [NSURL fileURLWithPath:self.originalVideoPath];

    self.mySAVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(10, 150, self.view.frame.size.width-20, 50) videoUrl:videoFileUrl timeLength:[self.VideoTime intValue]];
    self.mySAVideoRangeSlider.bubleText.font = [UIFont systemFontOfSize:12];
    [self.mySAVideoRangeSlider setPopoverBubbleSize:120 height:60];

    self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.996 green: 0.951 blue: 0.502 alpha: 1];
    self.mySAVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.992 green: 0.902 blue: 0.004 alpha: 1];

    self.mySAVideoRangeSlider.delegate = self;

    [self.view addSubview:self.mySAVideoRangeSlider];
}

- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(TrimControllerDidCancel:)]) {
        [self.delegate TrimControllerDidCancel:self];
    }
}

- (void)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(TrimController:didFinishTrimVideo:Video:)]) {
        [self.delegate TrimController:self didFinishTrimVideo:self.tmpVideoPath Video:VideoName];
    }
}

- (void)showOriginalVideo:(id)sender {

    [self playMovie:self.originalVideoPath];

}


- (void)showTrimmedVideo:(UIButton *)sender {

    [self deleteTmpFile];

    self.navigationItem.rightBarButtonItem.enabled = YES;

    NSURL *videoFileUrl = [NSURL fileURLWithPath:self.originalVideoPath];

    AVAsset *anAsset = [[AVURLAsset alloc] initWithURL:videoFileUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {

        self.exportSession = [[AVAssetExportSession alloc]
                              initWithAsset:anAsset presetName:AVAssetExportPresetPassthrough];
        // Implementation continues.

        NSURL *furl = [NSURL fileURLWithPath:self.tmpVideoPath];

        self.exportSession.outputURL = furl;
        self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;

        CMTime start = CMTimeMakeWithSeconds(self.startTime, anAsset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(self.stopTime-self.startTime, anAsset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        self.exportSession.timeRange = range;

        self.trimBtn.hidden = YES;
        self.myActivityIndicator.hidden = NO;
        [self.myActivityIndicator startAnimating];
        [self.exportSession exportAsynchronouslyWithCompletionHandler:^{

            switch ([self.exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    self.myActivityIndicator.hidden = YES;
                    NSLog(@"Export failed: %@", [[self.exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    self.myActivityIndicator.hidden = YES;
                    NSLog(@"Export canceled");
                    break;
                default:
                    NSLog(@"NONE");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.myActivityIndicator stopAnimating];
                        self.myActivityIndicator.hidden = YES;
                        self.trimBtn.hidden = NO;
                        [self playMovie:self.tmpVideoPath];
                    });

                    break;
            }
        }];

    }

}


#pragma mark - Other
-(void)deleteTmpFile{

    NSURL *url = [NSURL fileURLWithPath:self.tmpVideoPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NSLog(@"file deleted");
        if (err) {
            NSLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        NSLog(@"no file by that name");
    }
}


-(void)playMovie: (NSString *) path{
    NSURL *url = [NSURL fileURLWithPath:path];
    MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:theMovie];
    theMovie.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [theMovie.moviePlayer play];
}


#pragma mark - SAVideoRangeSliderDelegate

- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition
{
    self.startTime = leftPosition;
    self.stopTime = rightPosition;
    self.timeLabel.text = [NSString stringWithFormat:@"%.0fs - %.0fs", leftPosition, rightPosition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
