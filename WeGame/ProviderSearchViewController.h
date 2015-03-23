//
//  ProviderSearchViewController.h
//  WeGame
//
//  Created by Lynnrichter on 15/2/4.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeGameHelper.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "ProviderViewController.h"
#import "MBProgressHUD.h"
@interface ProviderSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    float screenWidth;
    float screenHeight;
    float trendY;
    NSMutableArray * infoData ;
    UITableView *DataTableView;
    UIActivityIndicatorView *activity;
    NSString    *SearchString;
}

@end
