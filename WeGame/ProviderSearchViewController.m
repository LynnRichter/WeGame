//
//  ProviderSearchViewController.m
//  WeGame
//
//  Created by Lynnrichter on 15/2/4.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "ProviderSearchViewController.h"

@interface ProviderSearchViewController ()

@end

@implementation ProviderSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIFactory];

}
-(void)UIFactory
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    //顶部导航条
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    [topBackView setBackgroundColor: RGBClor(71, 140, 205)];
    [self.view addSubview:topBackView];
    
    //    顶部图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [backBtn setImage:[UIImage imageNamed:@"bank_ico.png" ] forState:UIControlStateNormal];
    
    [backBtn setFrame:CGRectMake(10, 33, 22, 22)];
    [topBackView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    //顶部文字
    CGFloat labelWidth =150;
    UILabel *title =[[UILabel alloc]  initWithFrame:CGRectMake((screenWidth -labelWidth)/2, 37, labelWidth, 20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    [title setText:@"供应商查询"];
    [title setFont:titleFont];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    
    
    UISearchBar *oneSearchBar = [[UISearchBar alloc] init];
    oneSearchBar.frame = CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth , 40); // 设置位置和大小
    oneSearchBar.keyboardType = UIKeyboardTypeEmailAddress; // 设置弹出键盘的类型
    oneSearchBar.barStyle = UIBarStyleDefault; // 设置UISearchBar的样式
    oneSearchBar.tintColor = [UIColor lightGrayColor]; // 设置UISearchBar的颜色 使用clearColor就是去掉背景
    oneSearchBar.placeholder = @"按供应商名称搜索"; // 设置提示文字
    oneSearchBar.text = SearchString; // 设置默认的文字
    oneSearchBar.delegate = self; // 设置代理
    
    oneSearchBar.showsCancelButton = NO; // 设置时候显示关闭按钮
    [self.view addSubview:oneSearchBar]; // 添加到View上
    
    trendY = oneSearchBar.frame.origin.y+oneSearchBar.frame.size.height;
    
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setCenter:self.view.center];
    [activity setHidesWhenStopped:YES];
    [self.view addSubview:activity];
}

-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 实现取消按钮的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder]; // 丢弃第一使用者
}
#pragma mark - 实现键盘上Search按钮的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"您点击了键盘上的Search按钮");
//    [infoData removeAllObjects];
    [searchBar resignFirstResponder]; // 丢弃第一使用者

    SearchString = searchBar.text;
    [self startSearch];
    
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

-(void)startSearch
{
//    [self showMSG:@"此功能暂未开放"];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
//        [NSThread sleepForTimeInterval:2];
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            
//        });
//        
//    });
    [self.view bringSubviewToFront:activity];
    [activity startAnimating];
    
    NSString *server = SERVER_STRING;
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",SearchString,@"providerName",nil];
    @try {
        // GET请求
        __block NSDictionary *dict = [[NSDictionary alloc] init];
        
        AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET: [PROVIDER_LIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [activity stopAnimating];
            
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            infoData = [dict objectForKey:@"data"];
            
            if([infoData count] == 0)
            {
                [self showMSG:@"当前没有数据，请选择其他查询条件"];
            }
//            NSLog(@"total = %@",[dict objectForKey:@"total"]);
            //可左右滚动的表格
            if (DataTableView == nil) {
                DataTableView = [[UITableView alloc] initWithFrame:CGRectMake(5,trendY+10,screenWidth-10,screenHeight-10-trendY)];
                DataTableView.dataSource = self;
                DataTableView.delegate =self;
                [DataTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self.view addSubview:DataTableView];
            }
            else
            {
                [DataTableView reloadData];
            }
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"请求失败:%@",error);
        }];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"发生异常问题:%@",[exception description]);
    }
    @finally {
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return 10;
    return [infoData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
//    NSLog(@"item = %@",item);
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
