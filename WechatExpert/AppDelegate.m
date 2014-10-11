//
//  AppDelegate.m
//  WechatExpert
//
//  Created by User #⑨ on 14-3-3.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [ShareData shared].PageNumber = 0;
    [ShareData shared].listDic = nil;
    [ShareData shared].isNew = NO;

    BOOL Flag = [self IsEnableWIFI];
    if (Flag == YES) {
        [ShareData shared].image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[ShareData bgImage]]]];
    }
    
    _homePage = [[HomePageViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_homePage];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [WXApi registerApp:@"wx5711daf42e137b8f"];

    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"101047408" andDelegate:self];

    return YES;
}

- (BOOL) IsEnableWIFI {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    BOOL aa;
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            aa = NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            aa = NO;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            aa = YES;
            break;
    }
    return aa;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [TencentOAuth HandleOpenURL:url];
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [TencentOAuth HandleOpenURL:url];
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
