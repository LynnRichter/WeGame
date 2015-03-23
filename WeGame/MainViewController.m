//
//  MainViewController.m
//  WeGame
//
//  Created by Lynnrichter on 15/1/20.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIFactory];
    // Do any additional setup after loading the view.
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
    
    UIImageView * topImage = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-74)/2, 22, 74, 44)];
    [topImage setImage:[UIImage imageNamed:@"home_head_logo.png"]];
    [topBackView addSubview:topImage];
    
    cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityButton setTitle:@"定位中" forState:UIControlStateNormal];
    [cityButton setBackgroundColor:RGBClor(82, 152, 216)];
    cityButton.layer.cornerRadius = 6;
    cityButton.layer.borderColor = [RGBClor(50, 120, 183) CGColor];
    cityButton.layer.borderWidth = 1;
    [cityButton setFrame:CGRectMake(screenWidth-8-60, 32, 60, 25)];
    [cityButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [topBackView addSubview:cityButton];
    
    
    oneSearchBar = [[UISearchBar alloc] init];
    oneSearchBar.frame = CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth , 40); // 设置位置和大小
    oneSearchBar.keyboardType = UIKeyboardTypeEmailAddress; // 设置弹出键盘的类型
    oneSearchBar.barStyle = UIBarStyleDefault; // 设置UISearchBar的样式
    oneSearchBar.tintColor = [UIColor lightGrayColor]; // 设置UISearchBar的颜色 使用clearColor就是去掉背景
    oneSearchBar.placeholder = @"按农产品名称搜索"; // 设置提示文字
//    oneSearchBar.text = @""; // 设置默认的文字
    oneSearchBar.delegate = self; // 设置代理
    
    oneSearchBar.showsCancelButton = NO; // 设置时候显示关闭按钮
    

    
    [self.view addSubview:oneSearchBar]; // 添加到View上
    
    
    UIView *supportView = [[UIView alloc] initWithFrame:CGRectMake((screenWidth-80)/2, oneSearchBar.frame.origin.y+oneSearchBar.frame.size.height+20, 80, 80)];
    [supportView setBackgroundColor:[UIColor clearColor]];
    supportView      .layer.cornerRadius = 6;
    supportView.layer.masksToBounds = YES;
    [self.view addSubview:supportView];
    UIImageView* bgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_ico_back.png"]];
    bgview.frame = CGRectMake(0, 0, supportView.frame.size.width, supportView.frame.size.height);
    [supportView addSubview:bgview];
    
    //找供应商
    UIImageView *supportImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 30, 30)];
    [supportImage setImage:[UIImage imageNamed:@"menu_ico_b_on.png"]];
    [supportView addSubview:supportImage];
    
    UILabel *sLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, supportView.frame.size.width, 20)];
    [sLabel setText:@"找供应商"];
    [sLabel setTextColor:[UIColor whiteColor]];
    [sLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [sLabel setTextAlignment:NSTextAlignmentCenter];
    [supportView addSubview:sLabel];
    
    UIButton *sbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sbtn setFrame:CGRectMake(0, 0, 80, 80)];
    [sbtn setBackgroundColor:[UIColor clearColor]];
    [sbtn setTag:1];
    [sbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [supportView addSubview:sbtn];
    
    
//    查价格
    UIView *priceView = [[UIView alloc ] initWithFrame:CGRectMake(supportView.frame.origin.x-20-80, supportView.frame.origin.y, 80, 80)];
    [priceView setBackgroundColor:[UIColor clearColor]];
    priceView      .layer.cornerRadius = 6;
    priceView.layer.masksToBounds = YES;
    [self.view addSubview:priceView];
    UIImageView* bgview2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_ico_back.png"]];
    bgview2.frame = CGRectMake(0, 0, priceView  .frame.size.width, priceView.frame.size.height);
    [priceView addSubview:bgview2];
    
    UIImageView *priceImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 30, 30)];
    [priceImage setImage:[UIImage imageNamed:@"menu_ico_a_on.png"]];
    [priceView addSubview:priceImage];
    
    UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, priceView.frame.size.width, 20)];
    [pLabel setText:@"查价格"];
    [pLabel setTextColor:[UIColor whiteColor]];
    [pLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [pLabel setTextAlignment:NSTextAlignmentCenter];
    [priceView addSubview:pLabel];
    
    UIButton *pbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pbtn setFrame:CGRectMake(0, 0, 80, 80)];
    [pbtn setBackgroundColor:[UIColor clearColor]];
    [pbtn setTag:0];

    [pbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [priceView addSubview:pbtn];
    
//    采购清单
    UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(supportView.frame.origin.x+supportView.frame.size.width+20, supportView.frame.origin.y, 80, 80)];
    [listView setBackgroundColor:[UIColor clearColor]];
    listView      .layer.cornerRadius = 6;
    listView.layer.masksToBounds = YES;
    [self.view addSubview:listView];
    UIImageView* bgview3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_ico_back.png"]];
    bgview3.frame = CGRectMake(0, 0, priceView  .frame.size.width, priceView.frame.size.height);
    [listView addSubview:bgview3];
    
    UIImageView *listImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 30, 30)];
    [listImage setImage:[UIImage imageNamed:@"menu_ico_c_on.png"]];
    [listView addSubview:listImage];
    
    UILabel *lLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, listView.frame.size.width, 20)];
    [lLabel setText:@"采购清单"];
    [lLabel setTextColor:[UIColor whiteColor]];
    [lLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [lLabel setTextAlignment:NSTextAlignmentCenter];
    [listView addSubview:lLabel];
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lbtn setFrame:CGRectMake(0, 0, 80, 80)];
    [lbtn setBackgroundColor:[UIColor clearColor]];
    [lbtn setTag:2];
    [lbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [listView addSubview:lbtn];
    
    
    
//    关于中农
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(priceView.frame.origin.x, priceView.frame.origin.y+priceView.frame.size.height+20, 80, 80)];
    [infoView setBackgroundColor:[UIColor clearColor]];
    infoView      .layer.cornerRadius = 6;
    infoView.layer.masksToBounds = YES;
    [self.view addSubview:infoView];
    UIImageView* bgview4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_ico_back.png"]];
    bgview4.frame = CGRectMake(0, 0, priceView  .frame.size.width, priceView.frame.size.height);
    [infoView addSubview:bgview4];
    
    UIImageView *infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 30)];
    [infoImage setImage:[UIImage imageNamed:@"home_ico_d.png"]];
    [infoView addSubview:infoImage];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, infoView.frame.size.width, 20)];
    [infoLabel setText:@"关于中农"];
    [infoLabel setTextColor:[UIColor whiteColor]];
    [infoLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoView addSubview:infoLabel];
    
    UIButton *infobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infobtn setFrame:CGRectMake(0, 0, 80, 80)];
    [infobtn setBackgroundColor:[UIColor clearColor]];
    [infobtn setTag:4];
    [infobtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:infobtn];
    
    
//    会员服务
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(supportView.frame.origin.x, infoView.frame.origin.y, 80, 80)];
    [userView setBackgroundColor:[UIColor clearColor]];
    userView      .layer.cornerRadius = 6;
    userView.layer.masksToBounds = YES;
    [self.view addSubview:userView];
    UIImageView* bgview5= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_ico_back.png"]];
    bgview5.frame = CGRectMake(0, 0, priceView  .frame.size.width, priceView.frame.size.height);
    [userView addSubview:bgview5];
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 30)];
    [userImage setImage:[UIImage imageNamed:@"home_ico_e.png"]];
    [userView addSubview:userImage];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, userView.frame.size.width, 20)];
    [userLabel setText:@"会员服务"];
    [userLabel setTextColor:[UIColor whiteColor]];
    [userLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [userLabel setTextAlignment:NSTextAlignmentCenter];
    [userView addSubview:userLabel];
    
    UIButton *userbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [userbtn setFrame:CGRectMake(0, 0, 80, 80)];
    [userbtn setBackgroundColor:[UIColor clearColor]];
    [userbtn setTag:5];
    [userbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:userbtn];
    
    
    
//    注册登录
    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(listView.frame.origin.x, infoView.frame.origin.y, 80, 80)];
    [loginView setBackgroundColor:[UIColor clearColor]];
    loginView      .layer.cornerRadius = 6;
    loginView.layer.masksToBounds = YES;
    [self.view addSubview:loginView];
    UIImageView* bgview6= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_ico_back.png"]];
    bgview6.frame = CGRectMake(0, 0, priceView  .frame.size.width, priceView.frame.size.height);
    [loginView addSubview:bgview6];
    
    UIImageView *loginImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 30)];
    [loginImage setImage:[UIImage imageNamed:@"home_ico_f.png"]];
    [loginView addSubview:loginImage];
    
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, loginView.frame.size.width, 20)];
    [loginLabel setText:@"注册/登录"];
    [loginLabel setTextColor:[UIColor whiteColor]];
    [loginLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [loginView addSubview:loginLabel];
    
    UIButton *loginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginbtn setFrame:CGRectMake(0, 0, 80, 80)];
    [loginbtn setBackgroundColor:[UIColor clearColor]];
    [loginbtn setTag:3];
    [loginbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginbtn];
    
    
    
//    广告页面
    UIImageView *adWeb = [[UIImageView alloc ] initWithFrame:CGRectMake(0, screenHeight-150 , screenWidth, 150)];
    [adWeb setImage:[UIImage imageNamed:@"ad.png"]];
    [self.view addSubview:adWeb];
    
    UIView *hLine  = [[UIView alloc] initWithFrame:CGRectMake(0, adWeb.frame.origin.y-1, screenWidth, 1)];
    [hLine setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:hLine];
    

    
    [self getIP];
    
}

-(IBAction)btnClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case 0:
            [self jumpTabbarView:btn.tag];
            break;
        case 1:
            [self jumpTabbarView:btn.tag];

            break;
        case 2:
            [self jumpTabbarView:btn.tag];
//            跳转到清单列表

            break;
        case 3:
            [self jumpTabbarView:btn.tag];

            break;
        case 4:
        {
            InfoViewController *info = [[InfoViewController alloc] init];
            [info setHomeMsg:YES];
            [self.navigationController pushViewController:info animated:YES];
        }
            break;
        case 5:
//            跳跃到会员服务
        {
            ServiceViewController *serVC = [[ServiceViewController alloc] init];
            [serVC setHomeMsg:YES];
            [self.navigationController pushViewController:serVC animated:YES];
        }
        
            break;
            
        default:
            break;
    }
}
-(void)jumpTabbarView:(int)tag
{
    UITabBarController *mainViewController = [[UITabBarController alloc] init];

    UIImageView *tab = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_back.png"]];
    tab.frame= CGRectMake(0, 0, screenWidth, 49);
    [mainViewController.tabBar insertSubview:tab atIndex:1] ;
    [mainViewController.tabBar setTintColor:[UIColor whiteColor]];
    
    
    
    PriceViewController *priceViewController = [[PriceViewController alloc] init];
    priceViewController.title = @"查价格";
    priceViewController.tabBarItem.image =[UIImage imageNamed:@"menu_ico_a.png"];
    priceViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"menu_ico_a_on.png"];
    
    
    
    SupportViewController *supportViewController = [[SupportViewController alloc] init];
    supportViewController.title = @"找供应商";
    supportViewController.tabBarItem.image =[UIImage imageNamed:@"menu_ico_b.png"];
    supportViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"menu_ico_b_on.png"];
    
    ListViewController *vipViewController = [[ListViewController alloc] init];
    vipViewController.title = @"采购清单";
    vipViewController.tabBarItem.image =[UIImage imageNamed:@"menu_ico_c.png"];
    vipViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"menu_ico_c_on.png"];

    
//    登录状态
    VIPViewController *vipcv=[[VIPViewController alloc] init];
    vipcv.title = @"我";
    vipcv.tabBarItem.image =[UIImage imageNamed:@"menu_ico_d.png"];
    vipcv.tabBarItem.selectedImage = [UIImage imageNamed:@"menu_ico_d_on.png"];
    
    
//    未登录状态
    LoginViewController *loginVC = [[LoginViewController alloc ] init];
    loginVC.title = @"我";
    loginVC.homeMsg = YES;
    loginVC.tabBarItem.image =[UIImage imageNamed:@"menu_ico_d.png"];
    loginVC.tabBarItem.selectedImage = [UIImage imageNamed:@"menu_ico_d_on.png"];
    
    if ([WeGameHelper getLogin]) {
            [mainViewController setViewControllers:[[NSArray alloc] initWithObjects:priceViewController,supportViewController,vipViewController,vipcv, nil]];
    }

    else
    {
            [mainViewController setViewControllers:[[NSArray alloc] initWithObjects:priceViewController,supportViewController,vipViewController,loginVC, nil]];
    }
    [mainViewController setSelectedIndex:tag];
    [self.navigationController pushViewController:mainViewController animated:YES];
    
}
#pragma mark - 实现取消按钮的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder]; // 丢弃第一使用者
}
#pragma mark - 实现键盘上Search按钮的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"您点击了键盘上的Search按钮");
    [searchBar resignFirstResponder];
    SearchResuleViewController *srvc = [[SearchResuleViewController alloc ] init];
    srvc.SearchString = searchBar.text;
    srvc.homeMsg = YES;
    [self.navigationController pushViewController:srvc animated:YES];
    

}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //if we only try and resignFirstResponder on textField or searchBar,
    //the keyboard will not dissapear (at least not on iPad)!
    [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:oneSearchBar afterDelay: 0.1];
    return YES;
}
#pragma mark - 实现监听开始输入的方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"开始输入搜索内容");
    return YES;
}
#pragma mark - 实现监听输入完毕的方法
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    NSLog(@"输入完毕");
    return YES;
}

-(void)getIP
{
    NSString *str=[NSString stringWithFormat:GETIP];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
//        NSLog(@"获取到的IP为：%@",html);
        [self getCity:html];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [cityButton setTitle:@"深圳" forState:UIControlStateNormal];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}
-(void)getCity:(NSString*)IP
{
    __block NSDictionary *dict = [[NSDictionary alloc] init];
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET: [[NSString stringWithFormat:@"%@%@",GETCITY,IP] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //  请求成功时的操作
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        [cityButton setTitle:[NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"city"]] forState:UIControlStateNormal];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [cityButton setTitle:@"深圳" forState:UIControlStateNormal];
    }];

}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    [oneSearchBar resignFirstResponder];
//    for (UITouch *touch in touches) {
//        
//        if (CGRectContainsPoint(self.view.frame, [touch locationInView:self.view])) {
//            [oneSearchBar resignFirstResponder];
//        }
//    }
//}
@end
