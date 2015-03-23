//
//  XCMultiTableView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WeGameHelper.h"

typedef NS_ENUM(NSUInteger, SortColumnType) {
    SortColumnTypeInteger,
    SortColumnTypeFloat,
    SortColumnTypeDate,
};


@protocol XCMultiTableViewDataSource;
@protocol XCMultiTableViewDelegate;

@interface XCMultiTableView : UIView

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat topHeaderHeight;
@property (nonatomic, assign) CGFloat leftHeaderWidth;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) int SortByName;
@property (nonatomic, assign) int SortByPrice;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL isList;


@property (nonatomic, assign) BOOL leftHeaderEnable;

@property (nonatomic, weak) id<XCMultiTableViewDataSource> datasource;
@property (nonatomic, weak)id<XCMultiTableViewDelegate> delegate;


- (void)reloadData;

@end

@protocol XCMultiTableViewDataSource <NSObject>

@required
- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView;
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView;
- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView ;

@end



//点击事件处理事宜
@protocol XCMultiTableViewDelegate<NSObject>
@optional
-(void)sortByName:(int)sort;
-(void)sortByPrice:(int)sort;
-(void)addToList:(int)rowID delete:(BOOL)del;
-(void)rowSelected:(int)rowID;
-(void)addMore;

@end

