//
//  SavePageViewController.m
//  WechatExpert
//
//  Created by User #⑨ on 14-3-4.
//  Copyright (c) 2014年 Yang Chao. All rights reserved.
//

#import "SavePageViewController.h"

@interface SavePageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
}

@end

@implementation SavePageViewController

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
    title.text = @"已保存的网页";
    title.textAlignment = NSTextAlignmentCenter;
    title.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = title;

    UIButton *leftBtn = [UIButton buttonWithType:0];
    [leftBtn setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backToIndex) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bb.png"]];

    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    table.delegate = self;
    table.dataSource  = self;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ShareData shared].listDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
    }else{
        [cell removeFromSuperview];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
    }

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 305, 70)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2.png"]];
    [cell.contentView addSubview:view];

    UILabel *bigTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 270, 20)];
    [bigTitle setBackgroundColor:[UIColor clearColor]];
    [bigTitle setFont:[UIFont systemFontOfSize:16.f]];
    bigTitle.text = [[[ShareData shared].listDic objectAtIndex:indexPath.row] objectForKey:@"title"];
    bigTitle.textColor = [UIColor blackColor];
    [view addSubview:bigTitle];

    UILabel *littleTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 34, 275, 14)];
    [littleTitle setBackgroundColor:[UIColor clearColor]];
    [littleTitle setFont:[UIFont systemFontOfSize:11.f]];
    littleTitle.text = [[[ShareData shared].listDic objectAtIndex:indexPath.row] objectForKey:@"fu_title"];
    littleTitle.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1];
    [view addSubview:littleTitle];

    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(10, 53, 275, 12)];
    [time setBackgroundColor:[UIColor clearColor]];
    [time setTextAlignment:NSTextAlignmentRight];
    [time setFont:[UIFont systemFontOfSize:12.f]];
    time.text = [[[ShareData shared].listDic objectAtIndex:indexPath.row] objectForKey:@"create_time"];
    time.textColor = [UIColor blackColor];
    [view addSubview:time];

    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PreviewPageViewController *preView = [[PreviewPageViewController alloc]init];
    preView.NumberID = [[[ShareData shared].listDic objectAtIndex:indexPath.row] objectForKey:@"uid"];
    preView.bigTitle = [[[ShareData shared].listDic objectAtIndex:indexPath.row] objectForKey:@"title"];
    preView.littleTitle = [[[ShareData shared].listDic objectAtIndex:indexPath.row] objectForKey:@"fu_title"];
    preView.Where = 2;
    [self.navigationController pushViewController:preView animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleList:[[ShareData shared].listDic objectAtIndex:indexPath.row] tag:indexPath.row];
}

- (void)deleList:(NSDictionary *)dic tag:(int)number
{
    NSString *str = [NSString stringWithFormat:@"http://mg.ideer.cn/Weixintool/Articlinfo/nowDelete/uid/%@",[dic objectForKey:@"uid"]];
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
    if ([[weatherDic objectForKey:@"success"] intValue] == 1) {
        NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[ShareData shared].listDic];
        [arr removeObjectAtIndex:number];
        [ShareData shared].listDic = arr;
        [ShareData shared].PageNumber = [NSString stringWithFormat:@"%d",[ShareData shared].listDic.count];
        arr = nil;
    }else{
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除失败，请重新删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }
    [table reloadData];
}

- (void)backToIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
