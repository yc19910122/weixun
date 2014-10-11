//
//  ShareData.m
//  WechatExpert
//
//  Created by User #⑨ on 14-3-3.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import "ShareData.h"

@implementation ShareData
@synthesize isSign,isNew;
@synthesize username;
@synthesize uid;
@synthesize PageNumber;
@synthesize listDic;
@synthesize image;
@synthesize message;
@synthesize wifi;

static ShareData *ShareDataPist = nil;

+(ShareData *) shared{

    @synchronized(self)
    {
        if (ShareDataPist == nil)
        {
            ShareDataPist = [[self alloc] init] ;

        }
    }
    return ShareDataPist;
}

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (ShareDataPist == nil)
        {
            ShareDataPist = [super allocWithZone:zone];
            return ShareDataPist;
        }
    }
    return nil;
}

+ (NSString *)bgImage
{
    NSString *str = @"http://mg.ideer.cn/Weixintool/Api/bgimg";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    NSURLResponse *urlResponce=nil;
    NSError *error=nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponce error:&error];
    if (error) {
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不可用,请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return [dic objectForKey:@"url"];
}

+ (NSString *)dataPath
{
    NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageDir = [NSString stringWithFormat:@"%@/image", path];//设置文件夹的名字与路径

    BOOL isDir = NO;             //个人感觉是可有可无的
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )  //判断文件夹是否存在
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
    }
    return imageDir;
}

+(NSString*)getTimeAndRandom
{
    srand((unsigned)time(0));
    int iRandom=arc4random();
    if (iRandom<0) {
        iRandom=-iRandom;
    }

    NSDateFormatter *tFormat = [[NSDateFormatter alloc] init];
    [tFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *tResult=[NSString stringWithFormat:@"%@%d",[tFormat stringFromDate:[NSDate date]],iRandom];
    return tResult;
}

@end
