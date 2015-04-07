//
//  DetailViewController.m
//  WeGame
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize cityName,ProductInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    server = SERVER_STRING;
    trendY = 0;
    
    [self UIFactory];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)UIFactory
{
//    NSLog(@"%@",ProductInfo);
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    cellHeight = 32;
    float labWidth = 60;
    UIFont *contentFont = [UIFont fontWithName:@"Helvetica" size:14];
    UIColor *contentColor = RGBClor(95, 95, 95);
    float btnwidth = 62;
    
    //顶部导航条
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    [topBackView setBackgroundColor: RGBClor(53, 136, 211)];
    [self.view addSubview:topBackView];
    
    
    //顶部文字
    UILabel *title =[[UILabel alloc]  initWithFrame:CGRectMake(50, 22, 200, 44)];
    [title setTextAlignment:NSTextAlignmentCenter];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica" size:18];
    [title setText:[NSString stringWithFormat:@"%@%@价格",cityName,[ProductInfo objectForKey:@"productName"]]];
    [title setFont:titleFont];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    
    //    顶部图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"bank_ico.png" ] forState:UIControlStateNormal];
    
    [backBtn setFrame:CGRectMake(5, 33, 22 , 22)];
    [topBackView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //顶部与底部的分隔符
    UIView *vLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, topBackView.frame.origin.y+topBackView.frame.size.height, screenWidth,1)];
    [vLine3 setBackgroundColor:RGBClor(32, 37, 44)];
    [self.view addSubview:vLine3];
    
    
    parentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, vLine3.frame.origin.y+vLine3.frame.size.height, screenWidth, screenHeight-vLine3.frame.origin.y+vLine3.frame.size.height)];
    parentView.showsHorizontalScrollIndicator = NO;
    parentView.showsVerticalScrollIndicator = NO;
    [parentView setContentSize:CGSizeMake(screenWidth, screenHeight*2)];
    [parentView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:parentView];
    
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setCenter:self.view.center];
    [activity setHidesWhenStopped:YES];
    [self.view addSubview:activity];

    
//    基础详情
    
//    品名
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, cellHeight)];
    [parentView addSubview:nameView];
    
    UILabel *nameLb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, labWidth, cellHeight-2*5)];
    [nameLb setFont:contentFont];
    [nameLb setTextColor:contentColor];
    [nameLb setText:@"品   名:"];
    [nameView addSubview:nameLb];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(nameLb.frame.size.width+nameLb.frame.origin.x+5, 5, screenWidth-nameLb.frame.size.width+nameLb.frame.origin.x-10-btnwidth-10-5, cellHeight-2*5)];
    [name setFont:contentFont];
    [name setTextColor:contentColor];
    [name setText:[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"productName"]]];
//    [name setBackgroundColor:[UIColor redColor]];
    [nameView addSubview:name];
    
    if ([[ProductInfo objectForKey:@"isInUserPurchaseList"] integerValue] == 0)
    {
        isInsert = YES;
        
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAdd setFrame:CGRectMake(name.frame.origin.x
                                    +name.frame.size.width+5, 5, btnwidth, cellHeight-2*5)];
        [btnAdd setBackgroundColor:RGBClor(255, 102, 0)];
        btnAdd.layer.cornerRadius = 6;
        [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAdd setTitle:@"加入清单" forState:UIControlStateNormal];
        [btnAdd.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [btnAdd addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [nameView addSubview:btnAdd];
    }
    else
    {
        isInsert = NO;
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAdd setFrame:CGRectMake(name.frame.origin.x
                                    +name.frame.size.width+5, 5, btnwidth, cellHeight-2*5)];
        [btnAdd setBackgroundColor:RGBClor(239,239,239)];
        
        btnAdd.layer.cornerRadius = 6;
        btnAdd.layer.borderWidth = 1;
        btnAdd.layer.borderColor = [RGBClor(228, 228, 228) CGColor];
        [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAdd setTitle:@"移除清单" forState:UIControlStateNormal];
        [btnAdd.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [btnAdd setTitleColor:RGBClor(95, 95, 95) forState:UIControlStateNormal];
        [btnAdd addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        [nameView addSubview:btnAdd];
    }
//    别名
    UIView *aliasView = [[UIView alloc] initWithFrame:CGRectMake(0, nameView.frame.origin.y+nameView.frame.size.height, screenWidth, cellHeight)];
    [aliasView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:aliasView];
    
    UILabel *aliasLb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, labWidth, cellHeight-2*5)];
    [aliasLb setFont:contentFont];
    [aliasLb setTextColor:contentColor];
    [aliasLb setText:@"别   名:"];
    [aliasView addSubview:aliasLb];
    
    UILabel *alias = [[UILabel alloc] initWithFrame:CGRectMake(aliasLb.frame.size.width+aliasLb.frame.origin.x+5, 5, screenWidth-aliasLb.frame.size.width+aliasLb.frame.origin.x-10, cellHeight-2*5)];
    [alias setFont:contentFont];
    [alias setTextColor:contentColor];
    [alias setText:[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"alias"]]];
//        [alias setBackgroundColor:[UIColor redColor]];
    [aliasView addSubview:alias];

    
//    规格
    UIView *specView = [[UIView alloc] initWithFrame:CGRectMake(0, aliasView.frame.origin.y+aliasView.frame.size.height, screenWidth, cellHeight)];
//    [aliasView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:specView];
    
    UILabel *specLb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, labWidth, cellHeight-2*5)];
    [specLb setFont:contentFont];
    [specLb setTextColor:contentColor];
    [specLb setText:@"规   格:"];
    [specView addSubview:specLb];
    
    UILabel *spec = [[UILabel alloc] initWithFrame:CGRectMake(specLb.frame.size.width+specLb.frame.origin.x+5, 5, screenWidth-specLb.frame.size.width+specLb.frame.origin.x-10, cellHeight-2*5)];
    [spec setFont:contentFont];
    [spec setTextColor:contentColor];
    [spec setText:[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"spec"]]];
    //        [alias setBackgroundColor:[UIColor redColor]];
    [specView addSubview:spec];
    
//    批发价
    UIView *rpriceView = [[UIView alloc] initWithFrame:CGRectMake(0, specView.frame.origin.y+specView.frame.size.height, screenWidth, cellHeight)];
    [rpriceView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:rpriceView];
    
    UILabel *rpriceLb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, labWidth, cellHeight-2*5)];
    [rpriceLb setFont:contentFont];
    [rpriceLb setTextColor:contentColor];
    [rpriceLb setText:@"批发价:"];
    [rpriceView addSubview:rpriceLb];
    
    UILabel *rprice = [[UILabel alloc] initWithFrame:CGRectMake(rpriceLb.frame.size.width+rpriceLb.frame.origin.x+5, 5, screenWidth-rpriceLb.frame.size.width+rpriceLb.frame.origin.x-10, cellHeight-2*5)];
    [rprice setFont:contentFont];
    [rprice setTextColor:[UIColor redColor]];
    [rprice setText:[NSString stringWithFormat:@"%@元/%@",[ProductInfo objectForKey:@"rprice"],[ProductInfo objectForKey:@"unit"]]];
    [rpriceView addSubview:rprice];
    
//    价格指数
    UIView *priceIndexView = [[UIView alloc] initWithFrame:CGRectMake(0, rpriceView.frame.origin.y+rpriceView.frame.size.height, screenWidth, cellHeight)];
//    [priceIndexView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:priceIndexView];
    
    UILabel *priceIndexLb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, labWidth, cellHeight-2*5)];
    [priceIndexLb setFont:contentFont];
    [priceIndexLb setTextColor:contentColor];
    [priceIndexLb setText:@"价格指数:"];
    [priceIndexView addSubview:priceIndexLb];
    
    UILabel *priceIndex = [[UILabel alloc] initWithFrame:CGRectMake(priceIndexLb.frame.size.width+priceIndexLb.frame.origin.x+5, 5, screenWidth-priceIndexLb.frame.size.width+priceIndexLb.frame.origin.x-10, cellHeight-2*5)];
    [priceIndex setFont:contentFont];
    [priceIndex setTextColor:[UIColor redColor]];
//    [priceIndex setText:[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"priceIndex"]]];
    if([NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"priceIndex"]] == nil ||[[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"priceIndex"]] isEqualToString:@"<null>"] )
    {
        [priceIndex setText:@"0"];
    }else
    {
        [priceIndex setText:[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"priceIndex"]]];
    }
    [priceIndexView addSubview:priceIndex];
//    价格来源
    UIView *marketShortView = [[UIView alloc] initWithFrame:CGRectMake(0, priceIndexView.frame.origin.y+priceIndexView.frame.size.height, screenWidth, cellHeight)];
    [marketShortView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:marketShortView];
    
    UILabel *marketShortLb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, labWidth, cellHeight-2*5)];
    [marketShortLb setFont:contentFont];
    [marketShortLb setTextColor:contentColor];
    [marketShortLb setText:@"价格来源:"];
    [marketShortView addSubview:marketShortLb];
    
    UILabel *marketShort = [[UILabel alloc] initWithFrame:CGRectMake(marketShortLb.frame.size.width+marketShortLb.frame.origin.x+5, 5, screenWidth-marketShortLb.frame.size.width+marketShortLb.frame.origin.x-10, cellHeight-2*5)];
    [marketShort setFont:contentFont];
    [marketShort setTextColor:contentColor];
    [marketShort setText:[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"marketShort"]]];
    [marketShortView addSubview:marketShort];
//    报价日期
    UIView *releaseDateView = [[UIView alloc] initWithFrame:CGRectMake(0, marketShortView.frame.origin.y+marketShortView.frame.size.height, screenWidth, cellHeight)];
//    [marketShortView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:releaseDateView];
    
    UILabel *releaseDateLb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, labWidth, cellHeight-2*5)];
    [releaseDateLb setFont:contentFont];
    [releaseDateLb setTextColor:contentColor];
    [releaseDateLb setText:@"报价日期:"];
    [releaseDateView addSubview:releaseDateLb];
    
    UILabel *releaseDate = [[UILabel alloc] initWithFrame:CGRectMake(releaseDateLb.frame.size.width+releaseDateLb.frame.origin.x+5, 5, screenWidth-releaseDateLb.frame.size.width+releaseDateLb.frame.origin.x-10, cellHeight-2*5)];
    [releaseDate setFont:contentFont];
    [releaseDate setTextColor:contentColor];
//    double timestamp =[[ProductInfo objectForKey:@"releaseDate"] doubleValue];
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(timestamp/1000)];
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    releaseDate.text = [NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"releaseDate"] ];
    [releaseDateView addSubview:releaseDate];
    
    
    
//    各地批发价格
    UIView *priceAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, releaseDateView.frame.origin.y+releaseDateView.frame.size.height, screenWidth, cellHeight)];
    [priceAreaView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:priceAreaView];
    
    UILabel *priceArealb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, screenWidth, cellHeight-2*5)];
    [priceArealb setFont:contentFont];
    [priceArealb setTextColor:[UIColor blackColor]];
    [priceArealb setText:[NSString stringWithFormat:@"各地%@批发价格",[ProductInfo objectForKey:@"productName"]]];
    [priceAreaView addSubview:priceArealb];
    
    UIView *hLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-2, priceArealb.frame.size.width, 2)];
    [hLine2 setBackgroundColor:RGBClor(71, 141, 205)];
    [priceAreaView addSubview:hLine2];
    
    //各地批发价格表头

    
    
    UIView *priceAreaHeaderView = [[UIView alloc] initWithFrame:CGRectMake(5, priceAreaView.frame.origin.y+priceAreaView.frame.size.height+5, screenWidth-10, cellHeight)];
    [priceAreaHeaderView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:priceAreaHeaderView];
    
    UILabel *cityHead = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, cellHeight)];
    [cityHead setText:@"城市"];
    [cityHead setTextColor:[UIColor blackColor]];
    [cityHead setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [priceAreaHeaderView addSubview:cityHead];
    
    UILabel *priceHead = [[UILabel alloc] initWithFrame:CGRectMake(cityHead.frame.origin.x+cityHead.frame.size.width, cityHead.frame.origin.y, 50, cellHeight)];
    [priceHead setText:@"批发价"];
    [priceHead setTextColor:[UIColor blackColor]];
    [priceHead setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [priceAreaHeaderView addSubview:priceHead];

    float dateHeaderWidth = 80.f;
    UILabel *dateHeader = [[UILabel alloc] initWithFrame:CGRectMake(priceAreaHeaderView.frame.size.width -dateHeaderWidth-10, cityHead.frame.origin.y, dateHeaderWidth, cellHeight)];
    [dateHeader setText:@"报价日期"];
    [dateHeader setTextAlignment:NSTextAlignmentRight];
    [dateHeader setTextColor:[UIColor blackColor]];
    [dateHeader setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [priceAreaHeaderView addSubview:dateHeader];
    
    UILabel *sourceHeader = [[UILabel alloc] initWithFrame:CGRectMake(priceHead.frame.origin.x+priceHead.frame.size.width, cityHead.frame.origin.y, screenWidth-cityHead.frame.size.width-priceHead.frame.size.width-dateHeaderWidth, cellHeight)];
    
    [sourceHeader setText:@"报价来源"];
    [sourceHeader setTextAlignment:NSTextAlignmentCenter];
    [sourceHeader setTextColor:[UIColor blackColor]];
    [sourceHeader setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [priceAreaHeaderView addSubview:sourceHeader];
    
    [activity startAnimating];
    //启动线程，拉取各地价格数据
    NSDate *curDate = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%.0f",[curDate timeIntervalSince1970]];
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"productId"]],@"productoid",[WeGameHelper getString:@"UserID"],@"userid",time,@"date",nil];
    __block NSDictionary * dict = [[NSDictionary alloc] init];
//    NSLog(@"各地批发价格请求参数：%@",parameters);
    
    [manager GET: [PRICE_AREA stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //  请求成功时的操作
        [activity stopAnimating];
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"各地批发价格获取数据：%@",dict);
       NSMutableArray *cityData = [dict objectForKey:@"data"];
       int i = 0;
       for (NSDictionary * item in cityData) {
           UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(5, i*cellHeight+5+priceAreaHeaderView.frame.origin.y+priceAreaHeaderView.frame.size.height, screenWidth-20, cellHeight)];
           if (i%2 == 1) {
               [tview setBackgroundColor:RGBClor(245, 245, 245)];
           }
           UILabel *tlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, cellHeight)];
           [tlabel1 setText:[NSString stringWithFormat:@"%@",[item valueForKey:@"city"]]];
           [tlabel1 setTextColor:RGBClor(74, 74, 74)];
           [tlabel1 setFont:contentFont];
           [tview addSubview:tlabel1];
           
           
            UILabel *tlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(tlabel1.frame.origin.x+tlabel1.frame.size.width, tlabel1.frame.origin.y, 50, cellHeight)];
           [tlabel2 setText:[NSString stringWithFormat:@"¥%@",[item valueForKey:@"releasePrice"]]];
           [tlabel2 setTextColor:RGBClor(74, 74, 74)];
           [tlabel2 setFont:contentFont];
           [tview addSubview:tlabel2];
           
           UILabel *tlabel4 = [[UILabel alloc] initWithFrame:CGRectMake(tview.frame.size.width -dateHeaderWidth-5, tlabel1.frame.origin.y, dateHeaderWidth, cellHeight)];
//           double timestamp =[[item valueForKey:@"releaseDate"] doubleValue];
//           NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(timestamp/1000)];
//           NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//           [formatter setDateStyle:NSDateFormatterMediumStyle];
//           [formatter setDateFormat:@"yyyy-MM-dd"];
//           
//           tlabel4.text = [formatter stringFromDate:confromTimesp];
           [tlabel4 setText:[NSString stringWithFormat:@"%@",[item valueForKey:@"releaseDate"]]];
           [tlabel4 setTextColor:RGBClor(74, 74, 74)];
           [tlabel4 setFont:contentFont];
           [tlabel4 setTextAlignment:NSTextAlignmentRight];
           [tview addSubview:tlabel4];
           
           UILabel *tlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(tlabel2.frame.origin.x+tlabel2.frame.size.width, tlabel1.frame.origin.y, screenWidth-tlabel2.frame.size.width-tlabel1.frame.size.width-dateHeaderWidth-5, cellHeight)];
           [tlabel3 setText:[NSString stringWithFormat:@"%@",[item valueForKey:@"market"]]];
           [tlabel3 setTextAlignment:NSTextAlignmentCenter];
           [tlabel3 setTextColor:RGBClor(74, 74, 74)];
           [tlabel3 setFont:contentFont];
           [tview addSubview:tlabel3];
           
           i++;
           [parentView addSubview:tview];
           
           
       }
       trendY = cellHeight*[cityData count]+priceAreaHeaderView.frame.origin.y+priceAreaHeaderView.frame.size.height;
       //    价格走势
       UIView *trednHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, trendY+5, screenWidth, cellHeight)];
       [trednHeadView setBackgroundColor:RGBClor(245, 245, 245)];
       [parentView addSubview:trednHeadView];
       
       UILabel *trednHeadlb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, screenWidth, cellHeight-2*5)];
       [trednHeadlb setFont:contentFont];
       [trednHeadlb setTextColor:[UIColor blackColor]];
       [trednHeadlb setText:[NSString stringWithFormat:@"%@%@价格走势",cityName,[ProductInfo objectForKey:@"productName"]]];
       [trednHeadView addSubview:trednHeadlb];
       
       UIView *hLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-2, trednHeadlb.frame.size.width, 2)];
       [hLine3 setBackgroundColor:RGBClor(71, 141, 205)];
       [trednHeadView addSubview:hLine3];
       
       trendY = trednHeadView.frame.origin.y+trednHeadView.frame.size.height+10;
        
        [parentView setContentSize:CGSizeMake(screenWidth, screenHeight)];
        
                           //加入折线图
           [self startLoadChartData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [activity stopAnimating];
            [self showMSG:@"获取数据失败,请检查网络连接"];

            NSLog(@"请求失败:%@",error);
        }];
        




//    往年价格
//    供应商
    

}
-(void)startLoadChartData
{
    [activity startAnimating];
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"productId"]],@"productid",[WeGameHelper getString:@"UserID"],@"userid",[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"cityid"]],@"cityid",nil];
    __block NSDictionary * dict = [[NSDictionary alloc] init];
    [manager GET: [PRICE_HISTORY stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //  请求成功时的操作
        [activity stopAnimating];
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        lineData = [dict objectForKey:@"data"];
        chartView = [[FYChartView alloc] initWithFrame:CGRectMake(10, trendY, screenWidth-20, 125)];
        
        chartView.backgroundColor = [UIColor clearColor];
        chartView.rectangleLineColor = [UIColor lightGrayColor];
        chartView.lineColor = RGBClor(240, 0, 240);
        chartView.dataSource = self;
        
        [parentView addSubview:chartView];
        trendY =chartView.frame.origin.y+chartView.frame.size.height;
        
        [parentView setContentSize:CGSizeMake(screenWidth, chartView.frame.origin.y+chartView.frame.size.height+10)];
        [self priceHistory];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activity stopAnimating];
        [self showMSG:@"获取数据失败,请检查网络连接"];
        NSLog(@"请求失败:%@",error);
    }];

}

-(void)priceHistory
{

    UIView *historyAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, trendY+10, screenWidth, cellHeight)];
    [historyAreaView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:historyAreaView];
    
    UILabel *histroyArealb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, screenWidth, cellHeight-2*5)];
    [histroyArealb setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [histroyArealb setTextColor:[UIColor blackColor]];
    [histroyArealb setText:[NSString stringWithFormat:@"%@%@往年价格",cityName,[ProductInfo objectForKey:@"productName"]]];
    [historyAreaView addSubview:histroyArealb];
    
    UIView *hLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-2, histroyArealb.frame.size.width, 2)];
    [hLine3 setBackgroundColor:RGBClor(71, 141, 205)];
    [historyAreaView addSubview:hLine3];
    
    UIView *priceAreaHeaderView = [[UIView alloc] initWithFrame:CGRectMake(5, historyAreaView.frame.origin.y+historyAreaView.frame.size.height+5, screenWidth-10, cellHeight)];
    [priceAreaHeaderView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:priceAreaHeaderView];
    

    
    UILabel *priceHead = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 120, cellHeight)];
    [priceHead setText:@"日期"];
    [priceHead setTextColor:[UIColor blackColor]];
    [priceHead setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [priceAreaHeaderView addSubview:priceHead];
    

   
    
    UILabel *sourceHeader = [[UILabel alloc] initWithFrame:CGRectMake(priceHead.frame.origin.x+priceHead.frame.size.width, priceHead.frame.origin.y, 50, cellHeight)];
    
    [sourceHeader setText:@"批发价"];
    [sourceHeader setTextAlignment:NSTextAlignmentCenter];
    [sourceHeader setTextColor:[UIColor blackColor]];
    [sourceHeader setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [priceAreaHeaderView addSubview:sourceHeader];
    
    UILabel *dateHeader = [[UILabel alloc] initWithFrame:CGRectMake(sourceHeader.frame.origin.x
                                                                    +sourceHeader.frame.size.width, priceHead.frame.origin.y, screenWidth-sourceHeader.frame.size.width-priceHead.frame.size.width-20, cellHeight)];
    [dateHeader setText:@"价格来源"];
    [dateHeader setTextAlignment:NSTextAlignmentRight];
    [dateHeader setTextColor:[UIColor blackColor]];
    [dateHeader setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [priceAreaHeaderView addSubview:dateHeader];
    
    
    int i= 0;
    for (NSDictionary *item in lineData ) {
        UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(5, i*cellHeight+5+priceAreaHeaderView.frame.origin.y+priceAreaHeaderView.frame.size.height, screenWidth-20, cellHeight)];
        if (i%2 == 1) {
            [tview setBackgroundColor:RGBClor(245, 245, 245)];
        }
        else
        {
            
        }
        UILabel *tlabel1 = [[UILabel alloc] initWithFrame:priceHead.frame];
        [tlabel1 setText:[NSString stringWithFormat:@"%@",[item valueForKey:@"gatherDateStr"]]];
        [tlabel1 setTextColor:RGBClor(74, 74, 74)];
        [tlabel1 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [tview addSubview:tlabel1];
        
        
        UILabel *tlabel2 = [[UILabel alloc] initWithFrame:sourceHeader.frame];
        [tlabel2 setText:[NSString stringWithFormat:@"¥%@",[item valueForKey:@"rprice"]]];
        [tlabel2 setTextColor:RGBClor(74, 74, 74)];
        [tlabel2 setTextAlignment:NSTextAlignmentCenter];
        [tlabel2 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [tview addSubview:tlabel2];
        
        

        
        UILabel *tlabel3 = [[UILabel alloc] initWithFrame:dateHeader.frame];
        [tlabel3 setText:[NSString stringWithFormat:@"%@",[item valueForKey:@"marketShort"]]];
        [tlabel3 setTextAlignment:NSTextAlignmentRight];
        [tlabel3 setTextColor:RGBClor(74, 74, 74)];
        [tlabel3 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [tview addSubview:tlabel3];
        
        i++;
        [parentView addSubview:tview];
        
        
    }
    trendY = cellHeight*[lineData count]+priceAreaHeaderView.frame.origin.y+priceAreaHeaderView.frame.size.height+10;

    [parentView setContentSize:CGSizeMake(screenWidth, trendY+10)];
    [self supportInfo];

    
}

-(void)supportInfo
{
    UIView *priceAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, trendY, screenWidth, cellHeight)];
    [priceAreaView setBackgroundColor:RGBClor(245, 245, 245)];
    [parentView addSubview:priceAreaView];
    
    UILabel *priceArealb = [[UILabel alloc ] initWithFrame:CGRectMake(5, 5, screenWidth, cellHeight-2*5)];
    [priceArealb setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [priceArealb setTextColor:[UIColor blackColor]];
    [priceArealb setText:[NSString stringWithFormat:@"%@%@供应商推荐",cityName,[ProductInfo objectForKey:@"productName"]]];
    [priceAreaView addSubview:priceArealb];
    
    UIView *hLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-2, priceArealb.frame.size.width, 2)];
    [hLine2 setBackgroundColor:RGBClor(71, 141, 205)];
    [priceAreaView addSubview:hLine2];
    
    trendY =priceAreaView.frame.origin.y+priceAreaView.frame.size.height+10;
    
    [activity startAnimating];
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"categoryoid"]],@"categoryId",nil];
    __block NSDictionary * dict = [[NSDictionary alloc] init];

    [manager GET: [PID2PROVIDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activity stopAnimating];
        //  请求成功时的操作
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if ([[dict objectForKey:@"total"] intValue] != 0) {
            
        NSMutableArray *supportData = [dict objectForKey:@"data"];
        NSLog(@"本产品对应供应商：%@",supportData);
        int i = 0;
        for (NSDictionary *item in supportData) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, trendY+i*140, screenHeight, 140)];
            [parentView addSubview:view];
            
            UILabel *nameLabel = [[UILabel alloc ] initWithFrame:CGRectMake(15, 5, screenWidth-20, 18)];
            
//            [nameLabel setText:@"深圳市宏鸿农产品有限公司"];
            [nameLabel setText:[NSString stringWithFormat:@"%@",[item objectForKey:@"providerName"]]];
            [nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
            [nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [view addSubview:nameLabel];
            
            
            UILabel *providerLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+8, nameLabel.frame.size.width, nameLabel.frame.size.height)];
            [providerLabel setTextColor:RGBClor(74, 74, 74)];
            [providerLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//            [providerLabel setText:@"主营产品：蔬菜、水果、鲜肉"];
            [providerLabel setText:[NSString stringWithFormat:@"主营产品：%@",[item objectForKey:@"mainProduct"]]];
            [view addSubview:providerLabel];
            
            
            UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, providerLabel.frame.origin.y+providerLabel.frame.size.height+5, nameLabel.frame.size.width, nameLabel.frame.size.height)];
            
            [contactLabel setTextColor:RGBClor(74, 74, 74)];
            [contactLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//            [contactLabel setText:@"联系人：张三丰"];
            [contactLabel setText:[NSString stringWithFormat:@"联系人：%@",[item objectForKey:@"contact"]]];
            [view addSubview:contactLabel];
            
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, contactLabel.frame.origin.y+contactLabel.frame.size.height+5, 60, nameLabel.frame.size.height)];
            
            [numberLabel setTextColor:RGBClor(74, 74, 74)];
            //    [numberLabel setBackgroundColor:[UIColor redColor]];
            [numberLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            [numberLabel setText:@"联系电话："];
            [view addSubview:numberLabel];
            
            UIButton *contactNumber = [[UIButton alloc] initWithFrame:CGRectMake(numberLabel.frame.origin.x+numberLabel.frame.size.width, numberLabel.frame.origin.y, 90, nameLabel.frame.size.height)];
//            [contactNumber setTitle:@"4006755303" forState:UIControlStateNormal];
            [contactNumber setTitle:[NSString stringWithFormat:@"%@",[item objectForKey:@"contactNumber"]] forState:UIControlStateNormal];
            [contactNumber setTitleColor:RGBClor(255, 102, 0) forState:UIControlStateNormal];
            [contactNumber.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [contactNumber.titleLabel setTextAlignment:NSTextAlignmentLeft];
            
            //    [contactNumber setBackgroundColor:[UIColor redColor]];
            [contactNumber addTarget:self action:@selector(callNumber:)  forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:contactNumber];
            
            UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, numberLabel.frame.origin.y+numberLabel.frame.size.height+5, screenWidth-20, nameLabel.frame.size.height*2)];
            [address setNumberOfLines:2];
            [address setLineBreakMode:NSLineBreakByWordWrapping];
            [address setTextColor:RGBClor(74, 74, 74)];
            [address setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//            [address setText:@"深圳平湖街道办良安田社区榄树下工业区149号"];
            [address setText:[NSString stringWithFormat:@"%@",[item objectForKey:@"companyAddress"]]];
            [view addSubview:address];
            
            UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(5, 139, screenWidth-5, 1)];
            [hLine setBackgroundColor:RGBClor(238, 238, 238)];
            [view addSubview:hLine];

            i++;
        
            
        
        }
        
        
        trendY += 140*[supportData count];
        }
        else
        {
            UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, trendY+10, screenWidth, 40)];
            [emptyLabel setText:@"暂无供应商推荐"];
            [emptyLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
            [parentView addSubview:emptyLabel];
            trendY +=50;
        }

        [parentView setContentSize:CGSizeMake(screenWidth, trendY+10)];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activity stopAnimating];
        [self showMSG:@"获取数据失败,请检查网络连接"];
        NSLog(@"请求失败:%@",error);
    }];
}

#pragma mark - FYChartViewDataSource

//number of value count
- (NSInteger)numberOfValueItemCountInChartView:(FYChartView *)chartView;
{
    return lineData ? lineData.count : 0;
}

//value at index
- (float)chartView:(FYChartView *)chartView valueAtIndex:(NSInteger)index
{
    NSDictionary *item = [lineData objectAtIndex:index];
    
    return [[item objectForKey:@"rprice"] floatValue];
}

//horizontal title at index
- (NSString *)chartView:(FYChartView *)chartView horizontalTitleAtIndex:(NSInteger)index
{
        NSDictionary *item = [lineData objectAtIndex:index];

    if (index == 0 || index == lineData.count - 1)
    {
        return [NSString stringWithFormat:@"%@",[item objectForKey:@"gatherDateStr"]];
    }
    
    return nil;
//
//    return [NSString stringWithFormat:@"%@",[item objectForKey:@"gatherDateStr"]];
}

//horizontal title alignment at index
- (HorizontalTitleAlignment)chartView:(FYChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index
{
    HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
    if (index == 0)
    {
        alignment = HorizontalTitleAlignmentCenter;
    }
    else if (index == lineData.count - 1)
    {
        alignment = HorizontalTitleAlignmentRight;
    }
    
    return alignment;
}

//description view at index
- (UIView *)chartView:(FYChartView *)chartView descriptionViewAtIndex:(NSInteger)index
{
    NSDictionary *item = [lineData objectAtIndex:index];

    NSString *description = [NSString stringWithFormat:@"价格:%@\n日期:%@", [item objectForKey:@"rprice"], [item objectForKey:@"gatherDateStr"]];
    
    UIView *descView = [[UIView alloc]  init];
    CGRect frame = descView.frame;
    frame.size = CGSizeMake(100.0f, 40.0f);
    descView.frame = frame;
    UILabel *label = [[UILabel alloc]
                       initWithFrame:CGRectMake(.0f, .0f, descView.frame.size.width, descView.frame.size.height)] ;
    label.text = description;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:10.0f];
    [descView addSubview:label];
    
    return descView;
}




-(void)addToList:(BOOL)del
{
    
    
   
    NSDictionary *parameters = [[NSDictionary alloc ] initWithObjectsAndKeys:server,@"server_str",CLIENT_STRING,@"client_str",[WeGameHelper getString:@"UserID"],@"userid",[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"productId"]],@"productid",[NSString stringWithFormat:@"%@",[ProductInfo objectForKey:@"marketoid"]],@"marketoid",nil];
    
    

    
    __block NSDictionary *dict = [[NSDictionary alloc] init];
    if (del) {
        [manager GET: [DEL_LIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            dict=(NSDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if ([[dict objectForKey:@"status"] intValue] == 200) {
                [self showMSG:@"删除成功"];
            }
            
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
            if ([[dict objectForKey:@"status"] intValue] == 200) {
                [self showMSG:@"收藏成功"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"请求失败:%@",error);
        }];
        
        
    }
    
   
    

}

-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnClick:(id)sender
{
    
    if (![WeGameHelper getLogin]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录后使用此功能" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"登录", nil];
        [alert show];
        return;
    }
    if (isInsert) {
        isInsert = NO;
        UIButton *btnInsert = (UIButton*)sender;
        [btnInsert setTitle:@"移除清单" forState:UIControlStateNormal];
        [btnInsert setTitleColor:RGBClor(95, 95, 95) forState:UIControlStateNormal];
        [btnInsert setBackgroundColor:RGBClor(239, 239, 239)];
        
        [self addToList:NO];
    }
    else
    {
        isInsert = YES;
        UIButton *btnInsert = (UIButton*)sender;
        [btnInsert setTitle:@"加入清单" forState:UIControlStateNormal];
        [btnInsert setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnInsert setBackgroundColor:RGBClor(255, 102, 0)];
        [self addToList:YES];

    }
}


-(void)callNumber:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",btn.titleLabel.text]]];//打电话
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        [lvc setHomeMsg:NO];
        [self.navigationController pushViewController:lvc animated:YES];
    }
}
@end
