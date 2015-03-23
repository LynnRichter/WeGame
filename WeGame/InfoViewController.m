//
//  InfoViewController.m
//  WeGame
//
//  Created by Lynnrichter on 15/1/21.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize homeMsg;

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
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //顶部导航条
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    [topBackView setBackgroundColor: RGBClor(53, 136, 211)];
    [self.view addSubview:topBackView];
    
    //顶部蓝色部位
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(53, 22, screenWidth-53*2, 44)];
    [topView setBackgroundColor: RGBClor(53, 136, 211)];
    [self.view addSubview:topView];
    
 
    
    //顶部文字
    UILabel *title =[[UILabel alloc]  initWithFrame:topView.frame];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    [title setText:@"关于中农"];
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
    
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 156)/2, vLine3.frame.origin.y+16, 156, 44)];
    [logo setImage:[UIImage imageNamed:@"about_logo.jpg"]];
    [self.view addSubview:logo];
    
    
    NSString *promiseText = @"      深圳市中农数据有限公司（简称“中农数据”）深圳市农产品股份有限公司(SZ000061)旗下企业；专业的农产品大数据公司 ；专注于农产品大数据提供商和农产品价格数据权威服务平台；汇集全国几十家农产品批发市场的农产品数据；公司编制和发布了“前海   中国农产品批发价格系列指数”；服务于深圳3000多家采购商会员；为政府、企事业单位食堂、餐饮企业等提供价格参考服务。";
    //    NSString *descText = [NSString stringWithFormat:@"%@",[item objectForKey:@"promise"]];
    
    CGSize size = CGSizeMake(300, 2000);
    CGRect labRect = [promiseText boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Helvetica-Bold" size:18] forKey:NSFontAttributeName] context:nil];
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(10, logo.frame.origin.y+logo.frame.size.height+10, screenWidth-20, labRect.size.height)];
    desc.text = promiseText;
    desc.font = [UIFont fontWithName:@"Helvetica" size:18];
    desc.numberOfLines = 100;
    desc.textColor =RGBClor(74, 74, 74);
    [self.view  addSubview:desc];
}

-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
