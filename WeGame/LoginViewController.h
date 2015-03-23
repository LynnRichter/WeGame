//
//  LoginViewController.h
//  WeGame
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistViewController.h"
#import "WeGameHelper.h"
#import "AFNetworking/AFNetworking.h"
#import "MBProgressHUD.h"

@protocol ChangeUser <NSObject>

@optional
-(void)changed:(BOOL)value;

@end

@interface LoginViewController : UIViewController
{
    float screenWidth;
    float screenHeight;
    UIActivityIndicatorView *activity;

}


@property (nonatomic,assign)BOOL homeMsg;
@end
