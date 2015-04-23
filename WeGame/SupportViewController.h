//
//  SupportViewController.h
//  WeGame
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking/AFNetworking.h"
#import "PrefixHeader.pch"
#import "LMContainsLMComboxScrollView.h"
#import "LMComBoxView.h"
#import "WeGameHelper.h"
#import "UIImageView+AFNetworking.h"
#import "ProviderViewController.h"
#import "MBProgressHUD.h"
#import "ProviderSearchViewController.h"
#import "MainViewController.h"


@interface SupportViewController : UIViewController<LMComBoxViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    float screenWidth;
    float screenHeight;
    float startY;
    BOOL  first;
    NSString *selectType;
    NSString *selectTypeID;
    NSString *selectCity;
    NSString *selectCityID;
    NSMutableArray *Categories;
    NSMutableArray *Cities;
    NSMutableArray *infoData;
    UILabel *descLabel;
    UILabel     *sumLabel;
    UILabel *unitLabel;
    int page;
    int Total;
    
    AFHTTPRequestOperationManager *manager;

    LMContainsLMComboxScrollView *bgScrollView;
    LMComBoxView *typeBox;
    LMComBoxView *cityBox;
    
    UITableView *dataTable;
    
    UIActivityIndicatorView *activity;

}

@end
