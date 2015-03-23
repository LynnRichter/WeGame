//
//  PriceViewController.h
//  WeGame
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMComBoxView.h"
#import "LMContainsLMComboxScrollView.h"
#import "AFNetworking/AFNetworking.h"
#import "XCMultiSortTableView.h"
#import "DetailViewController.h"
#import "SearchResuleViewController.h"
#import "MBProgressHUD.h"

@interface PriceViewController : UIViewController<LMComBoxViewDelegate,XCMultiTableViewDataSource,XCMultiTableViewDelegate,UIAlertViewDelegate>
{
    float screenWidth;
    float screenHeight;
    UIDatePicker *datePicker;
    UIToolbar *dateTool;
    UIButton *timeBtn ;
    NSString *selectType;
    NSString *selectTypeID;
    NSString *selectCity;
    NSString *selectCityID;
    NSMutableArray *Categories;
    NSMutableArray *Cities;
    NSString  *selectDate;
    int SortByName;
    int SortByPrice;
    int PriceIndex;
    int Total;
    int page;
    
    NSMutableArray *headData;
    NSMutableArray * infoData ;
    
    LMContainsLMComboxScrollView *bgScrollView;
    LMComBoxView *typeBox;
    LMComBoxView *timeBox;
    LMComBoxView *cityBox;
    XCMultiTableView *tableView;
    UIView *filterView;
    UIActivityIndicatorView *activity;
    MBProgressHUD *hud;

    
}
@end
