//
//  LoginPageViewController.m
//  WechatExpert
//
//  Created by User #⑨ on 14-3-10.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import "LoginPageViewController.h"

@interface LoginPageViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UITextField *username;
    UITextField *password;

    UIScrollView *scroll;

    MBProgressHUD *mb;
}

@end

@implementation LoginPageViewController
@synthesize appListData=_appListData;
@synthesize appListFeedConnection = _appListFeedConnection;

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
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImage.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:bgImage];
    PP_RELEASE(bgImage);
    [self drawPage];
}

- (void)drawPage
{
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.delegate = self;
    [self.view addSubview:scroll];

    [scroll setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [scroll addGestureRecognizer:tap];

    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(116, 107, 88, 40)];
    logo.image = [UIImage imageNamed:@"kk.png"];
    [scroll addSubview:logo];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(46, 219, 228, 84)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shuru.png"]];
    [scroll addSubview:view];

    username = [[UITextField alloc]initWithFrame:CGRectMake(50, 1, 175, 37)];
    username.backgroundColor = [UIColor clearColor];
    username.placeholder = @"用户名";
    username.delegate = self;
    [username setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [view addSubview:username];

    password = [[UITextField alloc]initWithFrame:CGRectMake(50, 46, 175, 37)];
    password.backgroundColor = [UIColor clearColor];
    password.placeholder = @"密 码";
    [password setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    password.secureTextEntry = YES;
    password.clearsOnBeginEditing  = YES;
    password.delegate = self;
    [view addSubview:password];

    UIButton *login = [UIButton buttonWithType:0];
    [login setFrame:CGRectMake(33.5, 320, 253, 51)];
    [login setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:login];

    UIButton *back = [UIButton buttonWithType:0];
    [back setFrame:CGRectMake(250, 378, 40, 22)];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:back];
}

- (void)login
{
    [username resignFirstResponder];
    [password resignFirstResponder];
    if (username.text.length == 0 || password.text.length == 0) {
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码为空" delegate:Nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alt show];
    }else{
        mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mb.labelText = @"正在登录，请稍等";
        [self start];
    }
}

//开始上传
- (void)start
{
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@",username.text,password.text];

    NSMutableData *postData = [NSMutableData dataWithData:[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSURL*url=[NSURL URLWithString:@"http://mg.ideer.cn/Weixintool/Api/login"];
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
    mb.hidden = YES;
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
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:self.appListData options:NSJSONReadingMutableLeaves error:nil];
    if ([[NSString stringWithFormat:@"%@",[weatherDic objectForKey:@"success"]] isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:@"username"];
        [ShareData shared].isNew = NO;
        [ShareData shared].username = username.text;
        [ShareData shared].PageNumber = [weatherDic objectForKey:@"count"];
        [ShareData shared].listDic = [NSMutableArray arrayWithObject:[weatherDic objectForKey:@"content"]];
        [self performSelector:@selector(goPage) withObject:Nil afterDelay:1];
    }else{
        [mb hide:YES];
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码错误，请查证后再试。" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
}

- (void)goPage
{
    [mb hide:YES];
    username.text = Nil;
    password.text = Nil;
    [ShareData shared].isSign = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == username) {
        [scroll setContentOffset:CGPointMake(0, 70) animated:YES];
    }else if (textField == password){
        [scroll setContentOffset:CGPointMake(0, 100) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    [username resignFirstResponder];
    [password resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
