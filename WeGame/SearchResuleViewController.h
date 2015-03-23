//
//  SearchResuleViewController.h
//  WeGame
//
//  Created by Lynnrichter on 15/2/3.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCMultiSortTableView.h"
#import "DetailViewController.h"
#import "LoginViewController.h"

@interface SearchResuleViewController : UIViewController<UISearchBarDelegate,LMComBoxViewDelegate,XCMultiTableViewDataSource,XCMultiTableViewDelegate,UIAlertViewDelegate>
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
    UISearchBar *oneSearchBar;

}
@property (nonatomic,retain)NSString *SearchString;
@property (nonatomic,assign)BOOL    homeMsg;

@end
