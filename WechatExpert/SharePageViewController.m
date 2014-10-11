//
//  SharePageViewController.m
//  WeiXinTong
//
//  Created by User #⑨ on 13-12-27.
//  Copyright (c) 2013年 Yang Chao. All rights reserved.
//

#import "SharePageViewController.h"

@interface SharePageViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *table;
    NSArray *imageArray;
    NSArray *titleArray;

    int type;
}

@end

@implementation SharePageViewController
@synthesize Bigtitle,ChildTitle;
@synthesize url;

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
    UIImage *navBg = [[UIImage alloc]init];
    if (Version >= 7.0) {
        navBg = [UIImage imageNamed:@"ios7.png"];
    }else
        navBg = [UIImage imageNamed:@"ios6.png"];
    [self.navigationController.navigationBar setBackground:navBg];

    [[self navigationController] setNavigationBarHidden:NO animated:YES];

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"分享";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = title;

    UIButton *leftBtn = [UIButton buttonWithType:0];
    [leftBtn setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;

    titleArray = [NSArray arrayWithObjects:@"分享给朋友",@"分享到朋友圈",@"分享到QQ",@"分享到QQ空间",@"回到首页", nil];
    imageArray = [NSArray arrayWithObjects:@"SendFri.png",@"SendQuan.png",@"SendQQ.png",@"SendQZone.png",@"SaveLoc.png", nil];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    table.delegate = self;
    table.dataSource  = self;
    [self.view addSubview:table];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
    }
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(37, 15, 35, 35)];
    titleImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:titleImage];

    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(108, 0, 212, 64)];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = [titleArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:lab];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.row == 0) {
        type = 0;
        [self sendLinkContent];
    }else if (indexPath.row == 1){
        type = 1;
        [self sendLinkContent];
    }else if (indexPath.row == 2){
        [self sendQQ:1];
    }else if (indexPath.row == 3){
        [self sendQQ:2];
    }else{
        [self repListDic];
        if ([ShareData shared].isNew == NO) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }else
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
}

- (void)deleteDir
{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *imageDir = [ShareData dataPath];
    NSArray *array = [fileManage contentsOfDirectoryAtPath:imageDir error:nil];
    for (int j=0; j<[array count]; j++) {
        NSString *str = [NSString stringWithFormat:@"%@/%@",imageDir,[array objectAtIndex:j]];
        [fileManage removeItemAtPath:str error:Nil];
    }
}

- (void)sendQQ:(int)tag
{
    NSString *utf8String = url;
    NSString *title = Bigtitle;
    NSString *description;
    for (int i = 0; i < [ShareData shared].message.count; i++) {
        if ([[[[ShareData shared].message objectAtIndex:i] objectForKey:@"type"] intValue] == 1) {
            description = [[[ShareData shared].message objectAtIndex:i] objectForKey:@"content"];
            break;
        }
    }
//    NSString *previewImageUrl = @"http://cdni.wired.co.uk/620x413/k_n/NewsForecast%20copy_620x413.jpg";
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:@"weixinlogo.png"];
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String] title:title description:description previewImageData:UIImageJPEGRepresentation(image, 1)];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = 0;
    if (tag == 1) {
        //将内容分享到qq
        sent = [QQApiInterface sendReq:req];
    }else if (tag == 2){
        //将内容分享到qzone
        sent = [QQApiInterface SendReqToQZone:req];
    }
    [self handleSendResult:sent];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯文本分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯图片分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)repListDic
{
    [self deleteDir];

    NSString *str = [NSString stringWithFormat:@"http://mg.ideer.cn/Weixintool/Api/reflash/username/%@",[ShareData shared].username];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
    NSURLResponse *urlResponce=nil;
    NSError *error=nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponce error:&error];
    if (error) {
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不可用,请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    [ShareData shared].PageNumber = [weatherDic objectForKey:@"count"];
    [ShareData shared].listDic = [weatherDic objectForKey:@"content"];
}

- (void)sendLinkContent
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = Bigtitle;
        for (int i = 0; i < [ShareData shared].message.count; i++) {
            if ([[[[ShareData shared].message objectAtIndex:i] objectForKey:@"type"] intValue] == 1) {
                message.description = [[[ShareData shared].message objectAtIndex:i] objectForKey:@"content"];
                break;
            }
        }

//        message.description = ChildTitle;
        [message setThumbImage:[UIImage imageNamed:@"weixinlogo.png"]];

        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = [NSString stringWithFormat:@"%@",url];

        message.mediaObject = ext;

        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        if (type == 0) {
            req.scene = WXSceneSession;
        }else
            req.scene = WXSceneTimeline;

        [WXApi sendReq:req];
    }else{
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你的iPhone上还没有安装微信,无法使用此功能，去下载微信。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费下载微信", nil];
        alView.tag = 100;
        [alView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }else if (alertView.tag == 100){
        if (buttonIndex == 1) {
            NSString *weiXinLink = @"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weiXinLink]];
        }
    }
}

- (void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
