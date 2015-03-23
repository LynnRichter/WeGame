//
//  XCMultiTableViewBGScrollView.m
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "XCMultiSortTableViewBGScrollView.h"

#import "UIView+XCMultiSortTableView.h"

@implementation XCMultiTableViewBGScrollView {
    NSMutableArray *lines;
}

@synthesize parent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reDraw {



//    NSUInteger columnCount = [parent.datasource arrayDataForTopHeaderInTableView:parent].count;
//    for (int i = 0; i < columnCount; i++) {
//        CGFloat width;
//        if ([parent.datasource respondsToSelector:@selector(tableView:contentTableCellWidth:)]) {
//            width = [parent.datasource tableView:parent contentTableCellWidth:i];
//        }else {
//            width = parent.cellWidth;
//        }
//        
//      
//    }
}

- (void)dealloc {
    lines = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, parent.normalSeperatorLineWidth);
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    
    NSUInteger columnCount = [parent.headData count];
    for (int i = 0; i <= columnCount; i++) {
        CGFloat x = i * parent.cellWidth;
        CGContextMoveToPoint(context, x, 0.0f);
        CGContextAddLineToPoint(context, x, self.bounds.size.height);
    }
    
    CGContextStrokePath(context);

}
 */

@end
