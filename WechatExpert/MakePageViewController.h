//
//  MakePageViewController.h
//  WechatExpert
//
//  Created by User #⑨ on 14-3-4.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MakePageViewController : UIViewController

//@property (nonatomic, unsafe_unretained) id<MakePageViewControllerDelegate> delegate;
- (void)drawContent:(NSString *)txt;
@end
