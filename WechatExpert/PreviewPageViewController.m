//
//  PreviewPageViewController.m
//  WechatExpert
//
//  Created by User #⑨ on 14-3-10.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import "PreviewPageViewController.h"

@interface PreviewPageViewController ()<UIWebViewDelegate>
{
    UIWebView *web;
    UIActivityIndicatorView *activity;
    NSMutableDictionary *sendMessage;

    MBProgressHUD *mb;
}

@end

@implementation PreviewPageViewController
@synthesize NumberID;
@synthesize bigTitle,littleTitle;
@synthesize NewsMessage;
@synthesize Where;

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
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"网页预览";
    title.textAlignment = NSTextAlignmentCenter;
    title.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = title;

    UIButton *rightBtn = [UIButton buttonWithType:0];
    [rightBtn setFrame:CGRectMake(0, 0, 35, 35)];
    [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
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

    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    web.delegate = self;
    [self.view addSubview:web];

    if (Where == 1) {
        [web loadHTMLString:[self convertHTMLString] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    }else{
        NSString *str = [NSString stringWithFormat:@"http://mg.ideer.cn/Weixintool/Articlinfo/weiweb/uid/%@",NumberID];
        NSURL *url =[NSURL URLWithString:str];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [web loadRequest:request];
    }

    activity = [[UIActivityIndicatorView alloc] initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activity setCenter: web.center];
    [activity setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
    [self.view addSubview : activity];
}

- (NSString *)getTime
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];

    NSString *time = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",(long)[comps year],(long)[comps month],(long)[comps day],(long)[comps hour],(long)[comps minute],(long)[comps second]];
    return time;
}

-(NSString *)convertHTMLString{
    // 定义HTML
    NSString *html = @"<div style=\"width:100%\"></div>";
    // 定义样式

    // 返回最终的HTML
    NSMutableString *images = [NSMutableString string];
    for(int i=0;i<NewsMessage.count;i++){
        if ([[NSString stringWithFormat:@"%@",[[NewsMessage objectAtIndex:i] objectForKey:@"type"]] isEqualToString:@"1"]) {
            [images appendFormat:@"<div class='row-fluid'><pre style='font-size:1.2em;border:none;background:none;'>%@</pre></div><br/>",[[NewsMessage objectAtIndex:i] objectForKey:@"content"]];
        }else if ([[NSString stringWithFormat:@"%@",[[NewsMessage objectAtIndex:i] objectForKey:@"type"]] isEqualToString:@"2"]){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
            NSString *string = [NSString stringWithFormat:@"/image/%@",[[[NewsMessage objectAtIndex:i] objectForKey:@"content"] objectAtIndex:2]];
            NSString *ImagePath = [NSString stringWithFormat:@"%@%@",documentpath,string];
//            NSString *tempDir = NSTemporaryDirectory();
//            NSString *tmpVideoPath = [tempDir stringByAppendingPathComponent:[[[NewsMessage objectAtIndex:i] objectForKey:@"content"] objectAtIndex:2]];
            [images appendFormat:@"<div class='row-fluid'><video src='file://%@' style=/'width:100%%;max-width:100%%'/></video></div><br/>",ImagePath];
        }else{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
            NSString *string = [NSString stringWithFormat:@"/image/%@",[[NewsMessage objectAtIndex:i] objectForKey:@"content"]];
            NSString *ImagePath = [NSString stringWithFormat:@"%@%@",documentpath,string];
            [images appendFormat:@"<div class='row-fluid'><img src='file://%@' style=/'width:100%%;max-width:100%%'/></div><br/>",ImagePath];
        }
    }
    return [html stringByAppendingFormat:@"<!DOCTYPE HTML><html lang='en-US'><head><meta name=‘viewport’ content=‘width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0’><meta charset='UTF-8'><link rel='stylesheet' href='bootstrap.min.css' type='text/css'/><link rel='stylesheet' href='bootstrap-responsive.min.css' type='text/css'/><style>html,body{background: white;height: 100%%;max-width: device-width;width: device-width;/*overflow-x:hidden;padding: 0 !important*/;}.myPage a {padding: 5px;height: 32px;    line-height: 32px;border: 1px solid #ccc;    margin-right: 10px;}.myPage span {color: #28B779;border: 1px solid #ccc;padding: 5px;height: 32px;    line-height: 32px;    margin-right: 10px;}.form-head-search {padding: 30px 0 0 0;}.form-head-search .input-prepend {    margin-right: 20px;    margin-bottom: 10px;}.form-head-search .btn-success {    margin-bottom: 10px;}.popover {    z-index: 101011;}.tip-top>i{    font-size: 16px;}i[class^=icon]{margin: 0px;    font-size: 16px;}img {max-width: 99%%;}  </style></head><body><div class=‘container-fluid’ style=‘min-height:100%%;’ id=‘bigdiv’><div style=‘position:relative;’><div class='row-fluid'><h4>%@</h4><h6>%@</h6><h6 style='color:#9b9b9b;'>%@&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%@</h6></div><div>%@</div></div></div></body></html>",bigTitle,littleTitle,[self getTime],[ShareData shared].isSign?[ShareData shared].username:@"匿名用户",images];
}

- (void)showRight
{
    if ([ShareData shared].isSign == YES) {
        
        mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mb.labelText = @"正在生成微网页";

        if (Where == 1) {
            [self performSelector:@selector(startSc) withObject:Nil afterDelay:0.3];
        }else
            [self performSelector:@selector(startShare) withObject:Nil afterDelay:0.3];

    }else{
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟，请选择如下操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录",@"去注册", nil];
        alt.tag = 101;
        [alt show];
    }
}

- (void)startShare
{
    [mb hide:YES];
    SharePageViewController *share = [[SharePageViewController alloc]init];
    share.url = [NSString stringWithFormat:@"http://mg.ideer.cn/Weixintool/Articlinfo/weiweb/uid/%@",NumberID];
    share.Bigtitle = bigTitle;
    share.ChildTitle = littleTitle;
    [self.navigationController pushViewController:share animated:YES];
}

- (void)startSc
{
    sendMessage = [[NSMutableDictionary alloc]init];
    [sendMessage setValue:[ShareData shared].uid forKey:@"uid"];
    [sendMessage setValue:NewsMessage forKey:@"xinxi"];
    [sendMessage setValue:bigTitle forKey:@"title"];
    [sendMessage setValue:littleTitle forKey:@"fu_title"];
    if ([ShareData shared].isSign == YES) {
        [sendMessage setValue:[ShareData shared].username forKey:@"username"];
    }

    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < NewsMessage.count; i++) {
        if ([[[NewsMessage objectAtIndex:i] objectForKey:@"type"] intValue] == 0 || [[[NewsMessage objectAtIndex:i] objectForKey:@"type"] intValue] == 2) {
            [array1 addObject:[[NewsMessage objectAtIndex:i] objectForKey:@"content"]];
        }
    }

    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *imageDir = [ShareData dataPath];
    NSArray *array = [fileManage contentsOfDirectoryAtPath:imageDir error:nil];

    NSString* l_zipfile;
    if (array.count != 0) {
        ZipArchive* zip = [[ZipArchive alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        l_zipfile = [documentpath stringByAppendingString:@"/test.zip"] ;

        BOOL ret = [zip CreateZipFile2:l_zipfile];
        for (int i = 0; i < array1.count; i++) {
            if ([[[NewsMessage objectAtIndex:i] objectForKey:@"type"] intValue] == 2) {
                ret = [zip addFileToZip:[documentpath stringByAppendingString:[NSString stringWithFormat:@"/image/%@",[[array1 objectAtIndex:i] objectAtIndex:2]]] newname:[[array1 objectAtIndex:i] objectAtIndex:2]];
            }else
                ret = [zip addFileToZip:[documentpath stringByAppendingString:[NSString stringWithFormat:@"/image/%@",[array1 objectAtIndex:i]]] newname:[array1 objectAtIndex:i]];
        }
        if( ![zip CloseZipFile2] )
        {
            l_zipfile = @"";
        }
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendMessage options:NSJSONWritingPrettyPrinted error:Nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",str);

    NSString *urlString = @"http://mg.ideer.cn/Weixintool/Articlinfo/prevew";
    ASIFormDataRequest *aRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [aRequest setPostValue:str forKey:@"uid"];
    [aRequest setFile:l_zipfile forKey:@"ff"];
    [aRequest setDelegate:self];
    [aRequest buildRequestHeaders];
    [aRequest startSynchronous];

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseString = [request responseData];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingMutableLeaves error:nil];
    if ([[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"status"]] isEqualToString:@"1"]) {
        [self SendName];
        NumberID = [weatherDic objectForKey:@"info"];
        SharePageViewController *share = [[SharePageViewController alloc]init];
        share.url = [NSString stringWithFormat:@"http://mg.ideer.cn/Weixintool/Articlinfo/weiweb/uid/%@",NumberID];
        share.Bigtitle = bigTitle;
        share.ChildTitle = littleTitle;
        [self.navigationController pushViewController:share animated:YES];
    }
    [mb hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [mb hide:YES];
    UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查你的网络状态。。。" delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alt show];
}

- (void)SendName
{
    NSString *str = [NSString stringWithFormat:@"http://mg.ideer.cn/Weixintool/Articlinfo/fabu/uid/%@/username/%@",NumberID,[ShareData shared].username];
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
    if (![[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"success"]] isEqualToString:@"1"]) {
        [self SendName];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            LoginPageViewController *login = [[LoginPageViewController alloc]init];
            [self presentViewController:login animated:YES completion:Nil];
        }else if (buttonIndex == 2){
            ZhuceViewController *zhuce = [[ZhuceViewController alloc]init];
            zhuce.which = YES;
            [self presentViewController:zhuce animated:YES completion:nil];
        }else
            return;
    }
}

- (void)backToIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --webview
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%@",NSStringFromCGRect(webView.frame));
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];

    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];

    [activity stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
