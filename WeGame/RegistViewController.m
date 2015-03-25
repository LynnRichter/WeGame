//
//  RegistViewController.m
//  WeGame
//
//  Created by Lynnrichter on 15/1/4.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    agree = NO;
    typeID = @"1";
    [self UIFactory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UIFactory
{
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    //顶部导航条
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    [topBackView setBackgroundColor: RGBClor(53, 136, 211)];
    [self.view addSubview:topBackView];
    
    
    //顶部文字
    UILabel *title =[[UILabel alloc]  initWithFrame:CGRectMake((screenWidth-200)/2, 22, 200, 44)];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    [title setText:@"注册成中农数据会员"];
    [title setFont:titleFont];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    //    顶部图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"bank_ico.png" ] forState:UIControlStateNormal];
    
    [backBtn setFrame:CGRectMake(5, 33, 22 , 22)];
    [topBackView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //顶部与底部的分隔符
    UIView *vLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth,1)];
    [vLine3 setBackgroundColor:RGBClor(32, 37, 44)];
    [self.view addSubview:vLine3];

    parentView = [[UIScrollView alloc ] initWithFrame:CGRectMake(0, topBackView.frame.size.height+2, screenWidth, screenHeight-topBackView.frame.size.height-44)];
    parentView.showsHorizontalScrollIndicator = NO;
    parentView.showsVerticalScrollIndicator = NO;
//    parentView.contentSize = CGSizeMake(screenWidth, screenHeight);
    parentView.contentSize = parentView.frame.size;
    [self.view addSubview:parentView];
    
    
    //会员类型选择
    UIImageView *vipImg = [[UIImageView alloc ] initWithFrame:CGRectMake(10, 4, 30,30)];
    [vipImg setImage:[UIImage imageNamed:@"reg_ico_a.png"]];
    [parentView addSubview:vipImg];
    
    NSDictionary *item  = [[NSDictionary alloc] initWithObjectsAndKeys:@"请选择会员类型",@"name",@"0",@"ID" ,nil];
    NSDictionary *item0 = [[NSDictionary alloc] initWithObjectsAndKeys:@"企事业",@"name",@"1",@"ID" ,nil];
    NSDictionary *item1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"学校",@"name",@"2",@"ID" ,nil];
    NSDictionary *item2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"酒店",@"name",@"3",@"ID" ,nil];
    NSDictionary *item3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"供应商",@"name",@"4",@"ID" ,nil];
    NSDictionary *item4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"其他",@"name",@"5",@"ID" ,nil];
    
    Category = [[NSMutableArray alloc] initWithObjects:item,item4,item0,item1,item2,item3, nil];
    
    

    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(vipImg.frame.origin.x+vipImg.frame.size.width+10, vipImg.frame.origin.y-3, 120, (1+[Category count])*40)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    
    
    LMComBoxView *typeBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(0, 0, bgScrollView.frame.size.width, 40)];
    [typeBox setBackgroundColor:[UIColor whiteColor]];
    [typeBox setArrowImgName:@"down_tri.png"];
    [typeBox setFontSize:14];
    [typeBox setKey:@"name"];
    [typeBox setTitlesList:Category];
    [typeBox setTag:0];
    typeBox.supView = bgScrollView;
    [typeBox setDelegate:self];
    [typeBox defaultSettings];
    [bgScrollView addSubview:typeBox];
    [parentView addSubview:bgScrollView];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, vipImg.frame.origin.y+vipImg.frame.size.height+8, screenWidth, 1)];
    [line setBackgroundColor:RGBClor(228, 228, 228)];
    [parentView addSubview:line];
    
    
    //手机号码输入
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(vipImg.frame.origin.x, line.frame.origin.y+line.frame.size.height+5, 30, 30)];
    [phoneImg setImage:[UIImage imageNamed:@"reg_ico_b.png"]];
    [parentView addSubview:phoneImg];
    
    phoneText = [[UITextField alloc] initWithFrame:CGRectMake(phoneImg.frame.origin.x+phoneImg.frame.size.width+10, phoneImg.frame.origin.y-3, 200, 40)];
    [phoneText setBorderStyle:UITextBorderStyleNone];
    [phoneText setDelegate:self];
    [phoneText setTag:89757];
    [phoneText setPlaceholder:@"手机号"];
    [parentView addSubview:phoneText];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, phoneImg.frame.origin.y+phoneImg.frame.size.height+8, screenWidth, 1)];
    [line1 setBackgroundColor:RGBClor(228, 228, 228)];
    [parentView addSubview:line1];
    //密码输入
    UIImageView *pwdImg = [[UIImageView alloc] initWithFrame:CGRectMake(vipImg.frame.origin.x, line1.frame.origin.y+line1.frame.size.height+5, 30, 30)];
    [pwdImg setImage:[UIImage imageNamed:@"reg_ico_c.png"]];
    [parentView addSubview:pwdImg];
    
    float eyebtnWidth = 30.f;
    UIButton *pwdBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [pwdBTN setFrame: CGRectMake(screenWidth-5-eyebtnWidth, pwdImg.frame.origin.y+8, eyebtnWidth, 15)];
    [pwdBTN setBackgroundImage:[UIImage imageNamed:@"ico_eye_on.png"] forState:UIControlStateNormal];
    [parentView addSubview:pwdBTN];
    [pwdBTN addTarget:self action:@selector(eyeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    pwdText = [[UITextField alloc] initWithFrame:CGRectMake(pwdImg.frame.origin.x+pwdImg.frame.size.width+10, pwdImg.frame.origin.y-3, screenWidth-eyebtnWidth-20-pwdImg.frame.size.width, 40)];
    [pwdText setBorderStyle:UITextBorderStyleNone];
    [pwdText setPlaceholder:@"6-14位密码，建议由数字、字母组成"];
    [pwdText setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [pwdText setSecureTextEntry:YES];
    [pwdText setDelegate:self];
    [parentView addSubview:pwdText];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, pwdImg.frame.origin.y+pwdImg.frame.size.height+8, screenWidth, 1)];
    [line2 setBackgroundColor:RGBClor(228, 228, 228)];
    [parentView addSubview:line2];

    
    //联系人姓名
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(vipImg.frame.origin.x, line2.frame.origin.y+line2.frame.size.height+5, 30, 30)];
    [headImg setImage:[UIImage imageNamed:@"reg_ico_d.png"]];
    [parentView addSubview:headImg];
    
    nameText = [[UITextField alloc] initWithFrame:CGRectMake(headImg.frame.origin.x+headImg.frame.size.width+10, headImg.frame.origin.y-3, 280, 40)];
    [nameText setBorderStyle:UITextBorderStyleNone];
    [nameText setPlaceholder:@"联系人姓名"];
    [nameText setDelegate: self];
    [parentView addSubview:nameText];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, headImg.frame.origin.y+headImg.frame.size.height+8, screenWidth, 1)];
    [line3 setBackgroundColor:RGBClor(228, 228, 228)];
    [parentView addSubview:line3];

    //邮箱
    UIImageView *mailImg = [[UIImageView alloc] initWithFrame:CGRectMake(vipImg.frame.origin.x, line3.frame.origin.y+line3.frame.size.height+5, 30, 30)];
    [mailImg setImage:[UIImage imageNamed:@"reg_ico_e.png"]];
    [parentView addSubview:mailImg];
    
    mailText = [[UITextField alloc] initWithFrame:CGRectMake(mailImg.frame.origin.x+mailImg.frame.size.width+10, mailImg.frame.origin.y-3, screenWidth-mailImg.frame.size.width-20, 40)];
    [mailText setBorderStyle:UITextBorderStyleNone];
    [mailText setPlaceholder:@"常用邮箱"];
    [mailText setDelegate: self];
    [parentView addSubview:mailText];
    
    float labelWidth =  70;
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-labelWidth-10, mailImg.frame.origin.y, labelWidth, 40)];
//    [label1 setText:@"(可不填)"];
//    [label1 setTextColor:RGBClor(213, 213, 213)];
//    [label1 setTextAlignment:NSTextAlignmentRight];
//    [parentView addSubview: label1];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, mailImg.frame.origin.y+mailImg.frame.size.height+8, screenWidth, 1)];
    [line4 setBackgroundColor:RGBClor(228, 228, 228)];
    [parentView addSubview:line4];
    //单位名称
    UIImageView *cardImg = [[UIImageView alloc] initWithFrame:CGRectMake(vipImg.frame.origin.x, line4.frame.origin.y+line4.frame.size.height+5, 30, 30)];
    [cardImg setImage:[UIImage imageNamed:@"reg_ico_f.png"]];
    [parentView addSubview:cardImg];
    
    cardText = [[UITextField alloc] initWithFrame:CGRectMake(cardImg.frame.origin.x+cardImg.frame.size.width+10, cardImg.frame.origin.y-3, 280, 40)];
    [cardText setBorderStyle:UITextBorderStyleNone];
    [cardText setPlaceholder:@"单位名称"];
    [cardText setDelegate:self];
    [parentView addSubview:cardText];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-labelWidth-10, cardImg.frame.origin.y-3, labelWidth, 40)];
    [label2 setText:@"(可不填)"];
    [label2 setTextColor:RGBClor(213, 213, 213)];
    [label2 setTextAlignment:NSTextAlignmentRight];
    [parentView addSubview: label2];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, cardImg.frame.origin.y+cardImg.frame.size.height+2, screenWidth, 1)];
    [line5 setBackgroundColor:RGBClor(228, 228, 228)];
    [parentView addSubview:line5];

   
    
    UILabel *agreeLab = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-120)/2, line5.frame.origin.y+line5.frame.size.height+10, 120, 20)];
    [agreeLab setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [agreeLab setTextColor:RGBClor(255, 102, 0)];
    [agreeLab setText:@"《中农数据服务协议》"];
    [parentView addSubview:agreeLab];
    
    //服务协议
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setBackgroundImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
    [agreeBtn setFrame:CGRectMake(agreeLab.frame.origin.x -30, agreeLab.frame.origin.y, 20, 20)];
    [agreeBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:agreeBtn];
    
    
    //注册按钮
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setFrame:CGRectMake((screenWidth - 170)/2, agreeLab.frame.origin.y+agreeLab.frame.size.height+15, 170, 36 )];
    [btnSubmit setBackgroundColor:RGBClor(255, 102, 0)];
    btnSubmit.layer.cornerRadius = 6;
    [btnSubmit setTintColor:[UIColor whiteColor]];
    [btnSubmit.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [btnSubmit setTitle:@"免费注册" forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btnSubmit];
    
    
    

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    parentView.contentSize = parentView.frame.size;
   

    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    parentView.contentSize = CGSizeMake(screenWidth, screenHeight);
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 89757) {
        NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:SERVER_STRING,@"server_str",CLIENT_STRING,@"client_str",phoneText.text,@"mobile",nil];
        
        __block NSDictionary * dict = [[NSDictionary alloc] init];
        
//        NSLog(@"检查手机请求数据；%@",parameters);
        [manager GET: [CHECKMOBILE stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //  请求成功时的操作
            
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"检查手机号返回数据 = %@",dict);
//            NSLog(@"info = %@",[dict objectForKey:@"info"]);
            
            if([[dict objectForKey:@"data"] integerValue] == 1)
            {
                [self showMSG:@"此手机号已经被注册"];

            }
           
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            NSLog(@"请求失败:%@",error);
        }];

    }
}
-(void)eyeButtonClick:(id)sender
{
    UIButton *pwdBTN = (UIButton*)sender;
    if (pwdText.secureTextEntry) {
        [pwdBTN setBackgroundImage:[UIImage imageNamed:@"ico_eye.png"] forState:UIControlStateNormal];
        [pwdText setSecureTextEntry:NO];

    }else
    {
        [pwdBTN setBackgroundImage:[UIImage imageNamed:@"ico_eye_on.png"] forState:UIControlStateNormal];
        [pwdText setSecureTextEntry:YES];


    }
}

//combox点击事件
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    [parentView exchangeSubviewAtIndex:3 withSubviewAtIndex:22];
//    int i=0;
//    for (UIView *view in parentView.subviews ) {
//        if ([view isKindOfClass:[LMContainsLMComboxScrollView class]]) {
//            NSLog(@"找到了%d",i);
////            break;
//        }
//        if ([view isKindOfClass:[UITextField class]]) {
//            NSLog(@"找到了textview %d",i);
////            break;
//        }
//
//        
//        i++;
//    }

    typeID = [[Category objectAtIndex:index] objectForKey:@"ID"];
//    NSLog(@"你选择的种类是：%@, and ID IS : %@",[[Category objectAtIndex:index] objectForKey:@"name"],typeID);
}

//获取条件设置
#pragma mark -LMComBoxViewDelegate
-(void)startChose
{
    [parentView bringSubviewToFront:bgScrollView];
}

//提交注册信息
-(void)submitClick
{

    if([self checkInput])
    {
        NSString *server = SERVER_STRING;
        NSString *phone = phoneText.text;
        NSString *pwd = pwdText.text;
        NSString *name = nameText.text;
        NSString *mail = mailText.text;
        NSString *card = cardText.text;
        NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str", typeID,@"userTypeID",phone,@"mobile",mail,@"email",pwd,@"password",card,@"company",name,@"contact",(agree?@"true":@"false"),@"agree", nil];
    
        __block NSDictionary * dict = [[NSDictionary alloc] init];

//        NSLog(@"注册请求数据；%@",parameters);
        [manager POST: [USER_REGIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //  请求成功时的操作

            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"注册接口返回数据 = %@",dict);
//            NSLog(@"info = %@",[dict objectForKey:@"info"]);
            
            if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"data"]]  isEqualToString:@""]) {
                [self showMSG:[NSString stringWithFormat:@"%@",[dict objectForKey:@"info"]]];
                return;
            }
//全局单例变量，跳转界面到
           [WeGameHelper saveString:[NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"userId"]] key:@"UserID"];
           [WeGameHelper saveString:[NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"userName"]] key:@"UserName"];
           [WeGameHelper setLogin:YES];
            [self showMSG:@"恭喜您，注册成功！"];
            

            
            dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
                [NSThread sleepForTimeInterval:2];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                   [self.navigationController popToRootViewControllerAnimated:YES];

                });
                
            });

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        
            NSLog(@"请求失败:%@",error);
        }];
            
   

    }
    
    
}
-(BOOL)checkInput
{
    if (phoneText.text.length == 0) {
        [self showMSG:@"手机号码不能为空"];
        return NO;
    }
    if (pwdText.text.length == 0) {
        [self showMSG:@"密码不能为空"];
        return NO;
    }
    if (nameText.text.length == 0) {
        [self showMSG:@"联系人姓名不能为空"];
        return NO;
    }

    if (mailText.text.length == 0) {
        [self showMSG:@"邮箱不能为空"];
        return NO;
    }
    if (!agree) {
        [self showMSG:@"请选择是否同意服务协议"];
        return NO;
    }
    return YES;
}

-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)agreeClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (agree) {
        agree =NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
    }
    else
    {
        agree =YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        AgreementViewController *avc = [[AgreementViewController alloc] init];
        [self presentViewController:avc animated:YES completion:nil];
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
