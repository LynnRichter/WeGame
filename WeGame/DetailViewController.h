//
//  DetailViewController.h
//  WeGame
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeGameHelper.h"
#import "AFNetworking/AFNetworking.h"
#import "FYChartView.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
@interface DetailViewController : UIViewController<FYChartViewDataSource,UIAlertViewDelegate>
{
    float screenWidth;
    float screenHeight;
    float cellHeight;
    float trendY;
    UIScrollView *parentView;
    
    AFHTTPRequestOperationManager *manager;
    NSString *server;
    FYChartView *chartView;
    NSMutableArray *lineData;
    BOOL isInsert;
    UIActivityIndicatorView *activity;

    
}
@property(strong ,nonatomic)NSDictionary *ProductInfo;
@property(strong,nonatomic)NSString *cityName;
@end
