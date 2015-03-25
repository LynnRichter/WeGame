//
//  MainViewController.h
//  WeGame
//
//  Created by Lynnrichter on 15/1/20.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceViewController.h"
#import "SupportViewController.h"
#import "LoginViewController.h"
#import "InfoViewController.h"
#import "ListViewController.h"
#import "VIPViewController.h"
#import "ServiceViewController.h"
#import "AFNetworking.h"
#import "SearchResuleViewController.h"

#import "WeGameHelper.h"

@interface MainViewController : UIViewController<UISearchBarDelegate>
{
    float screenWidth;
    float screenHeight;
    UIButton *cityButton;
    UISearchBar *oneSearchBar;
    NSString *HTML;

}

@end
