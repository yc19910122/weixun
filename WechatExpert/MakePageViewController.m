//
//  MakePageViewController.m
//  WechatExpert
//
//  Created by User #⑨ on 14-3-4.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import "MakePageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface MakePageViewController ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    UITextField *bigTitle;
    UITextField *littleTitle;

    UITextView *text;

    UIScrollView *scroll;

    UIView *shuruView;
    UITextView *shuruText;
    UIView *ZGView;
    UIImagePickerController *camera;

    NSMutableArray *MessageDic;

    NSMutableDictionary *sendMessage;

    int tag;

    MBProgressHUD *mb;

    UIView *chooseView;

    BOOL repwrite;

    int whichPic;

    BOOL IsVideo;

    NSString *bigText;
    NSString *littleText;

    NSURL *_videoURL;
    BOOL _hasVideo;
    UIAlertView *_alert;
    NSString *_mp4Path;
    NSDate *_startDate;

    BOOL isNow;
}

@property int gaodu;
@end

@implementation MakePageViewController
@synthesize gaodu;

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
//    self.navigationController.navigationBar.topItem.title = @"制作网页";
    IsVideo = YES;
    whichPic = 0;
    repwrite = NO;
    _hasVideo = NO;
    isNow = YES;
    tag = 1;
    MessageDic = [[NSMutableArray alloc]init];

    gaodu = 95;

    camera = [[UIImagePickerController alloc]init];
    camera.delegate = self;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"微网页制作";
    title.textAlignment = NSTextAlignmentCenter;
    title.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = title;

    UIButton *rightBtn = [UIButton buttonWithType:0];
    [rightBtn setFrame:CGRectMake(0, 0, 35, 35)];
    [rightBtn setTitle:@"预览" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [rightBtn addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;

    UIButton *leftBtn = [UIButton buttonWithType:0];
    [leftBtn setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backToIndex) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;

    int flag = Height(Version);
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-flag)];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.backgroundColor = [UIColor clearColor];
    scroll.userInteractionEnabled = YES;
    [self.view addSubview:scroll];
    [scroll setContentSize:CGSizeMake(320, self.view.frame.size.height-flag)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tap:)];
    [scroll addGestureRecognizer:tap];

    [self drawPage];
}

- (void)Tap:(UITapGestureRecognizer *)sender
{
    [self hidenChooseView];

    [bigTitle resignFirstResponder];
    [littleTitle resignFirstResponder];
}

- (void)backToIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        [bigTitle becomeFirstResponder];
    }else{
        //删除图片
        [MessageDic removeObjectAtIndex:alertView.tag-1];
        [self RepdrawContent];
    }
}

- (void)showRight
{
    [bigTitle resignFirstResponder];
    [littleTitle resignFirstResponder];

    if ([bigTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主标题不能为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alt.tag = 0;
        [alt show];
        return;
    }
    mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mb.labelText = @"正在生成预览";

    [self performSelector:@selector(startSc) withObject:Nil afterDelay:0.3];
}

- (void)startSc
{
    PreviewPageViewController *pre = [[PreviewPageViewController alloc]init];
    pre.bigTitle = bigTitle.text;
    pre.littleTitle = littleTitle.text;
    pre.NewsMessage = MessageDic;
    pre.Where = 1;
    [self.navigationController pushViewController:pre animated:YES];
    [mb hide:YES];
}

- (void)drawPage
{
    bigTitle = [[UITextField alloc]initWithFrame:CGRectMake(0, 5, scroll.frame.size.width, 50)];
    bigTitle.backgroundColor = [UIColor clearColor];
    bigTitle.placeholder = @"主标题";
    bigTitle.textAlignment = NSTextAlignmentCenter;
    bigTitle.textColor = [UIColor blackColor];
    bigTitle.font = [UIFont boldSystemFontOfSize:23.0f];
    bigTitle.delegate = self;
    bigTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    bigTitle.returnKeyType = UIReturnKeyDone;
    [scroll addSubview:bigTitle];

    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(20, 57, 280, 1)];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.2;
    [scroll addSubview:line];

    littleTitle = [[UITextField alloc]initWithFrame:CGRectMake(0, 5+50, scroll.frame.size.width, 50)];
    littleTitle.backgroundColor = [UIColor clearColor];
    littleTitle.placeholder = @"副标题";
    littleTitle.textAlignment = NSTextAlignmentCenter;
    littleTitle.textColor = [UIColor blackColor];
    littleTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    littleTitle.delegate = self;
    littleTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    littleTitle.returnKeyType = UIReturnKeyDone;
    [scroll addSubview:littleTitle];

    UIButton *add = [UIButton buttonWithType:0];
    [add setFrame:CGRectMake((self.view.frame.size.width-96)/2, self.view.frame.size.height-34, 96, 34)];
    [add setImage:[UIImage imageNamed:@"jh.png"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)add
{
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    [menuView addMenuItemWithTitle:@"文字" andIcon:[UIImage imageNamed:@"wz.png"] andSelectedBlock:^{
        [self showTxt:Nil tag:1];
    }];
    [menuView addMenuItemWithTitle:@"拍照" andIcon:[UIImage imageNamed:@"tp.png"] andSelectedBlock:^{
        IsVideo = NO;
        [self ChoosePic:1];
    }];
    [menuView addMenuItemWithTitle:@"相册" andIcon:[UIImage imageNamed:@"pp.png"] andSelectedBlock:^{
        IsVideo = NO;
        [self ChoosePic:2];
    }];
//    [menuView addMenuItemWithTitle:@"视频" andIcon:[UIImage imageNamed:@"sp.png"] andSelectedBlock:^{
//        IsVideo = YES;
//        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"摄像机",@"本地视频", nil];
//        sheet.tag = 10000;
//        [sheet showInView:self.view];
//    }];
//    [menuView addMenuItemWithTitle:@"背景" andIcon:[UIImage imageNamed:@"bgIcon.png"] andSelectedBlock:^{
//
//    }];

    [menuView show];
}

- (void)makeVideo:(int)xx
{
    if (xx == 1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        imagePicker.videoMaximumDuration = 12;//限制视频的拍摄时间为12秒
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        imagePicker.videoQuality = 0;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)ChoosePic:(int)x
{
    if (x == 2) {
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        camera.sourceType=UIImagePickerControllerSourceTypeCamera;
    }else{
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        camera.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    camera.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:camera animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (IsVideo == YES) {
        _videoURL = info[UIImagePickerControllerMediaURL];
//        NSString *str = [NSString stringWithFormat:@"%d mb", [self getFileSize:[[_videoURL absoluteString] substringFromIndex:16]]/1024];
        NSString *lstr = [NSString stringWithFormat:@"%f", [self getVideoDuration:_videoURL]];
        _hasVideo = YES;
//        NSLog(@"str = %@,lstr = %@",str,lstr);
//        NSMutableArray *arr = [NSMutableArray arrayWithObjects:str,lstr, nil];
        [self dismissViewControllerAnimated:YES completion:^{
            if (isNow == NO) {
                [self openTrim:[NSString stringWithFormat:@"%@",_videoURL] time:lstr];
            }else
                [self SaveVideo:1];
        }];
    }else{
        UIImage *image2 = [ImageSizeManager getMaxImageWithOldImage:info[UIImagePickerControllerOriginalImage]];

        [picker dismissViewControllerAnimated:YES completion:^{
            [self openEditor:[UIImage imageWithData:UIImageJPEGRepresentation(image2, 1)]];
        }];
    }
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1000;
    }
    return 0;
}

- (CGFloat) getVideoDuration:(NSURL*) URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

//获取视频第一帧的图片
- (UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

- (void)openTrim:(NSString *)videoURL time:(NSString *)VideoTime
{
    if ([VideoTime intValue] <= 12) {
        [self SaveVideo:1];
    }else{
        [self SaveVideo:[VideoTime intValue]];
//        TrimVideoViewController *trim = [[TrimVideoViewController alloc]init];
//        trim.delegate = self;
//        trim.originalVideoPath = videoURL;
//        trim.VideoTime = VideoTime;
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:trim];
//
//        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}

- (void)TrimController:(TrimViewController *)controller didFinishTrimVideo:(NSString *)NewVideo Video:(NSString *)Video
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"%@",NewVideo);
    [self TrimVideo:NewVideo name:Video];
}

- (void)TrimControllerDidCancel:(TrimViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)TrimVideo:(NSString *)time name:(NSString *)name
{
    UIImage *cropImage = [[UIImage alloc]init];
    cropImage = [self getImage:time];
    float bl = 270/cropImage.size.width;
    //270, 180
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(35, gaodu, 270, 180)];
    view.backgroundColor = [UIColor clearColor];
    view.clipsToBounds = YES;
    [scroll addSubview:view];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cropImage.size.width*bl, cropImage.size.height*bl)];
    imageView.image = cropImage;
    [view addSubview:imageView];

    UILabel *length = [[UILabel alloc]initWithFrame:CGRectMake(0, 165, 260, 15)];
    length.textAlignment = NSTextAlignmentRight;
    length.backgroundColor = [UIColor clearColor];
    length.font = [UIFont systemFontOfSize:12.f];
    length.textColor = [UIColor colorWithRed:251/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    length.text = [NSString stringWithFormat:@"%.1fMB 12s",(float)[self fileSizeAtPath:time]/1000];
    [view addSubview:length];

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 270, 180)];
    image.image = [UIImage imageNamed:@"bofangIcon.png"];
    [view addSubview:image];

    UIButton *tpIcon = [UIButton buttonWithType:0];
    [tpIcon setImage:[UIImage imageNamed:@"SPIcon.png"] forState:UIControlStateNormal];
    [tpIcon setFrame:CGRectMake(5, gaodu+3, 25, 25)];
    [tpIcon setTag:tag];
    [tpIcon addTarget:self action:@selector(tpIconPass:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tpIcon];

    gaodu = gaodu + 3 + view.frame.size.height;
    [scroll setContentSize:CGSizeMake(self.view.frame.size.width, gaodu+30)];

    NSArray *arr = [NSArray arrayWithObjects:length.text,@"12s",name, nil];
    NSDictionary *message = [[NSDictionary alloc]initWithObjectsAndKeys:@"2",@"type",arr,@"content",[NSString stringWithFormat:@"%d",tag++],@"sort", nil];
    [MessageDic addObject:message];
}

- (void)SaveVideo:(int)x
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];

    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])

    {
        _alert = [[UIAlertView alloc] init];
        [_alert setTitle:@"请等待视频转码..."];

        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(140,
                                    80,
                                    CGRectGetWidth(_alert.frame),
                                    CGRectGetHeight(_alert.frame));
        [_alert addSubview:activity];
        [activity startAnimating];
        [_alert show];
        _startDate = [NSDate date];

        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetMediumQuality];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *now;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        now=[NSDate date];
        comps = [calendar components:unitFlags fromDate:now];

        NSString *time = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld.mp4",(long)[comps year],(long)[comps month],(long)[comps day],(long)[comps hour],(long)[comps minute],(long)[comps second]];
        if (x == 1) {
            _mp4Path = [NSString stringWithFormat:@"%@/%@",[ShareData dataPath],time];
        }else{
            NSString *tempDir = NSTemporaryDirectory();
            NSString *tmpVideoPath = [tempDir stringByAppendingPathComponent:time];
            _mp4Path = tmpVideoPath;
        }

        exportSession.outputURL = [NSURL fileURLWithPath: _mp4Path];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    [_alert dismissWithClickedButtonIndex:0 animated:NO];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[[exportSession error] localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                    break;
                }

                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    [_alert dismissWithClickedButtonIndex:0
                                                 animated:YES];
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    if (x == 1) {
                        NSString *tempDir = NSTemporaryDirectory();
                        NSString *path = [tempDir stringByAppendingPathComponent:time];
                        NSString *str = [NSString stringWithFormat:@"%.1fMB", (float)[self fileSizeAtPath:path]/1000];
//                        NSString *lstr = [NSString stringWithFormat:@"%.0fs", [self getVideoDuration:_videoURL]];
                        NSString *lstr = @"12s";
                        NSLog(@"str = %@,lstr = %@",str,lstr);
                        NSMutableArray *arr = [NSMutableArray arrayWithObjects:str,lstr,time, nil];
                        NSLog(@"Successful!");
                        if (repwrite == YES) {
                            [self performSelectorOnMainThread:@selector(repDrawVideo:) withObject:arr waitUntilDone:NO];
                        }else
                            [self performSelectorOnMainThread:@selector(drawVideo:) withObject:arr waitUntilDone:NO];
                        break;
                    }else{
                        TrimViewController *trim = [[TrimViewController alloc]init];
                        trim.delegate = self;
                        trim.originalVideoPath = _mp4Path;
                        trim.VideoTime = [NSString stringWithFormat:@"%d",x];
                        trim.VideoName = time;
                        [self performSelectorOnMainThread:@selector(gotrim:) withObject:trim waitUntilDone:NO];
                        break;
                    }
                }
                default:
                    break;
            }
        }];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"AVAsset doesn't support mp4 quality"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)gotrim:(TrimViewController *)trim
{
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:trim];

    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)repDrawVideo:(NSString *)time
{
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:time forKey:@"content"];
    [dic setObject:[[MessageDic objectAtIndex:whichPic-1] objectForKey:@"sort"] forKey:@"sort"];
    [dic setObject:[[MessageDic objectAtIndex:whichPic-1] objectForKey:@"type"] forKey:@"type"];
    [MessageDic replaceObjectAtIndex:whichPic-1 withObject:dic];
    [self RepdrawContent];
    repwrite = NO;
    whichPic = 0;
}

- (void)drawVideo:(NSArray *)time
{
    NSString *tempDir = NSTemporaryDirectory();
    NSString *path = [tempDir stringByAppendingPathComponent:[time objectAtIndex:3]];

    UIImage *cropImage = [[UIImage alloc]init];
    cropImage = [self getImage:path];
    float bl = 270/cropImage.size.width;
    //270, 180
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(35, gaodu, 270, 180)];
    view.backgroundColor = [UIColor clearColor];
    view.clipsToBounds = YES;
    [scroll addSubview:view];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cropImage.size.width*bl, cropImage.size.height*bl)];
    imageView.image = cropImage;
    [view addSubview:imageView];

    UILabel *length = [[UILabel alloc]initWithFrame:CGRectMake(0, 165, 260, 15)];
    length.textAlignment = NSTextAlignmentRight;
    length.backgroundColor = [UIColor clearColor];
    length.font = [UIFont systemFontOfSize:12.f];
    length.textColor = [UIColor colorWithRed:251/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    length.text = [NSString stringWithFormat:@"%@ %@",[time objectAtIndex:0],[time objectAtIndex:1]];
    [view addSubview:length];

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 270, 180)];
    image.image = [UIImage imageNamed:@"bofangIcon.png"];
    [view addSubview:image];
    
    UIButton *tpIcon = [UIButton buttonWithType:0];
    [tpIcon setImage:[UIImage imageNamed:@"SPIcon.png"] forState:UIControlStateNormal];
    [tpIcon setFrame:CGRectMake(5, gaodu+3, 25, 25)];
    [tpIcon setTag:tag];
    [tpIcon addTarget:self action:@selector(tpIconPass:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tpIcon];

    gaodu = gaodu + 3 + view.frame.size.height;
    [scroll setContentSize:CGSizeMake(self.view.frame.size.width, gaodu+30)];

    NSDictionary *message = [[NSDictionary alloc]initWithObjectsAndKeys:@"2",@"type",time,@"content",[NSString stringWithFormat:@"%d",tag++],@"sort", nil];
    [MessageDic addObject:message];

    [_alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)openEditor:(UIImage *)image
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];

    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];

    NSString *time = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld.jpg",(long)[comps year],(long)[comps month],(long)[comps day],(long)[comps hour],(long)[comps minute],(long)[comps second]];
    NSString *bgFilePath = [NSString stringWithFormat:@"%@/%@",[ShareData dataPath],time];
    NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(croppedImage,1)];

    [data1 writeToFile:bgFilePath atomically:YES];

    if (repwrite == YES) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:time forKey:@"content"];
        [dic setObject:[[MessageDic objectAtIndex:whichPic-1] objectForKey:@"sort"] forKey:@"sort"];
        [dic setObject:[[MessageDic objectAtIndex:whichPic-1] objectForKey:@"type"] forKey:@"type"];
        [MessageDic replaceObjectAtIndex:whichPic-1 withObject:dic];
        [self RepdrawContent];
        repwrite = NO;
        whichPic = 0;
    }else
        [self drawImage:croppedImage name:time];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)tpIconPass:(UIButton *)sender
{
    [chooseView removeFromSuperview];

    bigText = bigTitle.text;
    littleText = littleTitle.text;

    if ([[[MessageDic objectAtIndex:sender.tag-1] objectForKey:@"type"] isEqualToString:@"1"]) {
        [self showChooseListBtn:1 txt:[[MessageDic objectAtIndex:sender.tag-1] objectForKey:@"content"] size:sender.frame.origin button:sender];
    }else if ([[[MessageDic objectAtIndex:sender.tag-1] objectForKey:@"type"] isEqualToString:@"2"]){
        [self showChooseListBtn:3 txt:[[MessageDic objectAtIndex:sender.tag-1] objectForKey:@"content"] size:sender.frame.origin button:sender];
    }else
        [self showChooseListBtn:2 txt:[[MessageDic objectAtIndex:sender.tag-1] objectForKey:@"content"] size:sender.frame.origin button:sender];
}

- (void)showChooseListBtn:(int)y txt:(NSString *)txt size:(CGPoint)origin button:(UIButton *)btn
{
    chooseView = [[UIView alloc]initWithFrame:CGRectMake(origin.x+12.5, origin.y, 0, 25)];
    [chooseView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"chooseListBg.png"]]];
    chooseView.clipsToBounds = YES;
    [scroll insertSubview:chooseView belowSubview:btn];

    UIButton *bianji = [UIButton buttonWithType:0];
    [bianji setFrame:CGRectMake(19, 0, 25, 25)];
    [bianji setTag:btn.tag];
    [bianji setImage:[UIImage imageNamed:@"bj.png"] forState:UIControlStateNormal];
    if (y == 1) {
        [bianji addTarget:self action:@selector(bianjiBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else if (y == 3){
        [bianji addTarget:self action:@selector(VideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
        [bianji addTarget:self action:@selector(PicBtn:) forControlEvents:UIControlEventTouchUpInside];

    [chooseView addSubview:bianji];

    UIButton *dele = [UIButton buttonWithType:0];
    [dele setFrame:CGRectMake(48, 0, 25, 25)];
    [dele setTag:btn.tag];
    [dele setImage:[UIImage imageNamed:@"sc.png"] forState:UIControlStateNormal];
    [dele addTarget:self action:@selector(delet:) forControlEvents:UIControlEventTouchUpInside];
    [chooseView addSubview:dele];

    [self showChooseView];
}

- (void)VideoBtn:(UIButton *)sender
{
    repwrite = YES;
    whichPic = sender.tag;
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"摄像机",@"本地视频", nil];
    sheet.tag = 10000;
    [sheet showInView:self.view];
}

- (void)bianjiBtn:(UIButton *)sender
{
    repwrite = YES;
    [self showTxt:[[MessageDic objectAtIndex:sender.tag-1] objectForKey:@"content"] tag:(int)sender.tag];
}

- (void)PicBtn:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:Nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:Nil otherButtonTitles:@"相册",@"拍照", nil];
    sheet.tag = sender.tag;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10000) {
        if (buttonIndex == 0) {
            //拍摄
            isNow = YES;
            [self makeVideo:1];
        }else if (buttonIndex == 1) {
            //选择
            isNow = NO;
            [self makeVideo:2];
        }else{
            whichPic = 0;
            repwrite = NO;
        }
    }else{
        if (buttonIndex == 0) {
            whichPic = (int)actionSheet.tag;
            repwrite = YES;
            [self ChoosePic:1];
        }
        if (buttonIndex == 1){
            whichPic = (int)actionSheet.tag;
            repwrite = YES;
            [self ChoosePic:2];
        }
    }
}

- (void)delet:(UIButton *)sender
{
    UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要删除此处的信息吗？" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
    alt.tag = sender.tag;
    [alt show];
}

- (void)showChooseView
{
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationDuration:0.3];
    [chooseView setFrame:CGRectMake(chooseView.frame.origin.x, chooseView.frame.origin.y, 78, 25)];
    [UIView commitAnimations];
}

- (void)hidenChooseView
{
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationDuration:0.3];
    [chooseView setFrame:CGRectMake(chooseView.frame.origin.x, chooseView.frame.origin.y, 0, 25)];
    [UIView commitAnimations];
//    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)drawImage:(UIImage *)image name:(NSString *)name
{
    UIImage *cropImage = [[UIImage alloc]init];
    cropImage = image;
    float bl = 270/cropImage.size.width;
    //270, 180
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, gaodu, cropImage.size.width*bl, cropImage.size.height*bl)];
    imageView.image = image;
    [scroll addSubview:imageView];

    UIButton *tpIcon = [UIButton buttonWithType:0];
    [tpIcon setImage:[UIImage imageNamed:@"tpIcon.png"] forState:UIControlStateNormal];
    [tpIcon setFrame:CGRectMake(5, gaodu+3, 25, 25)];
    [tpIcon setTag:tag];
    [tpIcon addTarget:self action:@selector(tpIconPass:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tpIcon];

    gaodu = gaodu + 3 + imageView.frame.size.height;
    [scroll setContentSize:CGSizeMake(self.view.frame.size.width, gaodu+30)];

    NSDictionary *message = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"type",name,@"content",[NSString stringWithFormat:@"%d",tag++],@"sort", nil];
    [MessageDic addObject:message];
}

- (void)showTxt:(NSString *)str tag:(int)x
{
//    int flag = Height(Version);
    ZGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    ZGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gaiPic.png"]];
    ZGView.alpha = 1.0;
    [self.view addSubview:ZGView];

    shuruView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 181)];
    shuruView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shuruView.png"]];
    [self.view addSubview:shuruView];

    UIButton *Cancel = [UIButton buttonWithType:0];
    [Cancel setFrame:CGRectMake(15, 5, 32, 32)];
    [Cancel setImage:[UIImage imageNamed:@"Cancel.png"] forState:UIControlStateNormal];
    [Cancel addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    [shuruView addSubview:Cancel];

    UIButton *Queding = [UIButton buttonWithType:0];
    [Queding setFrame:CGRectMake(279, 5, 32, 32)];
    [Queding setImage:[UIImage imageNamed:@"Queding.png"] forState:UIControlStateNormal];
    [Queding setTag:x];
    [Queding addTarget:self action:@selector(Queding:) forControlEvents:UIControlEventTouchUpInside];
    [shuruView addSubview:Queding];

    shuruText = [[UITextView alloc]initWithFrame:CGRectMake(15, 45, 290, 95)];
    shuruText.backgroundColor = [UIColor clearColor];
    shuruText.font = [UIFont systemFontOfSize:18.f];
    shuruText.delegate = self;
    shuruText.text = str;
    [shuruView addSubview:shuruText];

    [shuruText becomeFirstResponder];
}

- (void)Cancel
{
    [shuruText resignFirstResponder];
}

- (void)Queding:(UIButton *)sender
{
    [shuruText resignFirstResponder];
    if (repwrite == YES) {
//        NSMutableDictionary *dic = [MessageDic objectAtIndex:sender.tag-1];
//        [[MessageDic objectAtIndex:sender.tag] setObject:shuruText.text forKey:@"content"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:shuruText.text forKey:@"content"];
        [dic setObject:[[MessageDic objectAtIndex:sender.tag-1] objectForKey:@"sort"] forKey:@"sort"];
        [dic setObject:[[MessageDic objectAtIndex:sender.tag-1] objectForKey:@"type"] forKey:@"type"];
        [MessageDic replaceObjectAtIndex:sender.tag-1 withObject:dic];
        repwrite = NO;
        [self RepdrawContent];
    }else
        [self drawContent:shuruText.text];
}

- (void)drawContent:(NSString *)txt
{
    UIFont *font = [UIFont systemFontOfSize:20.f];
    CGFloat height = [txt sizeWithFont:font constrainedToSize:CGSizeMake(270, 4000) lineBreakMode:NSLineBreakByWordWrapping].height;

    if (height < 25) {
        height = 25;
    }
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(35, gaodu, 270, height)];
    lab.backgroundColor = [UIColor clearColor];
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:20.f];
    lab.text = txt;
    lab.textColor = [UIColor colorWithRed:60/255.0 green:57/255.0 blue:57/255.0 alpha:1];
    [scroll addSubview:lab];

    UIButton *tpIcon = [UIButton buttonWithType:0];
    [tpIcon setImage:[UIImage imageNamed:@"wzIcon.png"] forState:UIControlStateNormal];
    [tpIcon setFrame:CGRectMake(5, gaodu, 25, 25)];
    [tpIcon setTag:tag];
    [tpIcon addTarget:self action:@selector(tpIconPass:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tpIcon];

    gaodu = gaodu+height+3;

    [scroll setContentSize:CGSizeMake(self.view.frame.size.width, gaodu+30)];
    NSDictionary *message = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"type",txt,@"content",[NSString stringWithFormat:@"%d",tag++],@"sort", nil];
    [MessageDic addObject:message];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
    [shuruView setFrame:CGRectMake(0, self.view.frame.size.height-175-216, 320, 181)];
    ZGView.alpha = 0.3;
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
    [shuruView setFrame:CGRectMake(0, self.view.frame.size.height, 320, 181)];
    ZGView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)RepdrawContent
{
    NSArray *a=[scroll subviews];
    UIControl *tempCtr;
    int n=(int)a.count;
    for (int i=0;i<n;i++){
        tempCtr=(UIControl *)[a objectAtIndex:i];
        [tempCtr removeFromSuperview];
    }
    [self drawPage];
    bigTitle.text = bigText;
    littleTitle.text = littleText;
    gaodu = 95;
    tag = 1;
    for (int i = 0; i < MessageDic.count; i++) {
        if ([[[MessageDic objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"1"]) {
            UIFont *font = [UIFont systemFontOfSize:20.f];
            CGFloat height = [[[MessageDic objectAtIndex:i] objectForKey:@"content"] sizeWithFont:font constrainedToSize:CGSizeMake(270, 4000) lineBreakMode:NSLineBreakByWordWrapping].height;

            if (height < 25) {
                height = 25;
            }
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(35, gaodu, 270, height)];
            lab.backgroundColor = [UIColor clearColor];
            lab.numberOfLines = 0;
            lab.font = [UIFont systemFontOfSize:20.f];
            lab.text = [[MessageDic objectAtIndex:i] objectForKey:@"content"];
            lab.textColor = [UIColor colorWithRed:60/255.0 green:57/255.0 blue:57/255.0 alpha:1];
            [scroll addSubview:lab];

            UIButton *tpIcon = [UIButton buttonWithType:0];
            [tpIcon setImage:[UIImage imageNamed:@"wzIcon.png"] forState:UIControlStateNormal];
            [tpIcon setFrame:CGRectMake(5, gaodu, 25, 25)];
            [tpIcon setTag:tag];
            [tpIcon addTarget:self action:@selector(tpIconPass:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:tpIcon];
            
            gaodu = gaodu+height+3;
            
        }else if ([[[MessageDic objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"2"]){
            UIImage *cropImage = [[UIImage alloc]init];
            cropImage = [self getImage:[NSString stringWithFormat:@"%@/%@",[ShareData dataPath],[[[MessageDic objectAtIndex:i] objectForKey:@"content"] objectAtIndex:2]]];
            float bl = 270/cropImage.size.width;
            //270, 180
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(35, gaodu, 270, 180)];
            view.backgroundColor = [UIColor clearColor];
            view.clipsToBounds = YES;
            [scroll addSubview:view];

            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cropImage.size.width*bl, cropImage.size.height*bl)];
            imageView.image = cropImage;
            [view addSubview:imageView];

            UILabel *length = [[UILabel alloc]initWithFrame:CGRectMake(0, 165, 260, 15)];
            length.textAlignment = NSTextAlignmentRight;
            length.backgroundColor = [UIColor clearColor];
            length.font = [UIFont systemFontOfSize:11.f];
            length.text = [NSString stringWithFormat:@"%@ %@",[[[MessageDic objectAtIndex:i] objectForKey:@"content"] objectAtIndex:0],[[[MessageDic objectAtIndex:i] objectForKey:@"content"] objectAtIndex:1]];
            [view addSubview:length];

            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 270, 180)];
            image.image = [UIImage imageNamed:@"bofangIcon.png"];
            [view addSubview:image];

            UIButton *tpIcon = [UIButton buttonWithType:0];
            [tpIcon setImage:[UIImage imageNamed:@"SPIcon.png"] forState:UIControlStateNormal];
            [tpIcon setFrame:CGRectMake(5, gaodu+3, 25, 25)];
            [tpIcon setTag:tag];
            [tpIcon addTarget:self action:@selector(tpIconPass:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:tpIcon];

            gaodu = gaodu + 3 + view.frame.size.height;
            
        }else{
            NSString *str = [NSString stringWithFormat:@"%@/%@",[ShareData dataPath],[[MessageDic objectAtIndex:i] objectForKey:@"content"]];
            UIImage *image = [UIImage imageWithContentsOfFile:str];
            float bl = 270/image.size.width;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, gaodu, image.size.width*bl, image.size.height*bl)];
            imageView.image = image;
            [scroll addSubview:imageView];

            UIButton *tpIcon = [UIButton buttonWithType:0];
            [tpIcon setImage:[UIImage imageNamed:@"tpIcon.png"] forState:UIControlStateNormal];
            [tpIcon setFrame:CGRectMake(5, gaodu+3, 25, 25)];
            [tpIcon setTag:tag];
            [tpIcon addTarget:self action:@selector(tpIconPass:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:tpIcon];

            gaodu = gaodu + 3 + imageView.frame.size.height;
        }
        [scroll setContentSize:CGSizeMake(self.view.frame.size.width, gaodu+30)];
        tag++;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
