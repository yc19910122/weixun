//
//  ChoosePageViewController.m
//  WechatExpert
//
//  Created by User #⑨ on 14-3-4.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import "ChoosePageViewController.h"

@interface ChoosePageViewController ()<UIActionSheetDelegate>
{
    UIButton *saveNum;

    UIView *ListView;

    UIView *view1;
    UIView *view2;

    UIView *aboutView;
}

@end

@implementation ChoosePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self SaveNum];
    [saveNum setTitle:[self SaveNum] forState:UIControlStateNormal];
    [self drawList];
}

- (NSString *)SaveNum
{
    NSString *str = [NSString stringWithFormat:@"%@",[ShareData shared].PageNumber];
    if ([str intValue] > 99) {
        str = @"99+";
    }else if ([str intValue] == 0){
        str = @"0";
    }
    return str;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.hidesBackButton =YES;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

    UIImage *navBg = [[UIImage alloc]init];
    if (Version >= 7.0) {
        navBg = [UIImage imageNamed:@"ios7.png"];
    }else
        navBg = [UIImage imageNamed:@"ios6.png"];
    [self.navigationController.navigationBar setBackground:navBg];
    PP_RELEASE(navBg);

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"微讯";
    title.textAlignment = NSTextAlignmentCenter;
    title.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = title;

    UIButton *rightBtn = [UIButton buttonWithType:0];
    [rightBtn setFrame:CGRectMake(0, 0, 35, 35)];
    [rightBtn setTitle:@"设置" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [rightBtn addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;

    [self drawPage];
}

- (void)showRight
{
    if ([ShareData shared].isSign == YES) {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:Nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:Nil otherButtonTitles:@"关  于",@"注   销", nil];
        [sheet showInView:self.view];
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:Nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:Nil otherButtonTitles:@"关  于",@"去登录", nil];
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"关于" message:@"微信通-微网页工具\n Version 1.0.1 \nIDEER\n版权所有 " delegate:Nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
//        [alt show];
        [self drawAbout];
    }else if (buttonIndex == 1){
        if ([ShareData shared].isSign == YES) {
            [ShareData shared].isSign = NO;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
            [[self navigationController] setNavigationBarHidden:YES animated:NO];
            HomePageViewController *home = [[HomePageViewController alloc]init];
            [self.navigationController popToRootViewControllerAnimated:YES];
            PP_RELEASE(home);
        }else{
            [[self navigationController] setNavigationBarHidden:YES animated:NO];
            HomePageViewController *login = [[HomePageViewController alloc]init];
            [self.navigationController popToRootViewControllerAnimated:YES];
            PP_RELEASE(login);
        }
    }
}

- (void)drawPage
{
    int flag = Height(Version);
    if (self.view.frame.size.height <= 480) {
        view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0+flag, self.view.frame.size.width, 208)];
        view1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bianji.png"]];

        view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 208+flag, self.view.frame.size.width, 208)];
        view2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SaveView.png"]];
    }else{
        view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0+flag, self.view.frame.size.width, 252)];
        view1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bianji2.png"]];
        view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 252+flag, self.view.frame.size.width, 252)];
        view2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SaveView2.png"]];
    }
    [self.view addSubview:view1];
    [self.view addSubview:view2];

    UIButton *addBtn = [UIButton buttonWithType:0];
    [addBtn setFrame:CGRectMake(16, 43, 110, 110)];
    [addBtn setImage:[UIImage imageNamed:@"addIcon.png"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"D_addIcon.png"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:addBtn];

    UIButton *go = [UIButton buttonWithType:0];
    [go setFrame:CGRectMake(215, 104, 95, 95)];
    [go addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:go];

    if ([ShareData shared].isSign == YES) {
        [self performSelector:@selector(drawList) withObject:Nil afterDelay:0];
    }

    UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(16, 44, 110, 110)];
    image.image = [UIImage imageNamed:@"YuanImage.png"];
    [view2 addSubview:image];

    saveNum = [UIButton buttonWithType:0];
    [saveNum setFrame:CGRectMake(16, 44, 110, 110)];
    [saveNum setTitle:[self SaveNum] forState:UIControlStateNormal];
    [saveNum setTitleColor:[UIColor colorWithRed:255/255.0 green:101/255.0 blue:101/255.0 alpha:1.0] forState:UIControlStateNormal];
    saveNum.titleLabel.font = [UIFont systemFontOfSize:38.f];
    [saveNum addTarget:self action:@selector(SavePage) forControlEvents:UIControlEventTouchUpInside];
    [saveNum setImage:[UIImage imageNamed:@"D_YuanImage.png"] forState:UIControlStateHighlighted];
    [view2 addSubview:saveNum];

    UIButton *jiantou = [UIButton buttonWithType:0];
    [jiantou setFrame:CGRectMake(275, 160, 28, 19)];
    [jiantou setImage:[UIImage imageNamed:@"jt.png"] forState:UIControlStateNormal];
    [jiantou addTarget:self action:@selector(SavePage) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:jiantou];

}

- (void)drawAbout
{
    [aboutView removeFromSuperview];

    aboutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    aboutView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:aboutView];

    UIImageView *about = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-290)/2, (self.view.frame.size.height-397)/2, 290, 397)];
    about.image = [UIImage imageNamed:@"about.png"];
    about.userInteractionEnabled = YES;
    [aboutView addSubview:about];

    UIButton *btn = [UIButton buttonWithType:0];
    [btn setFrame:CGRectMake(242, 18, 35, 25)];
    [btn addTarget:self action:@selector(btnPass) forControlEvents:UIControlEventTouchUpInside];
    [about addSubview:btn];
}

- (void)btnPass
{
    [aboutView removeFromSuperview];
}

- (void)drawList
{
    if ([ShareData shared].isSign != YES) {
        return;
    }

    [ListView removeFromSuperview];
    
    ListView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-173, 20, 173, 150)];
    ListView.backgroundColor = [UIColor clearColor];
    [view2 addSubview:ListView];

    UIButton *listBtn = [UIButton buttonWithType:0];
    [listBtn setFrame:CGRectMake(0, 0, 173, 150)];
    [listBtn addTarget:self action:@selector(SavePage) forControlEvents:UIControlEventTouchUpInside];
    [ListView addSubview:listBtn];

    int cishu;
    if ([ShareData shared].listDic.count >= 3) {
        cishu = 3;
    }else
        cishu = (int)[ShareData shared].listDic.count;
    
    for (int i = 0; i < cishu; i++) {
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(35, 7+i*43, 13, 13)];
        icon.image = [UIImage imageNamed:@"SaveIcon.png"];
        icon.alpha = 0.5;
        [ListView addSubview:icon];

        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(53, 4+i*43, 115, 17)];
        time.backgroundColor = [UIColor clearColor];
        time.font = [UIFont systemFontOfSize:11.f];
        time.text = [[[ShareData shared].listDic objectAtIndex:i] objectForKey:@"create_time"];
        time.textColor = [UIColor whiteColor];
        time.alpha = 0.5;
        [ListView addSubview:time];

        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(53, 22+i*43, 117, 20)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:13.f];
        title.text = [[[ShareData shared].listDic objectAtIndex:i] objectForKey:@"title"];
        title.textColor = [UIColor whiteColor];
        [ListView addSubview:title];

        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43+i*43, 173, 1)];
        line.image = [UIImage imageNamed:@"Line.png"];
        line.alpha = 0.2;
        [ListView addSubview:line];
    }
}

- (void)SavePage
{
    SavePageViewController *savePage = [[SavePageViewController alloc]init];
    [self.navigationController pushViewController:savePage animated:YES];
}

- (void)addBtn
{
    [ShareData shared].uid = Nil;
    [ShareData shared].uid = [ShareData getTimeAndRandom];
    
    MakePageViewController *makepage = [[MakePageViewController alloc]init];
    [self.navigationController pushViewController:makepage animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
