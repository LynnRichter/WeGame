//
//  ProviderViewController.m
//  WeGame
//
//  Created by Lynnrichter on 15/1/20.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "ProviderViewController.h"

@interface ProviderViewController ()

@end

@implementation ProviderViewController
@synthesize item;
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    //顶部导航条
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    [topBackView setBackgroundColor: RGBClor(71, 140, 205)];
    [self.view addSubview:topBackView];
    
    
    //    顶部图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"bank_ico.png" ] forState:UIControlStateNormal];
    
    [backBtn setFrame:CGRectMake(5, 33, 22 , 22)];
    [topBackView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //顶部文字
    UILabel *title =[[UILabel alloc]  initWithFrame:CGRectMake((screenWidth-220)/2, 24, 220, 40)];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:18];
//    [title setText:@"深圳市宏鸿农产品有限公司"];
    [title setText:[NSString stringWithFormat:@"%@",[item objectForKey:@"providerName"]]];
    [title setFont:titleFont];
    [title setTextColor:[UIColor whiteColor]];
    title.adjustsFontSizeToFitWidth =YES;
    [title setMinimumScaleFactor:0.5];
    [self.view addSubview:title];
    
    
    //顶部与底部的分隔符
    UIView *vLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth,1)];
    [vLine3 setBackgroundColor:RGBClor(32, 37, 44)];
    [self.view addSubview:vLine3];
    
    ParentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, vLine3.frame.origin.y+vLine3.frame.size.height, screenWidth, screenHeight-topBackView.frame.size.height-topBackView.frame.origin.y)];
    [self.view addSubview:ParentView];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 32)];
    [ParentView addSubview:view1];
    
    UILabel *product = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, screenWidth -5, 16)];
    [product setFont:[UIFont fontWithName:@"Helvetica" size:14]];
//    [product setText:@"主营产品：蔬菜、水果、鲜肉以及农产品配送"];
    [product setText:[NSString stringWithFormat:@"主营产品：%@",[item objectForKey:@"mainProduct"]]];
    [product setTextColor:RGBClor(74, 74, 74)];
    [view1 addSubview:product];
    
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.origin.y+view1.frame.size.height, screenWidth, 32)];
    [view2 setBackgroundColor:RGBClor(245, 245, 245)];
    [ParentView  addSubview:view2];
    
    UILabel *contact = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, screenWidth-5, 16)];
    [contact setFont:[UIFont fontWithName:@"Helvetica" size:14]];
//    [contact setText:@"联  系  人： 郑跃峰"];
    [contact setText:[NSString stringWithFormat:@"联  系  人： %@",[item objectForKey:@"contact"]]];
    [contact setTextColor:RGBClor(74, 74, 74)];
    [view2 addSubview:contact];
    
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.frame.origin.y+view2.frame.size.height, screenWidth, 32)];
    [ParentView  addSubview:view3];
    
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 70, 16)];
    [phone setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [phone setText:@"联系电话："];
    [phone setTextColor:RGBClor(74, 74, 74)];
//    [phone setBackgroundColor:[UIColor redColor]];
    [view3 addSubview:phone];

    
    UIButton *contactNumber = [[UIButton alloc] initWithFrame:CGRectMake(phone.frame.origin.x+phone.frame.size.width, phone.frame.origin.y, 90, phone.frame.size.height)];
    [contactNumber setTitle:[NSString stringWithFormat:@"%@",[item objectForKey:@"contactNumber"]] forState:UIControlStateNormal];
    //    [contactNumber setText:[NSString stringWithFormat:@"%@",[item objectForKey@"contactNumber"]]];
    [contactNumber setTitleColor:RGBClor(255, 102, 0) forState:UIControlStateNormal];
    [contactNumber.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [contactNumber.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    //    [contactNumber setBackgroundColor:[UIColor redColor]];
    [contactNumber addTarget:self action:@selector(callNumber:)  forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:contactNumber];

    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.frame.origin.y+view3.frame.size.height, screenWidth, 64)];
    [view4 setBackgroundColor:RGBClor(245, 245, 245)];
    [ParentView  addSubview:view4];
    
    UILabel *addLable = [[UILabel alloc] initWithFrame:CGRectMake(6, 8, 75, 16)];
    [addLable setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [addLable setText:@"公司地址："];
    [addLable setTextColor:RGBClor(74, 74, 74)];
//    [addLable setBackgroundColor:[UIColor redColor]];
    [view4 addSubview:addLable];
    
    UITextView *address = [[UITextView alloc] initWithFrame:CGRectMake(addLable.frame.origin.x+addLable.frame.size.width-5, addLable.frame.origin.y-7 , screenWidth-addLable.frame.origin.x-addLable.frame.size.width, addLable.frame.size.height*3)];
    [address setTextColor:RGBClor(74, 74, 74)];
    [address setBackgroundColor:[UIColor clearColor]];
    [address setFont:[UIFont fontWithName:@"Helvetica" size:14]];
//    [address setText:@"深圳平湖街道办良安田社区榄树下工业区149号"];
    [address setText:[NSString stringWithFormat:@"%@",[item objectForKey:@"companyAddress"]]];

    [view4 addSubview:address];
    
    
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, view4.frame.origin.y+view4.frame.size.height+10, screenWidth, 32)];
    [view5 setBackgroundColor:RGBClor(245, 245, 245)];
    [ParentView  addSubview:view5];
    
    UILabel *introduce = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, screenWidth, 32-2*5)];
    [introduce setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [introduce setTextColor:[UIColor blackColor]];
    [introduce setText:@"公司简介"];

    [view5 addSubview:introduce];
    
    UIView *hLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 32-2, introduce.frame.size.width, 2)];
    [hLine2 setBackgroundColor:RGBClor(71, 141, 205)];
    [view5 addSubview:hLine2];
    
    
//    NSString *descText = @"深圳市中央大厨房物流配送有限公司（简称“中央大厨房”，www.greenport.cn）是由深圳市农产品股份有限公司与新希望集团共同组建的创新型农产品物流服务公司，于2011年6月份正式注册成立，注册资本5000万元。深圳中央大厨房公司将依托股东农产品公司的批发市场网络优势、以新希望集团的泛食品行业产业优势为基础，以集约式中央厨房业务为切入点，上承农产品电子交易平台，下接流动售卖车零售网点 ";
    NSString *descText = [[[[[[NSString stringWithFormat:@"%@",[item objectForKey:@"detailIntro"]] stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@""] stringByReplacingOccurrencesOfString:@"&rdquo" withString:@""] stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@""] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];

    CGSize size = CGSizeMake(300, 2000);
    CGRect labRect = [descText boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Helvetica" size:14] forKey:NSFontAttributeName] context:nil];
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(10, view5.frame.origin.y+view5.frame.size.height+10, screenWidth-20, labRect.size.height)];
    desc.text = descText;
    desc.font = [UIFont fontWithName:@"Helvetica" size:14];
    desc.numberOfLines = 100;
    desc.textColor =RGBClor(74, 74, 74);
    [ParentView  addSubview:desc];
    
    
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(0, desc.frame.origin.y+desc.frame.size.height+10, screenWidth, 32)];
    [view6 setBackgroundColor:RGBClor(245, 245, 245)];
    [ParentView  addSubview:view6];
    
    UILabel *promise = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, screenWidth, 32-2*5)];
    [promise setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [promise setTextColor:[UIColor blackColor]];
    [promise setText:@"服务承诺"];
    
    [view6 addSubview:promise];
    
    UIView *hLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, 32-2, promise.frame.size.width, 2)];
    [hLine3 setBackgroundColor:RGBClor(71, 141, 205)];
    [view6 addSubview:hLine3];
    
//    NSString *promiseText = @"深圳市中央大厨房物流配送有限公司（简称“中央大厨房”，www.greenport.cn）是由深圳市农产品股份有限公司与新希望集团共同组建的创新型农产品物流服务公司，于2011年6月份正式注册成立，注册资本5000万元。深圳中央大厨房公司将依托股东农产品公司的批发市场网络优势、以新希望集团的泛食品行业产业优势为基础，以集约式中央厨房业务为切入点，上承农产品电子交易平台，下接流动售卖车零售网点 ";
    NSString *promiseText = [[[[[[NSString stringWithFormat:@"%@",[item objectForKey:@"promise"]] stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@""] stringByReplacingOccurrencesOfString:@"&rdquo" withString:@""] stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@""] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];    
    size = CGSizeMake(300, 2000);
    labRect = [promiseText boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Helvetica" size:14] forKey:NSFontAttributeName] context:nil];
    UILabel *promistLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, view6.frame.origin.y+view6.frame.size.height+10, screenWidth-20, labRect.size.height)];
    promistLabel.text = promiseText;
    promistLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    promistLabel.numberOfLines = 100;
    promistLabel.textColor =RGBClor(74, 74, 74);
    [ParentView  addSubview:promistLabel];
    
    [ParentView setContentSize:CGSizeMake(screenWidth, promistLabel.frame.origin.y+promistLabel.frame.size.height+10)];
    
    
    
}
-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)callNumber:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",btn.titleLabel.text]]];//打电话
}
@end
