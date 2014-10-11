//
//  PreviewPageViewController.h
//  WechatExpert
//
//  Created by User #⑨ on 14-3-10.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewPageViewController : UIViewController

@property (strong, nonatomic) NSString *NumberID;
@property (strong, nonatomic) NSString *bigTitle;
@property (strong, nonatomic) NSString *littleTitle;
@property (strong, nonatomic) NSArray *NewsMessage;
@property int Where;
@end
