//
//  ShareData.h
//  WechatExpert
//
//  Created by User #⑨ on 14-3-3.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareData : NSObject

+ (ShareData *)shared;
+ (id) allocWithZone:(NSZone *)zone;

@property BOOL isSign;
@property BOOL isNew;
@property (strong, nonatomic) NSString *PageNumber;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSArray *listDic;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSArray *message;
@property (strong, nonatomic) NSString *wifi;

+ (NSString *)bgImage;
+ (NSString *)dataPath;
+ (NSString*)getTimeAndRandom;
@end
