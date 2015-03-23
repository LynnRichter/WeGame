//
//  ListViewController.h
//  WeGame
//
//  Created by Lynnrichter on 15/1/23.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeGameHelper.h"
#import "XCMultiSortTableView.h"
#import "DetailViewController.h"
#import "LMComBoxView.h"
#import "LMComBox/LMContainsLMComboxScrollView.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
@interface ListViewController : UIViewController<XCMultiTableViewDataSource,XCMultiTableViewDelegate,LMComBoxViewDelegate,UIAlertViewDelegate>
{
    float screenWidth;
    float screenHeight;
    float trendY;
    UIDatePicker *datePicker;
    UIToolbar *dateTool;

    UIButton *timeBtn ;
    NSString *selectCity;
    NSString *selectCityID;
    NSMutableArray *Cities;
    NSString  *selectDate;
    int SortByName;
    int SortByPrice;
    int PriceIndex;

    
    NSMutableArray *headData;
    NSMutableArray * infoData ;
    
    LMContainsLMComboxScrollView *bgScrollView;
    LMComBoxView *timeBox;
    LMComBoxView *cityBox;
    XCMultiTableView *tableView;
    UIView *filterView;
    UIActivityIndicatorView *activity;
    


}

@end
