//
//  PriceViewController.m
//  WeGame
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "SearchResuleViewController.h"


@interface SearchResuleViewController ()
@end

@implementation SearchResuleViewController
@synthesize homeMsg,SearchString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectCityID =  @"1";
    selectTypeID = @"1" ;
    selectCity  = @"深圳";
    page = 1;
    Total = 0;
    SortByName = 1;
    SortByPrice = 1;
    PriceIndex = 0;
    infoData = [[NSMutableArray alloc] initWithCapacity:0];

    [self UIFactory];
    
    // Do any additional setup after loading the view from its nib.
}

/*
 生成界面
 */
-(void)UIFactory
{
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //顶部导航条
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    [topBackView setBackgroundColor: RGBClor(53, 136, 211)];
    [self.view addSubview:topBackView];
    
    
    //顶部文字
    UILabel *title =[[UILabel alloc]  initWithFrame:CGRectMake((screenWidth -150)/2, 37, 150, 20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    [title setText:@"商品查询"];
    [title setFont:titleFont];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    
    //    顶部图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (homeMsg) {
        [backBtn setImage:[UIImage imageNamed:@"bank_home_ico.png" ] forState:UIControlStateNormal];
    }
    else
    {
        [backBtn setImage:[UIImage imageNamed:@"bank_ico.png" ] forState:UIControlStateNormal];
    }
    
    [backBtn setFrame:CGRectMake(10, 33, 22, 22)];
    [topBackView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    

    oneSearchBar = [[UISearchBar alloc] init];
    oneSearchBar.frame = CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth , 40); // 设置位置和大小
    oneSearchBar.keyboardType = UIKeyboardTypeEmailAddress; // 设置弹出键盘的类型
    oneSearchBar.barStyle = UIBarStyleDefault; // 设置UISearchBar的样式
    oneSearchBar.tintColor = [UIColor lightGrayColor]; // 设置UISearchBar的颜色 使用clearColor就是去掉背景
    oneSearchBar.placeholder = @"按农产品名称搜索"; // 设置提示文字
    oneSearchBar.text = SearchString; // 设置默认的文字
    oneSearchBar.delegate = self; // 设置代理
    
    oneSearchBar.showsCancelButton = NO; // 设置时候显示关闭按钮
    [self.view addSubview:oneSearchBar]; // 添加到View上
    
    
    //左边的刷新按钮
    
    
    //右边的搜索按钮
    //搜索栏
    filterView = [[UIView alloc ]initWithFrame:CGRectMake(0, oneSearchBar.frame.size.height+oneSearchBar.frame.origin.y, screenWidth, 42)];
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
    [searchBtn setTitle:@"开始查询" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:RGBClor(255, 128, 0)];
    [searchBtn setFrame:CGRectMake(screenWidth-5-68, 5+oneSearchBar.frame.size.height+oneSearchBar.frame.origin.y
                                   , 68, 30)];
    searchBtn.layer.cornerRadius = 8;
    [searchBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
    
    //顶部与内容呈现页面的间隔符
    UIView *hLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, filterView.frame.origin.y+filterView.frame.size.height, screenWidth, 1)];
    [hLine1 setBackgroundColor:RGBClor(238, 238, 238)];
    [self.view addSubview:hLine1];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 处理临时存储数据到相应格式

//获取查询条件中的类别

-(void) getCategory
{
    
    
    NSString *server = SERVER_STRING;
    
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",selectCityID,@"cityid",nil];
    
    __block NSDictionary *dict = [[NSDictionary alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // GET请求
    [manager GET: [CATEGORY_INFO stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        Categories = [dict objectForKey:@"data"];
        typeBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(cityBox.frame.origin.x+cityBox.frame.size.width+3, cityBox.frame.origin.y, 72, cityBox.frame.size.height)];
        [typeBox setBackgroundColor:[UIColor whiteColor]];
        [typeBox setArrowImgName:@"down_tri.png"];
        [typeBox setTitlesList:Categories];
        [typeBox setKey:@"name"];
        [typeBox setTag:0];
        typeBox.supView = bgScrollView;
        [typeBox setDelegate:self];
        [typeBox setHasBoard:YES];
        [typeBox defaultSettings];
        [bgScrollView addSubview:typeBox];
        [self setDate];
        [self searchClick];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activity stopAnimating];
        
        [self showMSG:@"更新数据失败，请检查网络连接"];
        
    }];
    
    
    
    
    
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
        cityBox = [[LMComBoxView alloc] initWithFrame:CGRectMake(10, 5, 52, 30)];
        //        cityBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(typeBox.frame.origin.x+typeBox.frame.size.width+3
        //                                                                , typeBox.frame.origin.y, 69, typeBox.frame.size.height)];
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
        [self getCategory];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activity stopAnimating];
        [self showMSG:@"更新数据失败，请检查网络连接"];
        
        
        NSLog(@"请求失败:%@",error);
    }];
    
    
    
    
}
-(void)setDate
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSDate *curDate = [NSDate date];//获取当前日期
    NSString * curTime = [formater stringFromDate:curDate];
    selectDate = [NSString stringWithFormat:@"%ld", (long)[curDate timeIntervalSince1970]];
    
    timeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [timeBtn setFrame:CGRectMake(typeBox.frame.origin.x+typeBox.frame.size.width+3, typeBox.frame.origin.y, 85, typeBox.frame.size.height)];
    [timeBtn setTitle:curTime forState:UIControlStateNormal];
    [timeBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [timeBtn setTitleColor:RGBClor(74, 74, 74) forState:UIControlStateNormal];
    timeBtn.layer.borderColor = [RGBClor(238, 238, 238) CGColor];
    timeBtn.layer.borderWidth = 0.5;
    [timeBtn addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bgScrollView addSubview:timeBtn];
}
-(void)updateCategory
{
    
    NSString *server = SERVER_STRING;
    
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",selectCityID,@"cityid",nil];
    
    __block NSDictionary *dict = [[NSDictionary alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // GET请求
    [manager GET: [CATEGORY_INFO stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        Categories = [dict objectForKey:@"data"];
        [typeBox removeFromSuperview];
        typeBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(cityBox.frame.origin.x+cityBox.frame.size.width+3, cityBox.frame.origin.y, 72, cityBox.frame.size.height)];
        [typeBox setBackgroundColor:[UIColor whiteColor]];
        [typeBox setArrowImgName:@"down_tri.png"];
        [typeBox setTitlesList:Categories];
        [typeBox setKey:@"name"];
        [typeBox setTag:0];
        typeBox.supView = bgScrollView;
        [typeBox setDelegate:self];
        [typeBox setHasBoard:YES];
        [typeBox defaultSettings];
        [bgScrollView addSubview:typeBox];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activity stopAnimating];
        [self showMSG:@"更新数据失败，请检查网络连接"];
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
-(void)resetScroll:(int)rows
{
    [bgScrollView setFrame:CGRectMake(0, filterView.frame.origin.y, 260, filterView.frame.size.height*rows)] ;
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
    [self resetScroll:5];
    [self.view bringSubviewToFront:bgScrollView];
}
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{

    
    [self.view exchangeSubviewAtIndex:7 withSubviewAtIndex:8];
    int tag = _combox.tag;
    switch (tag) {
        case 0:
            selectTypeID = [[Categories objectAtIndex:index] objectForKey:@"id"];
//            NSLog(@"你选择的种类是：%@, and ID IS : %@",[[Categories objectAtIndex:index] objectForKey:@"name"],[[Categories objectAtIndex:index] objectForKey:@"id"]);
            
            
            break;
        case 1:
            selectCityID = [[Cities objectAtIndex:index] objectForKey:@"id"];
            selectCity = [[Cities objectAtIndex:index] objectForKey:@"name"];
            [self updateCategory];

//            NSLog(@"你选择的城市是：%@, and ID IS : %@",[[Cities objectAtIndex:index] objectForKey:@"name"],[[Cities objectAtIndex:index] objectForKey:@"id"]);
            break;
            
            
        default:
            break;
    }
        [self resetScroll:1];
}
-(void)startSearch
{
    page=1;
    Total = 0;
    [infoData removeAllObjects];
    [oneSearchBar resignFirstResponder];
     SearchString = oneSearchBar.text;
    [self searchClick];
}

-(void)searchClick
{
    [datePicker setHidden:YES];
    [dateTool setHidden: YES];
    [activity startAnimating];
    [self.view bringSubviewToFront:activity];
    [cityBox closeOtherCombox];
    [typeBox closeOtherCombox];
    [self resetScroll:1];

    
    NSString *server = SERVER_STRING;
       NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str", SearchString,@"productname",selectTypeID,@"productCategoryid",selectCityID,@"cityid",[WeGameHelper getString:@"UserID"],@"userid",nil];
//        NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str", SearchString,@"productname",selectTypeID,@"productCategoryid",selectCityID,@"cityId",[WeGameHelper getString:@"UserID"],@"userid", nil];
//    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str", SearchString,@"productname",selectDate,@"date",selectTypeID,@"productCategoryid",selectCityID,@"cityid",[WeGameHelper getString:@"UserID"],@"userid",[NSString stringWithFormat:@"%d",SortByName],@"name_sort",[NSString stringWithFormat:@"%d",SortByPrice],@"price_sort",[NSString stringWithFormat:@"%d",PriceIndex],@"price_index",[NSString stringWithFormat:@"%d",page],@"page", nil];
    //    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str", selectDate,@"date",selectTypeID,@"productCategoryid",selectCityID,@"cityid",[WeGameHelper getString:@"UserID"],@"userid",[NSString stringWithFormat:@"%d",PriceIndex],@"price_index",[NSString stringWithFormat:@"%d",page],@"page", nil];
    
//        NSLog(@"请求数据：%@",parameters);
    
    // GET请求
    __block NSDictionary *dict = [[NSDictionary alloc] init];
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET: [FIND_PRODUCT stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //  请求成功时的操作
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        [infoData addObjectsFromArray: [dict objectForKey:@"data"]] ;
        if([infoData count] == 0)
        {
            [self showMSG:@"当前没有数据，请选择其他查询条件"];
        }
        Total += [[dict objectForKey:@"total"] intValue];
//        NSLog(@"搜索数据内容%@",dict);
        
        //可左右滚动的表格
        [activity stopAnimating];
        
        if (tableView == nil) {
            tableView = [[XCMultiTableView alloc] initWithFrame:CGRectMake(5, filterView.frame.origin.y+filterView.frame.size.height, screenWidth-10, screenHeight-filterView.frame.origin.y-filterView.frame.size.height)];
            tableView.leftHeaderEnable = YES;
            tableView.datasource = self;
            tableView.delegate =self;
            tableView.tag    = 8976;
            if ([infoData count] < Total) {
                tableView.hasMore = YES;
            }
            
            [self.view addSubview:tableView];
        }
        else
        {
            
            
            [tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activity stopAnimating];
        [self showMSG:@"更新数据失败，请检查网络连接"] ;

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
//    page=1;
//    Total = 0;
//    [infoData removeAllObjects];
//    SortByName = sort;
//    [self searchClick ];
}
-(void)sortByPrice:(int)sort
{
//    page=1;
//    Total = 0;
//    [infoData removeAllObjects];
//    PriceIndex = sort;
//    [self searchClick ];
    
}
-(void)addToList:(int)rowID delete:(BOOL)del
{
    if (![WeGameHelper getLogin]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录后使用此功能" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"登录", nil];
        [alert show];
        return;
    }
    
    NSDictionary *item  = [infoData objectAtIndex:rowID];
    NSString *server = SERVER_STRING;
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",[WeGameHelper getString:@"UserID"],@"userid",[NSString stringWithFormat:@"%@",[item objectForKey:@"productId"]],@"productid",[NSString stringWithFormat:@"%@",[item objectForKey:@"marketoid"]],@"marketoid",nil];
    
    __block NSDictionary *dict = [[NSDictionary alloc] init];
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    if (del) {
        [manager GET: [DEL_LIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"info = %@",dict);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"请求失败:%@",error);
        }];
    }
    else
    {
        [manager GET: [ADD_LIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"info = %@",dict);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"请求失败:%@",error);
        }];
        
        
    }
    
}

-(void)rowSelected:(int)rowID data:(NSDictionary *)item
{
    //    if ([infoData count] < Total) {
    //        if (rowID == [infoData count]) {
    //            page++;
    //            [self searchClick];
    //            return;
    //
    //        }
    //    }
    //
//    NSDictionary *item = [infoData objectAtIndex:rowID];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    [detailVC setProductInfo:[item copy]];
    [detailVC setCityName:[NSString stringWithFormat:@"%@", selectCity]];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
-(void)addMore
{
//    page++;
//    [self searchClick];
//    return;
}

-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchPress
{
    SearchResuleViewController *srvc = [[SearchResuleViewController alloc] init];
    [srvc setHomeMsg:NO];
    [self.navigationController pushViewController:srvc animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        [lvc setHomeMsg:NO];
        [self.navigationController pushViewController:lvc animated:YES];
    }
}

#pragma mark - 实现取消按钮的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder]; // 丢弃第一使用者
}
#pragma mark - 实现键盘上Search按钮的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    page=1;
    Total = 0;
    [infoData removeAllObjects];
    [oneSearchBar resignFirstResponder];
    SearchString = oneSearchBar.text;
    [self searchClick];

    
}
#pragma mark - 实现监听开始输入的方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    NSLog(@"开始输入搜索内容");
    return YES;
}
#pragma mark - 实现监听输入完毕的方法
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
//    NSLog(@"输入完毕");
    return YES;
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
