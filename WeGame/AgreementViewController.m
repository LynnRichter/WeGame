//
//  AgreementViewController.m
//  WeGame
//
//  Created by Lynnrichter on 15/3/4.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

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
    
    
    //顶部文字
    UILabel *title =[[UILabel alloc]  initWithFrame:CGRectMake((screenWidth-200)/2, 22, 200, 44)];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    [title setText:@"中农数据服务协议"];
    [title setFont:titleFont];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    //    顶部图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"同意" forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"bank_ico.png" ] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:RGBClor(82, 152, 216)];
    backBtn.layer.cornerRadius = 6;
    backBtn.layer.borderColor = [RGBClor(50, 120, 183) CGColor];
    [backBtn setFrame:CGRectMake(5, 33, 50, 22)];
    [backBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];

    [topBackView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"chinaap"
                                                     ofType:@"html"];
    
    NSString *descText = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL];;
//    
//    CGSize size = CGSizeMake(screenWidth, 2000);
//    
//    CGRect labRect = [descText boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Helvetica" size:14] forKey:NSFontAttributeName] context:nil];
//    
//    
//    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth, labRect.size.height)];
//    desc.text = descText;
//    desc.font = [UIFont fontWithName:@"Helvetica" size:14];
//    desc.numberOfLines = 100;
//    desc.textColor =RGBClor(74, 74, 74);
////    desc.backgroundColor = [UIColor redColor];
//    [self.view addSubview:desc];
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth, screenHeight-topBackView.frame.origin.y-topBackView.frame.size.height)];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
  
    [webView loadHTMLString:descText baseURL:baseURL];
    [self.view addSubview:webView];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)backPress
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
