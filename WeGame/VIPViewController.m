//
//  VIPViewController.m
//  WeGame
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "VIPViewController.h"

@interface VIPViewController ()

@end

@implementation VIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIFactory];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)UIFactory
{
    [self.view setBackgroundColor:RGBClor(244, 244, 244)];
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    //顶部导航条
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    [topBackView setBackgroundColor: RGBClor(71, 140, 205)];
    [self.view addSubview:topBackView];
    
    //    顶部图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"bank_home_ico.png" ] forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(10, 33, 22, 22)];
    [topBackView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    //顶部文字
    CGFloat labelWidth =150;
    UILabel *title =[[UILabel alloc]  initWithFrame:CGRectMake((screenWidth -labelWidth)/2, 37, labelWidth, 20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    [title setText:@"中农会员"];
    [title setFont:titleFont];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height+20, screenWidth, 44)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    [line1 setBackgroundColor:RGBClor(228, 228, 228)];
    [view1 addSubview:line1];
    
    UIView *line1b = [[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-1, screenWidth, 1)];
    [line1b setBackgroundColor:RGBClor(228, 228, 228)];
    [view1 addSubview:line1b];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setText:[WeGameHelper getString:@"UserName"]];
    [view1 addSubview:nameLabel];
    
    UILabel *changeLable = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-10-60, 10, 60, 20)];
    [changeLable setText:@"切换帐号"];
    [changeLable setTextColor:RGBClor(153, 153, 153)];
    [changeLable setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [view1 addSubview:changeLable];
    
    UIImageView *changeImg = [[UIImageView alloc] initWithFrame:CGRectMake(changeLable.frame.origin.x-20-5, 10, 20, 20)];
    [changeImg setImage:[UIImage imageNamed:@"switching_user_ico.png"]];
    [view1 addSubview:changeImg];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setFrame:CGRectMake(0, 0, view1.frame.size.width, view1.frame.size.height)];
    [changeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:changeBtn];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height+view1.frame.origin.y+20, screenWidth, 89)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    UIView *line20 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    [line20 setBackgroundColor:RGBClor(228, 228, 228)];
    [view2 addSubview:line20];
    
    UILabel *service = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 100, 20)];
    [service setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [service setTextColor:[UIColor blackColor]];
    [service setText:@"会员服务"];
    [view2 addSubview:service];
    
    UIImageView *right1 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-10-20, 10, 10, 20)];
    [right1 setImage:[UIImage imageNamed:@"user_arrow_ico.png"]];
    [view2 addSubview:right1];
    
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceBtn setFrame:CGRectMake(0, 0, screenWidth, 44)];
    [serviceBtn addTarget:self action:@selector(serviceClick) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:serviceBtn];
    
    
    UIView *line21 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenWidth, 1)];
    [line21 setBackgroundColor:RGBClor(228, 228, 228)];
    [view2 addSubview:line21];
    
    UILabel *about = [[UILabel alloc] initWithFrame:CGRectMake(10, 14+44, 100, 20)];
    [about setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [about setTextColor:[UIColor blackColor]];
    [about setText:@"关于中农"];
    [view2 addSubview:about];
    
    UIImageView *right2 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-10-20, 14+44, 10, 20)];
    [right2 setImage:[UIImage imageNamed:@"user_arrow_ico.png"]];
    [view2 addSubview:right2];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setFrame:CGRectMake(0, 45, screenWidth, 44)];
    [infoBtn addTarget:self action:@selector(aboutClick) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview: infoBtn];
    
    
    
    
    UIView *line22 = [[UIView alloc] initWithFrame:CGRectMake(0, 88, screenWidth, 1)];
    [line22 setBackgroundColor:RGBClor(228, 228, 228)];
    [view2 addSubview:line22];
    
    
    
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.frame.origin.y+view2.frame.size.height+20, screenWidth, 44)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view3];
    
    UIView *line30 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,1)];
    [line30 setBackgroundColor:RGBClor(228, 228, 228)];
    [view3 addSubview:line30];
    
    UILabel *loginout = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 100, 20)];
    [loginout setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [loginout setTextColor:[UIColor blackColor]];
    [loginout setText:@"退出登录"];
    [view3 addSubview:loginout];
    
    
    UIImageView *right3 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-15-20, 12, 20, 20)];
    [right3 setImage:[UIImage imageNamed:@"login_out_ico.png"]];
    [view3 addSubview:right3];
    
    
    UIView *line31 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, screenWidth, 1)];
    [line31 setBackgroundColor:RGBClor(228, 228, 228)];
    [view3 addSubview:line31];
    
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logBtn setFrame:CGRectMake(0, 0, screenWidth, 44)];
    [logBtn addTarget:self action:@selector(loginoutClick) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:logBtn];
    

    
    
}
-(void)changeClick
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要切换帐号？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert setTag:1];
    [alert show];
    
    
}
-(void)loginoutClick
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要退出登录吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert setTag:2];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            LoginViewController *lvc = [[LoginViewController alloc] init];
            lvc.homeMsg = NO;
            [self.navigationController pushViewController:lvc animated:YES];
        }
    }
    else
    {
        if (buttonIndex == 0) {
            [self Logout];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    
}
-(void)Logout
{
    [WeGameHelper saveString:@"0" key:@"UserID"];
    [WeGameHelper saveString:@"" key:@"UserName"];
    [WeGameHelper setLogin:NO];
}

-(void)serviceClick
{
    ServiceViewController *svc = [[ServiceViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)aboutClick
{
    InfoViewController *ivc = [[InfoViewController alloc] init];
    [self.navigationController pushViewController:ivc animated:YES];
}
@end
