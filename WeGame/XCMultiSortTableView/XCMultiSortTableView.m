//
//  XCMultiTableView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "XCMultiSortTableView.h"

#import "XCMultiSortTableViewDefault.h"
#import "XCMultiSortTableViewBGScrollView.h"

#import "UIView+XCMultiSortTableView.h"

//#define AddHeightTo(v, h) { CGRect f = v.frame; f.size.height += h; v.frame = f; }

typedef NS_ENUM(NSUInteger, TableColumnSortType) {
    TableColumnSortTypeAsc,
    TableColumnSortTypeDesc,
    TableColumnSortTypeNone
};

@interface XCMultiTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

- (void)reset;
- (void)adjustView;
- (void)setUpTopHeaderScrollView;
- (void)accessColumnPointCollection;

- (UITableViewCell *)leftHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)contentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation XCMultiTableView {
    XCMultiTableViewBGScrollView *topHeaderScrollView;
    XCMultiTableViewBGScrollView *contentScrollView;
    UITableView *leftHeaderTableView;
    UITableView *contentTableView;
    UIButton *vertexView;
    UIImageView *arrow;
    
    NSArray *columnPointCollection;
    
    NSMutableArray *contentDataArray;
    

    
    NSMutableArray *inList;
    

    BOOL responseNumberofContentColumns;
    float ex_x ;

}

@synthesize cellWidth, cellHeight, topHeaderHeight, leftHeaderWidth,SortByPrice,SortByName;
@synthesize leftHeaderEnable;
@synthesize hasMore;

@synthesize datasource,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ex_x = 0;
//        self.layer.borderColor = [[UIColor colorWithWhite:XCMultiTableView_BoraerColorGray alpha:1.0f] CGColor];
//        self.layer.cornerRadius = XCMultiTableView_CornerRadius;
//        self.layer.borderWidth = XCMultiTableView_BorderWidth;
//        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        inList = [[NSMutableArray alloc] init];
        
        cellWidth = XCMultiTableView_DefaultCellWidth;
        cellHeight = XCMultiTableView_DefaultCellHeight;
        topHeaderHeight = XCMultiTableView_DefaultTopHeaderHeight;
        leftHeaderWidth = XCMultiTableView_DefaultLeftHeaderWidth;
        SortByName = 1;
        SortByPrice = 0;
        
        vertexView = [UIButton buttonWithType:UIButtonTypeCustom];
        [vertexView setFrame: CGRectMake(0, 0, leftHeaderWidth-10, topHeaderHeight)];
        vertexView.backgroundColor = RGBClor(245, 245, 245);
        [vertexView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [vertexView setTitle:@"品名" forState:UIControlStateNormal];
        [vertexView.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [vertexView addTarget:self action:@selector(leftHeaderTap) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:vertexView];
        
        topHeaderScrollView = [[XCMultiTableViewBGScrollView alloc] initWithFrame:CGRectZero];
        topHeaderScrollView.backgroundColor = [UIColor clearColor];
        topHeaderScrollView.parent = self;
        topHeaderScrollView.delegate = self;
        topHeaderScrollView.showsHorizontalScrollIndicator = NO;
        topHeaderScrollView.showsVerticalScrollIndicator = NO;
        topHeaderScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        topHeaderScrollView.alwaysBounceHorizontal = NO;
        [self addSubview:topHeaderScrollView];
        
        leftHeaderTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        leftHeaderTableView.dataSource = self;
        leftHeaderTableView.delegate = self;
        leftHeaderTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        leftHeaderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        leftHeaderTableView.backgroundColor = [UIColor clearColor];
        leftHeaderTableView.showsHorizontalScrollIndicator = NO;
        leftHeaderTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:leftHeaderTableView];
        
        contentScrollView = [[XCMultiTableViewBGScrollView alloc] initWithFrame:CGRectZero];
        contentScrollView.backgroundColor = [UIColor clearColor];
        contentScrollView.parent = self;
        contentScrollView.delegate = self;
        contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        contentScrollView.alwaysBounceHorizontal = NO;
        contentScrollView.bounces = NO;
        [self addSubview:contentScrollView];
        
        contentTableView = [[UITableView alloc] initWithFrame:contentScrollView.bounds];
        contentTableView.dataSource = self;
        contentTableView.delegate = self;
        contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.backgroundColor = [UIColor clearColor];
        [contentScrollView addSubview:contentTableView];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat superWidth = self.bounds.size.width;
    CGFloat superHeight = self.bounds.size.height;
    
    if (leftHeaderEnable) {
        vertexView.frame = CGRectMake(0, 0, leftHeaderWidth, topHeaderHeight);
        topHeaderScrollView.frame = CGRectMake(leftHeaderWidth , 0, superWidth - leftHeaderWidth, topHeaderHeight);
        leftHeaderTableView.frame = CGRectMake(0, topHeaderHeight , leftHeaderWidth, superHeight - topHeaderHeight );
        contentScrollView.frame = CGRectMake(leftHeaderWidth, topHeaderHeight , superWidth - leftHeaderWidth , superHeight - topHeaderHeight);
    }else {
        topHeaderScrollView.frame = CGRectMake(0, 0, superWidth, topHeaderHeight);
        contentScrollView.frame = CGRectMake(0, topHeaderHeight , superWidth, superHeight - topHeaderHeight );
    }
    
    [self adjustView];
}

- (void)reloadData {
    [self reset];
    [leftHeaderTableView reloadData];
    [contentTableView reloadData];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextSetLineWidth(context, boldSeperatorLineWidth);
    CGContextSetAllowsAntialiasing(context, false);
//    CGContextSetStrokeColorWithColor(context, [boldSeperatorLineColor CGColor]);
    
    if (leftHeaderEnable) {
        CGFloat x = leftHeaderWidth ;
        CGContextMoveToPoint(context, x, 0.0f);
//        CGContextAddLineToPoint(context, x, self.bounds.size.height);
        CGFloat y = topHeaderHeight  / 2.0f;
        CGContextMoveToPoint(context, 0.0f, y);
//        CGContextAddLineToPoint(context, self.bounds.size.width, y);
    }else {
        CGFloat y = topHeaderHeight ;
        CGContextMoveToPoint(context, 0.0f, y);
//        CGContextAddLineToPoint(context, self.bounds.size.width, y);
    }
    
    CGContextStrokePath(context);
}

- (void)dealloc {
    topHeaderScrollView = nil;
    contentScrollView = nil;
    leftHeaderTableView = nil;
    contentTableView = nil;
    columnPointCollection = nil;
}

#pragma mark - property

- (void)setDatasource:(id<XCMultiTableViewDataSource>)datasource_ {
    if (datasource != datasource_) {
        datasource = datasource_;
        responseNumberofContentColumns = [datasource_ respondsToSelector:@selector(arrayDataForTopHeaderInTableView:)];

        [self reset];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *target = nil;
    if (tableView == leftHeaderTableView) {
        target = contentTableView;
    }else if (tableView == contentTableView) {
        target = leftHeaderTableView;
    }else {
        target = nil;
    }
//    if (hasMore) {
//        if (indexPath.row == [self rowsInData]) {
//            NSLog(@"点击加载更多");
//            [target selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            [target deselectRowAtIndexPath:indexPath animated:YES];
//            [tableView deselectRowAtIndexPath:indexPath animated:YES];
//            return;
//        }
//    }
    [target selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [target deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [delegate rowSelected:indexPath.row];
    //直接发数据给parentviewcontroller,发送当前点击的行 的id

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return topHeaderHeight;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (hasMore) {
//        return [self rowsInData]+1;
//    }
//    else{
        return [self rowsInData];
//    } 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == leftHeaderTableView) {
        return [self leftHeaderTableView:tableView cellForRowAtIndexPath:indexPath];
    }else {
        return [self contentTableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *target = nil;
    if (scrollView == leftHeaderTableView) {
        target = contentTableView;
    }else if (scrollView == contentTableView) {
        target = leftHeaderTableView;
    }else if (scrollView == contentScrollView) {
        target = topHeaderScrollView;
    }else if (scrollView == topHeaderScrollView) {
        target = contentScrollView;
    }
    target.contentOffset = scrollView.contentOffset;
    
    CGFloat height = target.frame.size.height;
    CGFloat distanceFromButton = target.contentSize.height - target.contentOffset.y;
    
//    NSLog(@"ex_x = %f  , contentoffset.x = %f" ,ex_x,target.contentOffset.x);
    if (ex_x != target.contentOffset.x ) {
        
    }
    else
    {
        if (distanceFromButton == height)
        {
            
            if (hasMore) {
                [delegate addMore];
            }
            
        }
        
    }
    
    
}

#pragma mark - private method

- (void)reset {
    
    
    [self accessDataSourceData];
    
    [self accessColumnPointCollection];
    [self setUpTopHeaderScrollView];
    [contentScrollView reDraw];
}

- (void)adjustView {
    
    CGFloat width = 0.0f;
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    for (int i = 1; i <= count + 1; i++) {
        if (i == count + 1) {
            width += 0;
        }else {
            width += 0 + cellWidth;
        }
    }
    
//    NSLog(@"width:%f, height:%f", self.frame.size.width, self.frame.size.height);
    
    topHeaderScrollView.contentSize = CGSizeMake(width, topHeaderHeight);
    contentScrollView.contentSize = CGSizeMake(width, self.bounds.size.height - topHeaderHeight);
    
    contentTableView.frame = CGRectMake(0.0f, 0.0f, width, self.bounds.size.height - topHeaderHeight);
}



- (void)setUpTopHeaderScrollView {
    for (UIView *view in topHeaderScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    for (int i = 0; i < count; i++) {
        
        CGFloat topHeaderW = cellWidth;
        
        
        CGFloat widthP = [[columnPointCollection objectAtIndex:i] floatValue];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topHeaderW, topHeaderHeight)];
        view.clipsToBounds = YES;
        view.center = CGPointMake(widthP, topHeaderHeight / 2.0f);
        view.tag = i;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [[datasource arrayDataForTopHeaderInTableView:self] objectAtIndex:i];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [label sizeToFit];
        label.center = CGPointMake(topHeaderW / 2.0f, topHeaderHeight / 2.0f);

        
        [view addSubview:label];
        
        if (3 == i) {
            
            arrow = [[UIImageView alloc ] initWithFrame:CGRectMake(80, 7, 15, 15)];
            if (SortByPrice == 1 ) {
               [arrow setImage:[UIImage imageNamed:@"icon_up"]];
                //        更换箭头图标朝向
            }else{

                [arrow setImage:[UIImage imageNamed:@"icon_none"]];
            }

            [view addSubview:arrow];
            //此处增加一个小红图标
            UITapGestureRecognizer *topHeaderGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentHeaderTap:)];
            [view addGestureRecognizer:topHeaderGecognizer];
        }
       
        

        
        
        [topHeaderScrollView addSubview:view];
    }
    [topHeaderScrollView setBackgroundColor:RGBClor(245, 245, 245)];
    [topHeaderScrollView reDraw];

}

- (void)accessColumnPointCollection {
    NSUInteger columns = responseNumberofContentColumns ? [datasource arrayDataForTopHeaderInTableView:self].count : 0;
    if (columns == 0) @throw [NSException exceptionWithName:nil reason:@"number of content columns must more than 0" userInfo:nil];
    NSMutableArray *tmpAry = [NSMutableArray array];
    CGFloat widthColumn = 0.0f;
    CGFloat widthP = 0.0f;
    for (int i = 0; i < columns; i++) {
        CGFloat columnWidth = cellWidth;
        widthColumn += columnWidth;
        widthP = widthColumn - columnWidth / 2.0f;
        [tmpAry addObject:[NSNumber numberWithFloat:widthP]];
    }
    columnPointCollection = [tmpAry copy];
}



- (UITableViewCell *)leftHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (hasMore) {
//        if (indexPath.row == [self rowsInData]) {
//            static NSString *leftcellid = @"leftempty";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftcellid];
//            
//            cell.tag = indexPath.row;
//            if(!cell){
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:leftcellid];
//                
//            }else{
//                while ([cell.contentView.subviews lastObject] != nil) {
//                    [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//                }
//            }
//            
//            [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//            
//            if (indexPath.row%2 == 1) {
//                [cell setBackgroundColor:RGBClor(245, 245, 245)];
//            }
//            else
//            {
//                [cell setBackgroundColor:[UIColor whiteColor]];
//                
//            }
//
//            return cell;
//            
//        }
//    }
//    
    static NSString *leftcellid = @"leftHeaderTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftcellid];
    
    cell.tag = indexPath.row;
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:leftcellid];
        
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (indexPath.row%2 == 1) {
        [cell setBackgroundColor:RGBClor(245, 245, 245)];
    }
    else
    {
        [cell setBackgroundColor:[UIColor whiteColor]];

    }
    
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, topHeaderHeight)];
    NSDictionary *item =[contentDataArray objectAtIndex:indexPath.row];
    label.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"productName"]] ;
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [label setLineBreakMode:NSLineBreakByTruncatingTail];
    [cell.contentView addSubview:label];
    return cell;
}

- (UITableViewCell *)contentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (hasMore) {
//        if (indexPath.row == [self rowsInData]) {
//            static NSString  *contentid = @"addmore";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentid];
//            cell.tag = indexPath.row;
//            if(!cell){
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:contentid];
//                if (indexPath.row%2 == 1) {
//                    [cell setBackgroundColor:RGBClor(245, 245, 245)];
//                }
//                else
//                {
//                    [cell setBackgroundColor:[UIColor whiteColor]];
//                    
//                }
//                
//                UILabel *morelabel =  [[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.frame.size.width-100)/2-leftHeaderWidth, 0, 100,topHeaderHeight )];
//                morelabel.text = @"点击加载更多";
//                [morelabel setTextColor:RGBClor(74, 74, 74)];
//                //            [morelabel setBackgroundColor:[UIColor redColor]];
//                [morelabel setTextAlignment:NSTextAlignmentCenter];
//                [morelabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//                [cell addSubview:morelabel];
//                
//            }
//            
//            
//            
//            return cell;
//            
//
//            
//            
//        }
//    }
    
    static NSString *leftcellid = @"contentTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftcellid];
    
    cell.tag = indexPath.row;
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:leftcellid];
        
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDictionary *item =[contentDataArray objectAtIndex:indexPath.row];
    if (indexPath.row%2 == 1) {
        [cell setBackgroundColor:RGBClor(245, 245, 245)];
    }
    else
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
        
    }
    //规格

    UILabel *speclabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth,topHeaderHeight )];
    speclabel.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"spec"]] ;
    [speclabel setTextAlignment:NSTextAlignmentCenter];
    [speclabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//    speclabel.adjustsFontSizeToFitWidth = YES;
//    [speclabel setMinimumScaleFactor:0.5];
    [cell.contentView addSubview:speclabel];
   
    
    //批发价
    UILabel *priceLabel =  [[UILabel alloc] initWithFrame:CGRectMake(speclabel.frame.origin.x+speclabel.frame.size.width+3, 0, cellWidth,topHeaderHeight )];
    priceLabel.text = [NSString stringWithFormat:@"¥%@",[item objectForKey:@"rprice"]] ;
    [priceLabel setTextAlignment:NSTextAlignmentCenter];
    [priceLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [priceLabel setTextColor:[UIColor redColor]];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    [priceLabel setMinimumScaleFactor:0.5];
    [cell.contentView addSubview:priceLabel];
    
    //单位
    UILabel *unitLabel =  [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x+priceLabel.frame.size.width, 0, cellWidth,topHeaderHeight )];
    unitLabel.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"unit"]] ;
    [unitLabel setTextAlignment:NSTextAlignmentCenter];
    [unitLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [cell.contentView addSubview:unitLabel];
    
    //购买指数
    UILabel *tempLabel =  [[UILabel alloc] initWithFrame:CGRectMake(unitLabel.frame.origin.x+unitLabel.frame.size.width, 0, cellWidth,topHeaderHeight )];
//    tempLabel.text = @"指数空？";
    if([NSString stringWithFormat:@"%@",[item objectForKey:@"priceIndex"]] == nil ||[[NSString stringWithFormat:@"%@",[item objectForKey:@"priceIndex"]] isEqualToString:@"<null>"] )
    {
        [tempLabel setText:@"0"];
    }else
    {
        [tempLabel setText:[NSString stringWithFormat:@"%@",[item objectForKey:@"priceIndex"]]];
    }
    
    [tempLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [tempLabel setTextColor:RGBClor(167, 0, 177)];
    [tempLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.contentView addSubview:tempLabel];
    
    //价格来源
    UILabel *marketShortLabel =  [[UILabel alloc] initWithFrame:CGRectMake(tempLabel.frame.origin.x+tempLabel.frame.size.width, 0, cellWidth,topHeaderHeight )];
    marketShortLabel.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"marketShort"]] ;
    [marketShortLabel setTextAlignment:NSTextAlignmentCenter];
    [marketShortLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [cell.contentView addSubview:marketShortLabel];
    
    //报价日期
    UILabel *releaseDateLabel =  [[UILabel alloc] initWithFrame:CGRectMake(marketShortLabel.frame.origin.x+marketShortLabel.frame.size.width, 0, cellWidth,topHeaderHeight )];
//    double timestamp =[[item objectForKey:@"releaseDate"] doubleValue];
//    NSLog(@"releaseDate:%@",[item objectForKey:@"releaseDate"]);
//    NSLog(@"timestamp:%f",timestamp);
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(timestamp/1000)];
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd"];

    releaseDateLabel.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"releaseDate"]];
    [releaseDateLabel setTextAlignment:NSTextAlignmentCenter];
    [releaseDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [cell.contentView addSubview:releaseDateLabel];
    //采购清单
    
    UIButton *btnInsert = [[UIButton alloc] initWithFrame:CGRectMake(releaseDateLabel.frame.origin.x+releaseDateLabel.frame.size.width+10, 2, 80,topHeaderHeight-4)];
    if(self.isList)
    {
        if ([[item objectForKey:@"isInUserPurchaseList"] integerValue] == 0) {
            [btnInsert setTitle:@"加入清单" forState:UIControlStateNormal];
            [btnInsert setBackgroundColor:RGBClor(255, 102, 0)];
            
        }
        else
        {
            [btnInsert setBackgroundColor:RGBClor(239,239,239)];
            [btnInsert setTitle:@"移除清单" forState:UIControlStateNormal];
            [btnInsert setTitleColor:RGBClor(95, 95, 95) forState:UIControlStateNormal];
        }
    }else
    {
        if ([[inList objectAtIndex:indexPath.row] integerValue] == 0) {
            [btnInsert setTitle:@"加入清单" forState:UIControlStateNormal];
            [btnInsert setBackgroundColor:RGBClor(255, 102, 0)];

        }
        else
        {
            [btnInsert setBackgroundColor:RGBClor(239,239,239)];
            [btnInsert setTitle:@"移除清单" forState:UIControlStateNormal];
            [btnInsert setTitleColor:RGBClor(95, 95, 95) forState:UIControlStateNormal];
        }
    }
    [btnInsert.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    btnInsert.layer.cornerRadius = 6;
    [btnInsert setTag:indexPath.row];
    [btnInsert addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnInsert];
    

    
    return cell;
}

//-(void)tableView:(UITableView *)tableView 
#pragma mark - GestureRecognizer

- (void)leftHeaderTap{
 
    //直接发数据给parentviewcontroller,更新本页面，按照品名排序
//    if (SortByName == 1 ) {
//        [delegate sortByName:0];
//        SortByName = 0;
////        更换箭头图标朝向
//        
//    
//    }else{
//        [delegate sortByName:1];
//        SortByName = 1;
//
//    }
//    NSLog(@"SortByName = %d",SortByName);

}

- (void)contentHeaderTap:(UITapGestureRecognizer *)recognizer {
    
    //直接发数据给parentviewcontroller,更新本页面，按照购买指数排序
    if (SortByPrice == 1 ) {
        [delegate sortByPrice:0];
        SortByPrice = 0;
        [arrow setImage:[UIImage imageNamed:@"icon_none"]];
//        更换箭头图标朝向
    }else{
        SortByPrice = 1;
        [delegate sortByPrice:1];
        [arrow setImage:[UIImage imageNamed:@"icon_up"]];
    }
    NSLog(@"SortByPiceIndex = %d",SortByPrice);

}



#pragma mark - other method

- (NSUInteger)rowsInData{
    return [contentDataArray count];
}

- (void)accessDataSourceData {
    contentDataArray = [[NSMutableArray alloc] initWithArray:[datasource arrayDataForLeftHeaderInTableView:self]];
    for (int i = 0; i<contentDataArray.count; i++) {
        if ([[[contentDataArray objectAtIndex:i] objectForKey:@"isInUserPurchaseList"] integerValue] == 0) {
            [inList addObject:@"0"];
        }
        else
        {
             [inList addObject:@"1"];
        }
    }
}



-(void)btnClick:(id)sender
{
    UIButton *touchRow = (UIButton*)sender;
    if (![WeGameHelper getLogin]) {
        [delegate addToList:touchRow.tag delete:YES];
        return;
    }
    
    
    if ([touchRow.titleLabel.text isEqual:@"移除清单"]) {
        if(self.isList)
        {
            [touchRow setBackgroundColor:RGBClor(239,239,239)];
            [touchRow setTitle:@"操作中..." forState:UIControlStateNormal];
            [touchRow setTitleColor:RGBClor(95, 95, 95) forState:UIControlStateNormal];
            
        }else
        {
            [touchRow setTitle:@"加入清单" forState:UIControlStateNormal];
            [touchRow setBackgroundColor:RGBClor(255, 102, 0)];
            [touchRow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [inList insertObject:@"0" atIndex:touchRow.tag];

        [delegate addToList:touchRow.tag delete:YES];

        
    }
    else
    {
        [touchRow setBackgroundColor:RGBClor(239,239,239)];
        [touchRow setTitle:@"移除清单" forState:UIControlStateNormal];
        [touchRow setTitleColor:RGBClor(95, 95, 95) forState:UIControlStateNormal];
        [inList insertObject:@"1" atIndex:touchRow.tag];

        [delegate addToList:touchRow.tag delete:NO];

    }

    

    NSLog(@"Touched Row :%d",touchRow.tag);
    
}


@end
