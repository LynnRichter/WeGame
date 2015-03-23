//
//  LoginViewController.m
//  WeGame
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize  homeMsg;
UITextField *userName,*userPwd;

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
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //顶部导航条
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    [topBackView setBackgroundColor: RGBClor(53, 136, 211)];
    [self.view addSubview:topBackView];
    

    
    
    
    //顶部文字
    UILabel *title =[[UILabel alloc]  initWithFrame:CGRectMake((screenWidth-150)/2, 37, 150, 20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    [title setText:@"会员登录"];
    [title setFont:titleFont];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    
    //    顶部图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (homeMsg) {
        [backBtn setImage:[UIImage imageNamed:@"bank_home_ico.png" ] forState:UIControlStateNormal];
    }
    else
    {
        [backBtn setImage:[UIImage imageNamed:@"bank_ico.png" ] forState:UIControlStateNormal];
    }
    
    [backBtn setFrame:CGRectMake(10, 33, 22, 22)];
    [topBackView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    //顶部与底部的分隔符
    UIView *vLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth,1)];
    [vLine3 setBackgroundColor:RGBClor(32, 37, 44)];
    [self.view addSubview:vLine3];
    
    //中间输入内容
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, topBackView.frame.origin.y+24+topBackView.frame.size.height, screenWidth-20, 300)];
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = [RGBClor(221, 221, 221) CGColor];
    contentView.layer.cornerRadius = 8;
    [contentView setBackgroundColor:RGBClor(250, 250, 250)];
    [self.view addSubview:contentView];
    //帐号前的图片
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    [imageView1 setImage:[UIImage imageNamed:@"reg_ico_d.png"]];
    [imageView1 setContentMode:UIViewContentModeScaleAspectFill];
    [contentView addSubview:imageView1];

    //帐号输入框
    userName = [[UITextField alloc] initWithFrame:CGRectMake(imageView1.frame.origin.x+imageView1.frame.size.width+10, imageView1.frame.origin.y, contentView.frame.size.width-imageView1.frame.size.width-imageView1.frame.origin.x-10, imageView1.frame.size.height)];
    [userName setBorderStyle:UITextBorderStyleNone];
    [userName setPlaceholder:@"手机"];
    [contentView addSubview:userName];
    
    //分隔符
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, imageView1.frame.origin.y+imageView1.frame.size.height+10,contentView.frame.size.width  , 1)];
    [line setBackgroundColor:RGBClor(228, 228, 228)];
    [contentView addSubview:line];
    //密码输入前的图片
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, line.frame.size.height+line.frame.origin.y+10, 20,20)];
    [imageView2 setImage:[UIImage imageNamed:@"reg_ico_c.png"]];
    [imageView2 setContentMode:UIViewContentModeScaleAspectFill];
    [contentView addSubview:imageView2];
    //密码输入框
    userPwd = [[UITextField alloc] initWithFrame:CGRectMake(imageView2.frame.origin.x+imageView2.frame.size.width+10, imageView2.frame.origin.y, contentView.frame.size.width-imageView2.frame.size.width-imageView2.frame.origin.x-10, imageView2.frame.size.height)];
    [userPwd setBorderStyle:UITextBorderStyleNone];
    [userPwd setPlaceholder:@"登录密码"];
    [userPwd setSecureTextEntry:YES];
    [contentView addSubview:userPwd];
    
    
    //分隔符
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, imageView2.frame.origin.y+imageView2.frame.size.height+10,contentView.frame.size.width  , 1)];
    [line2 setBackgroundColor:RGBClor(228, 228, 228)];
    [contentView addSubview:line2];
    
    
    //登录按钮
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, line2.frame.origin.y+line2.frame.size.height+20, 130, 40)];
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:RGBClor(71, 140, 205)];
    loginBtn.layer.cornerRadius = 8;
    [contentView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    //免费注册按钮
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginBtn.frame.origin.x+loginBtn.frame.size.width+20, loginBtn.frame.origin.y, 130, 40)];
    [registBtn setTitle:@"免费注册" forState:UIControlStateNormal];
    [registBtn setBackgroundColor:RGBClor(255, 102, 0)];
    registBtn.layer.cornerRadius = 8;
    [contentView addSubview:registBtn];
    [registBtn addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //下方的说明文字
    
    UILabel *descLbl = [[UILabel alloc] initWithFrame:CGRectMake(loginBtn.frame.origin.x
                                                                 , loginBtn.frame.origin.y+loginBtn.frame.size.height+10
                                                                 ,contentView.frame.size.width-2*loginBtn.frame.origin.x
                                                                 , 80)];
    [descLbl setLineBreakMode:NSLineBreakByWordWrapping];
    [descLbl setNumberOfLines:2];
    [descLbl setText:@"登录即可查看全部数据，还能使用收藏功能，还没帐号，免费注册一个！"];
    [descLbl setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview: descLbl];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setCenter:contentView.center];
    [activity setHidesWhenStopped:YES];
    [contentView addSubview:activity];
    
    
    
    
}
-(void)registClick
{
    RegistViewController *rvc = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
}

-(void)loginClick
{
    if ([userName.text isEqualToString:@""]) {
        [self showMSG:@"用户名不能为空"];


        return;
    }
    if ([userPwd.text isEqualToString:@""]) {
        [self showMSG:@"密码不能为空"];
      return;
    }
    [activity startAnimating];

    NSString *server = SERVER_STRING;
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:userName.text,@"mobile",userPwd.text,@"password",server,@"server_str",CLIENT_STRING,@"client_str",nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST: [LoginURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activity stopAnimating];
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"登录返回数据：%@",dict);
//        NSLog(@"info==%@",[dict objectForKey:@"info"]);
        if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"data"]]  isEqualToString:@""]) {
            [self showMSG:@"用户名或密码错误，请重新登录"];
            return;
        }
        //全局单例变量，跳转界面到
        [WeGameHelper saveString:[NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"userId"]] key:@"UserID"];
        [WeGameHelper saveString:[NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"userName"]] key:@"UserName"];
        [WeGameHelper setLogin:YES];
        
        [self showMSG:@"登录成功"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
            [NSThread sleepForTimeInterval:2];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
        });

        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activity stopAnimating];
        [self showMSG:@"登录失败，请检查网络连接"];
        NSLog(@"请求失败：%@",error);
        
    }];


    
    
}

-(void)backPress
{
    if (homeMsg) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)showMSG:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText =msg;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
    
}

@end
