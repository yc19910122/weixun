//
//  LoginPageViewController.h
//  WechatExpert
//
//  Created by User #⑨ on 14-3-10.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginPageViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData*_appListData;
    NSURLConnection *_appListFeedConnection;
}

@property(nonatomic,retain) NSMutableData *appListData;
@property(nonatomic,retain) NSURLConnection *appListFeedConnection;

@end
