//
//  ListViewController.m
//  WeGame
//
//  Created by Lynnrichter on 15/1/23.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIFactory];
    infoData = [[NSMutableArray alloc] initWithCapacity:0];
    selectCityID =  @"1";
    selectCity  = @"深圳";
    
    SortByName = 1;
    SortByPrice = 0;
    // Do any additional setup after loading the view.
}
-(void)UIFactory
{
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
//    float cellHeight = 30;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //顶部导航条
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    [topBackView setBackgroundColor: RGBClor(53, 136, 211)];
    [self.view addSubview:topBackView];
    
    //顶部文字
    UILabel *title =[[UILabel alloc]  initWithFrame:CGRectMake(50, 22, 200, 44)];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    [title setText:@"采购清单"];
    [title setFont:titleFont];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    
    //    顶部图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"bank_home_ico.png" ] forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(10, 33, 22, 22)];
    [topBackView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"refresh_ico.png" ] forState:UIControlStateNormal];
    [searchButton setFrame:CGRectMake(screenWidth-22-10, 33, 22, 22)];
    [searchButton addTarget:self action:@selector(startLoadData) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:searchButton];

    
    
    //顶部与底部的分隔符
    UIView *vLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth,1)];
    [vLine3 setBackgroundColor:RGBClor(32, 37, 44)];
    [self.view addSubview:vLine3];
    
  
    //搜索栏
    filterView = [[UIView alloc ]initWithFrame:CGRectMake(0, vLine3.frame.size.height+vLine3.frame.origin.y, screenWidth, 42)];
    [filterView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:filterView];
    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, filterView.frame.origin.y, 260, filterView.frame.size.height*100)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.tag = 8975;
    [self.view addSubview:bgScrollView];
    
    //查询按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchBtn setTitle:@"开始搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:RGBClor(255, 128, 0)];
    [searchBtn setFrame:CGRectMake(screenWidth-5-68, 5+vLine3.frame.size.height+vLine3.frame.origin.y
                                   , 68, 30)];
    searchBtn.layer.cornerRadius = 8;
    [searchBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(startLoadData) forControlEvents:UIControlEventTouchUpInside];
    
    
    trendY = vLine3.frame.origin.y+vLine3.frame.size.height;
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setCenter:self.view.center];
    [activity setHidesWhenStopped:YES];
    [self.view addSubview:activity];

    headData = [NSMutableArray arrayWithCapacity:10];
    [headData addObject:@"规格"];
    [headData addObject:@"批发价"];
    [headData addObject:@"单位"];
    [headData addObject:@"购买指数"];
    [headData addObject:@"价格来源"];
    [headData addObject:@"报价日期"];
    [headData addObject:@"采购清单"];

    
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setCenter:self.view.center];
    [activity setHidesWhenStopped:YES];
    [self.view addSubview:activity];
    [activity startAnimating];
    [self getCity];
    
    
    
    

}

//获取所有城市
-(void)getCity
{
    
    NSString *server = SERVER_STRING;
    
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",nil];
    
    __block NSDictionary *dict = [[NSDictionary alloc] init];
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // GET请求
    [manager GET: [CITY_INFO stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activity stopAnimating];
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        Cities = [dict objectForKey:@"data"];
        cityBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(10, 5,52, 30)];
        [cityBox setBackgroundColor: [UIColor whiteColor]];
        [cityBox setArrowImgName:@"down_tri.png"];
        [bgScrollView addSubview:cityBox];
        
        [cityBox setTitlesList:Cities];
        [cityBox setKey:@"shortName"];
        [cityBox setTag:1];
        cityBox.supView = bgScrollView;
        [cityBox setDelegate:self];
        [cityBox setHasBoard:YES];
        [cityBox defaultSettings];
        
        
        UIButton *typeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [typeButton setFrame:CGRectMake(cityBox.frame.origin.x+cityBox.frame.size.width+3, cityBox.frame.origin.y, 85, cityBox.frame.size.height)];
        [typeButton setTitle:@"采购清单" forState:UIControlStateNormal];
        [typeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [typeButton setTitleColor:RGBClor(74, 74, 74) forState:UIControlStateNormal];
        typeButton.layer.borderColor = [RGBClor(238, 238, 238) CGColor];
        typeButton.layer.borderWidth = 0.5;
        [bgScrollView addSubview:typeButton];
        
        
        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSDate *curDate = [NSDate date];//获取当前日期
        NSString * curTime = [formater stringFromDate:curDate];
        selectDate = [NSString stringWithFormat:@"%ld", (long)[curDate timeIntervalSince1970]];
        
        timeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [timeBtn setFrame:CGRectMake(typeButton.frame.origin.x+typeButton.frame.size.width+3, typeButton.frame.origin.y, 85, typeButton.frame.size.height)];
        [timeBtn setTitle:curTime forState:UIControlStateNormal];
        [timeBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [timeBtn setTitleColor:RGBClor(74, 74, 74) forState:UIControlStateNormal];
        timeBtn.layer.borderColor = [RGBClor(238, 238, 238) CGColor];
        timeBtn.layer.borderWidth = 0.5;
        [timeBtn addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventTouchUpInside];
        
        [bgScrollView addSubview:timeBtn];
        if ([WeGameHelper getLogin]) {
            [self startLoadData];
        }
        else
        {
            //弹出提示框，告知用户，去登录
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录，暂时无法使用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            [alert show];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activity stopAnimating];
        [self showMSG:@"更新数据失败，请检查网络连接"];

        
        NSLog(@"请求失败:%@",error);
    }];
    
    
    
    
}

//设置时间
-(void)dateClick
{
    if (datePicker != nil) {
        [datePicker setHidden:NO];
        [dateTool setHidden:NO];
    }
    else
    {
        
        float datePHeight = 200.f;
        NSDate *curDate = [NSDate date];//获取当前日期
        datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,screenHeight - datePHeight ,screenWidth,datePHeight)];
        [datePicker setDate:curDate];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:datePicker];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        dateTool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, datePicker.frame.origin.y-44, screenWidth, 44)];
        [dateTool setTintColor:[UIColor whiteColor]];
        
        UIBarButtonItem *item0 = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain  target:self  action:@selector(finishDate)];
        [item2 setTintColor:RGBClor(53, 136, 211)];
        dateTool.items = @[item0,item2];
        [self.view addSubview:dateTool];

    }
}
-(void)dateChanged:(id)sender{
    NSDate *curdate= datePicker.date;
    selectDate = [NSString stringWithFormat:@"%ld", (long)[curdate timeIntervalSince1970]];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:curdate];
    
    [timeBtn setTitle:curTime forState:UIControlStateNormal];
    
    
    
}
-(void)finishDate
{
    [datePicker setHidden:YES];
    [dateTool setHidden:YES];
}
//获取条件设置
#pragma mark -LMComBoxViewDelegate
-(void)startChose
{
    [self.view bringSubviewToFront:bgScrollView];
    
}
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    
    [self.view exchangeSubviewAtIndex:8 withSubviewAtIndex:9];
    int tag = _combox.tag;
    switch (tag) {
        case 0:
//            selectTypeID = [[Categories objectAtIndex:index] objectForKey:@"id"];
//            NSLog(@"你选择的种类是：%@, and ID IS : %@",[[Categories objectAtIndex:index] objectForKey:@"name"],[[Categories objectAtIndex:index] objectForKey:@"id"]);
            
            
            break;
        case 1:
            selectCityID = [[Cities objectAtIndex:index] objectForKey:@"id"];
            selectCity = [[Cities objectAtIndex:index] objectForKey:@"name"];
//            NSLog(@"你选择的城市是：%@, and ID IS : %@",[[Cities objectAtIndex:index] objectForKey:@"name"],[[Cities objectAtIndex:index] objectForKey:@"id"]);
            break;
            
            
        default:
            break;
    }
}

-(void)startLoadData
{
    [dateTool setHidden: YES];

    [datePicker setHidden:YES];
    [self.view bringSubviewToFront:activity];
    [activity startAnimating];
    [cityBox closeOtherCombox];
    [infoData removeAllObjects];

    NSString *server = SERVER_STRING;
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str", selectDate,@"date",@"-200",@"productCategoryid",selectCityID,@"cityid",[WeGameHelper getString:@"UserID"],@"userid",[NSString stringWithFormat:@"%d",SortByName],@"name_sort",[NSString stringWithFormat:@"%d",SortByPrice],@"price_sort",[NSString stringWithFormat:@"%d",SortByPrice],@"price_sort", nil];

    
//    NSLog(@"采购清单请求参数：%@",parameters);
    // GET请求
    __block NSDictionary *dict = [[NSDictionary alloc] init];
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET: [PRICE_INFO stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activity stopAnimating];

        //  请求成功时的操作
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"采购清单返回内容：%@",dict);

        if ([[dict objectForKey:@"total"] intValue] == 0) {
            [self showMSG:[NSString stringWithFormat:@"%@",[dict objectForKey:@"data"]]];
            return ;
        }
     [infoData addObjectsFromArray: [dict objectForKey:@"data"]] ;
        //可左右滚动的表格
        
        if (tableView == nil) {
            tableView = [[XCMultiTableView alloc] initWithFrame:CGRectMake(5, filterView.frame.origin.y+filterView.frame.size.height, screenWidth-10, screenHeight-filterView.frame.origin.y-filterView.frame.size.height-44)];
            tableView.leftHeaderEnable = YES;
            tableView.datasource = self;
            tableView.delegate =self;
            tableView.tag    = 8976;
            tableView.isList = YES;
            [self.view addSubview:tableView];
        }
        else
        {
            [tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activity stopAnimating];
        [self showMSG:@"获取数据失败，请检查网络连接"];
        
        NSLog(@"请求失败aaaaa:%@",error);
    }];
    
    
    

}
#pragma mark - XCMultiTableViewDataSource


- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView  {
    return infoData;
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView  {
    return infoData;
}


#pragma mark - XCMultiTableViewDelegate
-(void)sortByName:(int)sort
{
//    SortByName = sort;
//    [self searchClick ];
}
-(void)sortByPrice:(int)sort
{
    PriceIndex = sort;
    [self startLoadData ];
    
}
-(void)addToList:(int)rowID delete:(BOOL)del
{
    
    NSDictionary *item  = [infoData objectAtIndex:rowID];
    NSString *server = SERVER_STRING;
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",[WeGameHelper getString:@"UserID"],@"userid",[NSString stringWithFormat:@"%@",[item objectForKey:@"productId"]],@"productid",[NSString stringWithFormat:@"%@",[item objectForKey:@"marketoid"]],@"marketoid",nil];
   
        __block NSDictionary *dict = [[NSDictionary alloc] init];
        AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

        [manager GET: [DEL_LIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"info = %@",dict);
            [infoData removeObjectAtIndex:rowID];
            [tableView reloadData];
            
            // 2.更新UITableView UI界面
            // [tableView reloadData];
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"请求失败:%@",error);
        }];
    
}
-(void)rowSelected:(int)rowID
{
    NSDictionary *item = [infoData objectAtIndex:rowID];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    [detailVC setProductInfo:[item copy]];
    [detailVC setCityName:[NSString stringWithFormat:@"%@", @"深圳"]];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        [lvc setHomeMsg:NO];
        [self.navigationController pushViewController:lvc animated:YES];
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
