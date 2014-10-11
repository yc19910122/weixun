//
//  AppDelegate.h
//  WechatExpert
//
//  Created by User #⑨ on 14-3-3.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,TencentSessionDelegate>
{
    HomePageViewController *_homePage;
    TencentOAuth *_tencentOAuth;
}

@property (strong, nonatomic) UIWindow *window;

@end
