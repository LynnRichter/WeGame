//
//  RegistViewController.h
//  WeGame
//
//  Created by Lynnrichter on 15/1/4.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMComBoxView.h"
#import "LMContainsLMComboxScrollView.h"
#import "WeGameHelper.h"
#import "AFNetworking/AFNetworking.h"
#import "MBProgressHUD.h"
#import "AgreementViewController.h"

@interface RegistViewController : UIViewController<LMComBoxViewDelegate,UITextFieldDelegate>
{
    
    AFHTTPRequestOperationManager *manager;
    UITextField *phoneText;
    UITextField *pwdText;
    UITextField *nameText;
    UITextField *mailText;
    UITextField *cardText;
    NSMutableArray *Category;
    BOOL        agree;
    NSString    *typeID;
    UIScrollView *parentView;
    float screenWidth ;
    float screenHeight;
    LMContainsLMComboxScrollView *bgScrollView;
}
@property (nonatomic,assign)BOOL homeMsg;


@end
