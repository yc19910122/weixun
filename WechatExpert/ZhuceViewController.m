//
//  ZhuceViewController.m
//  WechatExpert
//
//  Created by User #⑨ on 14-3-3.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import "ZhuceViewController.h"

@interface ZhuceViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UITextField *username;
    UITextField *passwd1;
    UITextField *passwd2;
    UIScrollView *scroll;

    MBProgressHUD *mb;
}

@end

@implementation ZhuceViewController
@synthesize appListData=_appListData;
@synthesize appListFeedConnection = _appListFeedConnection;
@synthesize which;

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
//    [[self navigationController] setNavigationBarHidden:NO animated:NO];

    UIImage *navBg = [[UIImage alloc]init];
    if (Version >= 7.0) {
        navBg = [UIImage imageNamed:@"ios7.png"];
    }else
        navBg = [UIImage imageNamed:@"ios6.png"];
    [self.navigationController.navigationBar setBackground:navBg];
    PP_RELEASE(navBg);

    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImage.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:bgImage];
    PP_RELEASE(bgImage);

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"用户注册";
    title.textAlignment = NSTextAlignmentCenter;
    title.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = title;

    UIButton *leftBtn = [UIButton buttonWithType:0];
    [leftBtn setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backToIndex) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;

    [self drawPage];

    if (which == YES) {
        UIButton *back = [UIButton buttonWithType:0];
        [back setFrame:CGRectMake(10, 30, 40, 22)];
        [back setTitle:@"返回" forState:UIControlStateNormal];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:back];
    }
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)drawPage
{
    int flag = Height(Version);
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.delegate = self;
    [self.view addSubview:scroll];

    [scroll setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [scroll addGestureRecognizer:tap];

    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(116, 137, 88, 40)];
    logo.image = [UIImage imageNamed:@"kk.png"];
    [scroll addSubview:logo];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(46, 218+flag, 228, 129)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhuceView.png"]];
    [scroll addSubview:view];

    username = [[UITextField alloc]initWithFrame:CGRectMake(55, 1, 173, 37)];
    username.backgroundColor = [UIColor clearColor];
    username.placeholder = @"用户名";
    username.delegate = self;
    [username setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [view addSubview:username];

    passwd1 = [[UITextField alloc]initWithFrame:CGRectMake(55, 46, 173, 37)];
    passwd1.backgroundColor = [UIColor clearColor];
    passwd1.placeholder = @"密 码";
    passwd1.delegate = self;
    passwd1.secureTextEntry = YES;
    passwd1.clearsOnBeginEditing  = YES;
    [passwd1 setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    passwd1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [view addSubview:passwd1];

    passwd2 = [[UITextField alloc]initWithFrame:CGRectMake(55, 91, 173, 37)];
    passwd2.backgroundColor = [UIColor clearColor];
    passwd2.placeholder = @"密码确认";
    passwd2.delegate = self;
    passwd2.secureTextEntry = YES;
    passwd2.clearsOnBeginEditing  = YES;
    [passwd2 setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    passwd2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [view addSubview:passwd2];

    UIButton *btn = [UIButton buttonWithType:0];
    [btn setFrame:CGRectMake(32.5, 364+flag, 255, 50)];
    [btn setImage:[UIImage imageNamed:@"login2.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPass) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:btn];
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    [username resignFirstResponder];
    [passwd1 resignFirstResponder];
    [passwd2 resignFirstResponder];
}

- (void)btnPass
{
    [username resignFirstResponder];
    [passwd1 resignFirstResponder];
    [passwd2 resignFirstResponder];
    if (username.text.length == 0 || passwd1.text.length == 0 || passwd2.text.length == 0) {
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请全部填写" delegate:Nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alt show];
    }else{
        if ([username.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0 || [passwd1.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不能为空,请填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alt.tag = 0;
            [alt show];
            return;
        }

        if ([passwd1.text isEqualToString:passwd2.text]) {
            mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mb.labelText = @"正在注册，请稍等...";
            [self start];
        }else{
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入的密码不同\n请检查后重新输入" delegate:Nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alt show];
        }
    }
}

//开始上传
- (void)start
{
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@",username.text,passwd1.text];

    NSMutableData *postData = [NSMutableData dataWithData:[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSURL*url=[NSURL URLWithString:@"http://mg.ideer.cn/Weixintool/Userinfo/registuser"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    self.appListFeedConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    NSLog(@"error = %@",error);
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前没有网络，请先连接网络" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.appListData = [NSMutableData data];    // start off with new data
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.appListData appendData:data];  // append incoming data
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* strRet = [[NSString alloc] initWithData:self.appListData encoding:NSUTF8StringEncoding];
//    NSLog(@"strRet = %@",strRet);
    if ([strRet isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:@"username"];
        [ShareData shared].username = username.text;
        [ShareData shared].isNew = YES;
        [ShareData shared].PageNumber = 0;
        [ShareData shared].listDic = nil;
        [self performSelector:@selector(login) withObject:Nil afterDelay:1];
    }else {
        mb.hidden = YES;
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户已经存在，请重新输入" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
}

- (void)login
{
    mb.hidden = YES;
    username.text = nil;
    passwd1.text = nil;
    passwd2.text = nil;
    [ShareData shared].isSign = YES;
    if (which == YES) {
        [ShareData shared].isNew = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        ChoosePageViewController *choose = [[ChoosePageViewController alloc]init];
        [self.navigationController pushViewController:choose animated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == username) {
        [scroll setContentOffset:CGPointMake(0, 90) animated:YES];
    }else if (textField == passwd1){
        [scroll setContentOffset:CGPointMake(0, 130) animated:YES];
    }else if(textField == passwd2)
        [scroll setContentOffset:CGPointMake(0, 170) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)backToIndex
{
    [username resignFirstResponder];
    [passwd1 resignFirstResponder];
    [passwd2 resignFirstResponder];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
