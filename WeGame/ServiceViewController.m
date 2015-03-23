//
//  ServiceViewController.m
//  WeGame
//
//  Created by Lynnrichter on 15/1/23.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()

@end

@implementation ServiceViewController
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
    [title setText:@"会员服务"];
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
    
    NSString *promiseText = @"     手机端客户可免费查看全国各个市场5000多个品种的价格行情,并可添加100个品种到采购清单,收费会员可添加5000多个品种到采购清单";
    //    NSString *descText = [NSString stringWithFormat:@"%@",[item objectForKey:@"promise"]];
    
    CGSize size = CGSizeMake(300, 2000);
    CGRect labRect = [promiseText boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Helvetica-Bold" size:18] forKey:NSFontAttributeName] context:nil];
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(10, vLine3.frame.origin.y+vLine3.frame.size.height+20, screenWidth-20, labRect.size.height)];
    desc.text = promiseText;
    desc.font = [UIFont fontWithName:@"Helvetica" size:18];
    desc.numberOfLines = 100;
    desc.textColor =RGBClor(74, 74, 74);
    [self.view  addSubview:desc];
    
    
    UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(desc.frame.origin.x, desc.frame.origin.y+desc.frame.size.height+3, screenWidth-20, 30)];
    
    label1.text = @"     平台现有的会员服务:";
    label1.font = [UIFont fontWithName:@"Helvetica" size:18];
    label1.textColor =RGBClor(74, 74, 74);
    [self.view  addSubview:label1];
    
    UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+label1.frame.size.height+3, screenWidth-20, 30)];
    
    label2.text = @"     5800元/年套餐";
    label2.font = [UIFont fontWithName:@"Helvetica" size:18];
    label2.textColor =RGBClor(255,102,0);
    [self.view  addSubview:label2];
    
    UILabel *label3 =[[UILabel alloc] initWithFrame:CGRectMake(label2.frame.origin.x, label2.frame.origin.y+label2.frame.size.height+3, screenWidth-20, 30)];
    
    label3.text = @"     定制会员服务";
    label3.font = [UIFont fontWithName:@"Helvetica" size:18];
    label3.textColor =RGBClor(74, 74, 74);
    [self.view  addSubview:label3];
    
    UILabel *label4 =[[UILabel alloc] initWithFrame:CGRectMake(label3.frame.origin.x, label3.frame.origin.y+label3.frame.size.height+3, screenWidth-20, 30)];
    
    label4.text = @"     招标信息服务";
    label4.font = [UIFont fontWithName:@"Helvetica" size:18];
    label4.textColor =RGBClor(74, 74, 74);
    [self.view  addSubview:label4];
    
    UILabel *label5 =[[UILabel alloc] initWithFrame:CGRectMake(label4.frame.origin.x, label4.frame.origin.y+label4.frame.size.height+3, screenWidth-20, 30)];
    
    label5.text = @"     推广服务";
    label5.font = [UIFont fontWithName:@"Helvetica" size:18];
    label5.textColor =RGBClor(74, 74, 74);
    [self.view  addSubview:label5];
    
    UILabel *label6 =[[UILabel alloc] initWithFrame:CGRectMake(label5.frame.origin.x, label5.frame.origin.y+label5.frame.size.height+3, screenWidth-20, 30)];
    
    label6.text = @"     详情请咨询客服热线";
    label6.font = [UIFont fontWithName:@"Helvetica" size:18];
    label6.textColor =RGBClor(74, 74, 74);
    [self.view  addSubview:label6];
    
    UIButton *contactNumber = [[UIButton alloc] initWithFrame:CGRectMake(label6.frame.origin.x+20, label6.frame.origin.y+label6.frame.size.height+3, 120, 30)];
    [contactNumber setTitle:@"400-114-6668" forState:UIControlStateNormal];
    //    [contactNumber setText:[NSString stringWithFormat:@"%@",[item objectForKey@"contactNumber"]]];
    [contactNumber setTitleColor:RGBClor(255, 102, 0) forState:UIControlStateNormal];
    [contactNumber.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [contactNumber.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    [contactNumber addTarget:self action:@selector(callNumber:)  forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:contactNumber];

    
    


    
    

}

-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)callNumber:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4001146668"]]];//打电话
}
@end
