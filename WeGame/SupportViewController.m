//
//  SupportViewController.m
//  WeGame
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "SupportViewController.h"

@interface SupportViewController ()

@end

@implementation SupportViewController
LMContainsLMComboxScrollView *bgScrollView;
LMComBoxView *typeBox;
LMComBoxView *cityBox;

AFHTTPRequestOperationManager *manager;

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    selectCityID =  @"1";
//    selectTypeID = @"1" ;
    selectCity  = @"深圳";
    selectType = @"";
    page = 1;
    Total =0;
    infoData = [[NSMutableArray alloc] initWithCapacity:0];
    first = true;
    [self UIFactory];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)UIFactory
{
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    //顶部导航条
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    [topBackView setBackgroundColor: RGBClor(71, 140, 205)];
    [self.view addSubview:topBackView];
    

    //    顶部图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"bank_home_ico.png" ] forState:UIControlStateNormal];
    
    [backBtn setFrame:CGRectMake(10, 33, 22, 22)];
    [topBackView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"head_search_ico.png" ] forState:UIControlStateNormal];
    [searchButton setFrame:CGRectMake(screenWidth-22-10, 33, 22, 22)];
    [searchButton addTarget:self action:@selector(searchPress) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:searchButton];
    
    //顶部文字
    UILabel *title =[[UILabel alloc]  initWithFrame:CGRectMake((screenWidth-150)/2, 24, 150, 40)];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [title setText:@"供应商大全"];
    [title setFont:titleFont];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    

    
    
    
    //顶部与底部的分隔符
    UIView *vLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth,1)];
    [vLine3 setBackgroundColor:RGBClor(32, 37, 44)];
    [self.view addSubview:vLine3];
    
    
    //左边的刷新按钮
    
    
    //右边的搜索按钮
    //搜索栏
    UIView *filterView = [[UIView alloc ]initWithFrame:CGRectMake(0, vLine3.frame.size.height+vLine3.frame.origin.y, screenWidth, 42)];
    [filterView setBackgroundColor:RGBClor(250, 250, 250)];
    [self.view addSubview:filterView];
    startY = filterView.frame.origin.y+filterView.frame.size.height;
    
    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, filterView.frame.origin.y, 260, filterView.frame.size.height*100)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.tag = 8975;
    [self.view addSubview:bgScrollView];
    
    //    NSMutableArray *dates = [self getDate];
    
    
    //    创建LMComBoxView对象：
    
    typeBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(10, 5, 160, 30)];
    [typeBox setBackgroundColor:[UIColor whiteColor]];
    [typeBox setArrowImgName:@"down_tri.png"];    
    
    
    
    //    timeBox = [[LMComBoxView alloc ]initWithFrame:CGRectMake(typeBox.frame.origin.x+typeBox.frame.size.width+3, typeBox.frame.origin.y, 85, typeBox.frame.size.height)];
    //    [timeBox setBackgroundColor:typeBox.backgroundColor];
    //    [timeBox setTitlesList:dates];
    //    [timeBox setTag:1];
    //    [timeBox setArrowImgName:@"down_tri.png"];
    //    timeBox.supView = bgScrollView;
    //    [timeBox setDelegate:self];
    //    [timeBox setHasBoard:YES];
    //    [timeBox defaultSettings];
    //
    
    //查询按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchBtn setTitle:@"查看" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:RGBClor(255, 128, 0)];
    [searchBtn setFrame:CGRectMake(screenWidth-5-68, 5+vLine3.frame.size.height+vLine3.frame.origin.y
                                   , 68, 30)];
    searchBtn.layer.cornerRadius = 8;
    [searchBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    


    
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setCenter:self.view.center];
    [activity setHidesWhenStopped:YES];
    [self.view addSubview:activity];
    [activity startAnimating];
    [self getCity];

    
    
}

//获取查询条件中的类别

-(void) getCategory
{
    
    
    NSString *server = SERVER_STRING;
    
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",selectCityID,@"cityid",nil];
    
    __block NSDictionary *dict = [[NSDictionary alloc] init];
    

    // GET请求
    [manager GET: [CATEGORY_INFO stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        Categories = [dict objectForKey:@"data"];
        typeBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(cityBox.frame.origin.x+cityBox.frame.size.width+3, cityBox.frame.origin.y, 100, cityBox.frame.size.height)];
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

    // GET请求
    [manager GET: [CITY_INFO stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activity stopAnimating];
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        Cities = [dict objectForKey:@"data"];
        cityBox = [[LMComBoxView alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
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

-(void)updateCategory
{
    
    NSString *server = SERVER_STRING;
    
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",selectCityID,@"cityid",nil];
    
    __block NSDictionary *dict = [[NSDictionary alloc] init];
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
//获取条件设置
#pragma mark -LMComBoxViewDelegate
-(void)startChose
{
    [self.view bringSubviewToFront:bgScrollView];
    
}
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    
//    int i=0;
//    for (UIView *view in self.view.subviews ) {
//        if ([view isKindOfClass:[LMContainsLMComboxScrollView class]]) {
//            NSLog(@"找到了%d",i);
////            break;
//        }
//        if ([view isKindOfClass:[UITableView class]]) {
//            NSLog(@"找到了textview %d",i);
////            break;
//        }
//
//        
//        i++;
//    }
    [self.view exchangeSubviewAtIndex:8 withSubviewAtIndex:6];
//    [self.view bringSubviewToFront:dataTable];
    int tag = _combox.tag;
    switch (tag) {
        case 0:
            selectTypeID = [[Categories objectAtIndex:index] objectForKey:@"id"];
            selectType = [[Categories objectAtIndex:index] objectForKey:@"name"];;
            NSLog(@"你选择的种类是：%@, and ID IS : %@",[[Categories objectAtIndex:index] objectForKey:@"name"],[[Categories objectAtIndex:index] objectForKey:@"id"]);
            
            
            break;
        case 1:
            selectCityID = [[Cities objectAtIndex:index] objectForKey:@"id"];
            selectCity = [[Cities objectAtIndex:index] objectForKey:@"shortName"];
            [self updateCategory];
            NSLog(@"你选择的城市是：%@, and ID IS : %@",[[Cities objectAtIndex:index] objectForKey:@"name"],[[Cities objectAtIndex:index] objectForKey:@"id"]);
            break;
            
            
        default:
            break;
    }
}
-(void)startClick
{
    page=1;
    Total = 0;
    [infoData removeAllObjects];
    [self searchClick];
}
-(void)searchClick
{
    [activity startAnimating];
    [cityBox closeOtherCombox];
    [typeBox closeOtherCombox];
    
    NSString *server = SERVER_STRING;
    
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str", selectCityID,@"cityId", selectTypeID,@"categoryId",nil];
    __block NSDictionary * dict = [[NSDictionary alloc] init];
    NSLog(@"供应商接口访问数据：%@",parameters);
    [manager GET: [PROVIDER_LIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //  请求成功时的操作
        [activity stopAnimating];
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"data"]]  isEqualToString:@""]) {
            [self showMSG:@"返回数据为空，请稍后重试"];
            return;
        }
        
        
        [infoData addObjectsFromArray: [dict objectForKey:@"data"]] ;
        Total += [[dict objectForKey:@"total"] intValue];
//        NSLog(@"all data:%@",infoData);
       if (first) {
           UIView *view = [[UIView alloc ] initWithFrame:CGRectMake(0, startY, screenWidth, 35)];
           [view setBackgroundColor:RGBClor(228, 228, 228)];
           [self.view addSubview:view];
           
           descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 170, 30)];
           [descLabel setBackgroundColor:[UIColor clearColor]];
           [descLabel setText:[NSString stringWithFormat:@"%@%@供应商有",selectCity,selectType]];
           [descLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
           
           [view addSubview:descLabel];
           
           sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(descLabel.frame.origin.x+descLabel.frame.size.width, descLabel.frame.origin.y,14, descLabel.frame.size.height)];
           [sumLabel setText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"total"]]];
           [sumLabel setTextColor:RGBClor(255, 102, 0)];
           [sumLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
           [sumLabel setAdjustsFontSizeToFitWidth:YES];
           [sumLabel setMinimumScaleFactor:0.5f];
           [sumLabel setTextAlignment:NSTextAlignmentCenter];
           [view addSubview: sumLabel];
           
           unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(sumLabel.frame.origin.x+sumLabel.frame.size.width, sumLabel.frame.origin.y, 30, sumLabel.frame.size.height)];
           
           [unitLabel setText:@"家"];
           [unitLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
           [view addSubview:unitLabel];
           
           first = NO;
           startY = view.frame.origin.y+view.frame.size.height;
           
           
       }
       else {
           [descLabel setText:[NSString stringWithFormat:@"%@%@供应商有",selectCity,selectType]];
           [sumLabel setText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"total"]]];


       }
       
       if (dataTable == nil) {
           //初始化表格，给数据

           dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, startY+2, screenWidth, screenHeight-startY-44) style:UITableViewStylePlain];
           [dataTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
           [dataTable setDataSource:self];
           [dataTable setDelegate:self];
           [self.view addSubview:dataTable];
           [self.view bringSubviewToFront:activity];

           
       }
       else
       {
           
           [dataTable reloadData];
       }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activity stopAnimating];
        [self showMSG:@"更新数据失败，请检查网络连接"];
        NSLog(@"请求失败:%@",error);
    }];

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 10;
    if ([infoData count] < Total) {
       return [infoData count]+1;
    }
    else{
        return [infoData count];
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 140.f;
    
    if ([infoData count] < Total) {
        if (indexPath.row<[infoData count]) {
            return 140.f;
        }else
        {
            return 40.f;
        }
    }else{
        return 140.f;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([infoData count] < Total) {
        if (indexPath.row == [infoData count]) {
            static NSString  *contentid = @"addmore";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentid];
            cell.tag = indexPath.row;
            if(!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:contentid];
                UILabel *morelabel =  [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-100)/2, 0, 100,cell.contentView.frame.size.height )];
                morelabel.text = @"点击加载更多";
                [morelabel setTextColor:RGBClor(74, 74, 74)];
                            [morelabel setBackgroundColor:[UIColor redColor]];
                [morelabel setTextAlignment:NSTextAlignmentCenter];
                [morelabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                [cell addSubview:morelabel];
                
            }
            return cell;            
        }
    }

    static NSString *cellId = @"PROVIDER_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.tag = indexPath.row;
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    NSDictionary *item = [infoData objectAtIndex:indexPath.row];
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    [cell.contentView addSubview:imageView];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.chinaap.com/data/provider/%@",[item objectForKey:@"imageurl"]]] placeholderImage:[UIImage imageNamed:@"demo.png"]];
    
//    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[item objectForKey:@"imageurl"]]] placeholderImage:[UIImage imageNamed:@"demo.png"]];
    
    UILabel *nameLabel = [[UILabel alloc ] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+3, 5, screenWidth-imageView.frame.size.width-20, 18)];
    
//    [nameLabel setText:@"深圳市宏鸿农产品有限公司"];
    [nameLabel setText:[NSString stringWithFormat:@"%@",[item objectForKey:@"providerName"]]];
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [nameLabel setMinimumScaleFactor:0.5];
    [cell.contentView addSubview:nameLabel];
    
    
    UILabel *providerLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+8, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    [providerLabel setTextColor:RGBClor(74, 74, 74)];
    [providerLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//    [providerLabel setText:@"主营产品：蔬菜、水果、鲜肉"];
    [providerLabel setText:[NSString stringWithFormat:@"主营产品：%@",[item objectForKey:@"mainProduct"]]];
    [cell.contentView addSubview:providerLabel];
    
    
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, providerLabel.frame.origin.y+providerLabel.frame.size.height+5, nameLabel.frame.size.width, nameLabel.frame.size.height)];

    [contactLabel setTextColor:RGBClor(74, 74, 74)];
    [contactLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//    [contactLabel setText:@"联系人：张三丰"];
    [contactLabel setText:[NSString stringWithFormat:@"联系人：%@",[item objectForKey:@"contact"]]];
    [cell.contentView addSubview:contactLabel];

    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, contactLabel.frame.origin.y+contactLabel.frame.size.height+5, 60, nameLabel.frame.size.height)];
    
    [numberLabel setTextColor:RGBClor(74, 74, 74)];
//    [numberLabel setBackgroundColor:[UIColor redColor]];
    [numberLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [numberLabel setText:@"联系电话："];
    [cell.contentView addSubview:numberLabel];
    
    UIButton *contactNumber = [[UIButton alloc] initWithFrame:CGRectMake(numberLabel.frame.origin.x+numberLabel.frame.size.width, numberLabel.frame.origin.y, 90, nameLabel.frame.size.height)];
    [contactNumber setTitle:[NSString stringWithFormat:@"%@",[item objectForKey:@"contactNumber"]] forState:UIControlStateNormal];
    //    [contactNumber setText:[NSString stringWithFormat:@"%@",[item objectForKey@"contactNumber"]]];
    [contactNumber setTitleColor:RGBClor(255, 102, 0) forState:UIControlStateNormal];
    [contactNumber.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [contactNumber.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
//    [contactNumber setBackgroundColor:[UIColor redColor]];
    [contactNumber addTarget:self action:@selector(callNumber:)  forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:contactNumber];

    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, numberLabel.frame.origin.y+numberLabel.frame.size.height, screenWidth-imageView.frame.size.width-20, nameLabel.frame.size.height*2)];
    [address setNumberOfLines:2];
    [address setLineBreakMode:NSLineBreakByWordWrapping];
    [address setTextColor:RGBClor(74, 74, 74)];
    [address setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//    [address setText:@"深圳平湖街道办良安田社区榄树下工业区149号"];
    [address setText:[NSString stringWithFormat:@"%@",[item objectForKey:@"companyAddress"]]];

    [cell.contentView addSubview:address];
    
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(5, 139, screenWidth-5, 1)];
    [hLine setBackgroundColor:RGBClor(238, 238, 238)];
    [cell.contentView addSubview:hLine];
    
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([infoData count] < Total) {
        if (indexPath.row == [infoData count]) {
            page++;
            [self searchClick];
            return;
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProviderViewController *pvc = [[ProviderViewController alloc] init];
    [pvc setItem:[infoData objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void)callNumber:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",btn.titleLabel.text]]];//打电话
}
-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchPress
{
    ProviderSearchViewController *psvc = [[ProviderSearchViewController alloc] init];
    [self.navigationController pushViewController:psvc animated:YES];
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
