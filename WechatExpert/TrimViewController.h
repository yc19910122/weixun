//
//  TrimViewController.h
//  WechatExpert
//
//  Created by User #⑨ on 14-4-17.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface TrimViewController : UIViewController
//
//@end

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SAVideoRangeSlider.h"


@interface TrimViewController : UIViewController<SAVideoRangeSliderDelegate>

@property (nonatomic) id delegate;
@property (strong, nonatomic) NSString *VideoName;
@property (strong, nonatomic) NSString *originalVideoPath;
@property (strong, nonatomic) NSString *VideoTime;

@property (strong, nonatomic) SAVideoRangeSlider *mySAVideoRangeSlider;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) AVAssetExportSession *exportSession;

@property (strong, nonatomic) NSString *tmpVideoPath;
@property (nonatomic) CGFloat startTime;
@property (nonatomic) CGFloat stopTime;
@property (weak, nonatomic) UIActivityIndicatorView *myActivityIndicator;
@property (weak, nonatomic) UIButton *trimBtn;

@end

@protocol TrimViewControllerDelegate <NSObject>

- (void)TrimController:(TrimViewController *)controller didFinishTrimVideo:(NSString *)NewVideo Video:(NSString *)Video;
- (void)TrimControllerDidCancel:(TrimViewController *)controller;

@end