//
//  FYChartView.m
//
//  sina weibo:http://weibo.com/zbflying
//
//  Created by zbflying on 13-11-27.
//  Copyright (c) 2013年 zbflying All rights reserved.
//

#import "FYChartView.h"

@interface FYChartView ()

@property (nonatomic, retain) NSMutableArray *valueItemArray;
@property (nonatomic, retain) UIView *descriptionView;
@property (nonatomic, retain) UIView *slideLineView;

@end

@implementation FYChartView
{
    @private
    BOOL    isLoaded;                   //is already load
    float   horizontalItemWidth;        //horizontal item width
    float   verticalItemHeight;         //vertical item width
    float   maxVerticalValue;           //max vertical value
    CGSize  verticalTextSize;           //vertical text size
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //default line width
        self.rectanglelineWidth = 1.0f;
        self.lineWidth = 1.0f;
        
        //default line color
        self.rectangleLineColor = [UIColor blackColor];
        self.lineColor = [UIColor blackColor];
        
        self.hideDescriptionViewWhenTouchesEnd = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (isLoaded)   return;
    
    //draw data line
    [self drawValueLine:rect];
    
    //draw rectangle line and vertical text
    [self drawRectangleAndVerticalText:rect];
    
    isLoaded = YES;
}



/**
 *  draw rectangle
 */
- (void)drawRectangleAndVerticalText:(CGRect)rect
{
    rect.origin.x = verticalTextSize.width;
    rect.origin.y = verticalTextSize.height;
    rect.size.width -= verticalTextSize.width;
    rect.size.height -= (verticalTextSize.height * 2);
    

    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    float itemHeight = rect.size.height / 5;
    float itemWidth = rect.size.width /5;
    for (int i = 0; i <= 5; i++)
    {
        if (i == 0) {
            
            CGContextMoveToPoint(currentContext, rect.origin.x+5, rect.size.height - itemHeight * i + verticalTextSize.height);
            CGContextAddLineToPoint(currentContext,
                                    rect.size.width + verticalTextSize.width,
                                    rect.size.height - itemHeight * i +verticalTextSize.height);
           
        }
        else
        {
            CGContextSetLineWidth(currentContext, 1.0);
            CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
            CGFloat lengths[] = {2,2};
            CGContextSetLineDash(currentContext, 0, lengths,2);
            
            CGContextMoveToPoint(currentContext, rect.origin.x+5, rect.size.height - itemHeight * i + verticalTextSize.height);
            
            CGContextAddLineToPoint(currentContext,
                                    rect.size.width + verticalTextSize.width,
                                    rect.size.height - itemHeight * i +verticalTextSize.height);
            
        }
        
        
        //画竖线
        if(i != 5 && i!=0)
        {
            CGContextSetLineWidth(currentContext, 1.0);
            CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
            CGFloat lengths[] = {2,2};
            CGContextSetLineDash(currentContext, 0, lengths,2);
            
            CGContextMoveToPoint(currentContext, rect.origin.x + i*itemWidth, rect.origin.y);
            
            CGContextAddLineToPoint(currentContext,
                                    rect.origin.x + i*itemWidth,
                                    rect.size.height  +verticalTextSize.height);
        }
        
        CGContextClosePath(currentContext);
        CGContextStrokePath(currentContext);
        
        NSString *text = [NSString stringWithFormat:@"%.1f", (i + 1) * (maxVerticalValue / 6)];
        [text drawAtPoint:CGPointMake(.0f,
                                      rect.size.height - itemHeight * i + verticalTextSize.height - verticalTextSize.height * 0.5f)
                 withFont:[UIFont systemFontOfSize:10.0f]];
    }
}

/**
 *  draw data line
 */
- (void)drawValueLine:(CGRect)rect
{
    if (!self.dataSource)   return;
    
    //item count
    NSInteger numberOfHorizontalItemCount = [self.dataSource numberOfValueItemCountInChartView:self];
    if (!numberOfHorizontalItemCount)   return;
    
    NSMutableArray *valueItems = [NSMutableArray array];
    for (int i = 0; i < numberOfHorizontalItemCount; i++)
    {
        float value = [self.dataSource chartView:self valueAtIndex:i];
        [valueItems addObject:[NSNumber numberWithFloat:value]];
        
        if (value >= maxVerticalValue)  maxVerticalValue = value*1.2;
    }
    
    maxVerticalValue = ceilf(maxVerticalValue);
    verticalTextSize = [[NSString stringWithFormat:@"%.2f", maxVerticalValue] sizeWithFont:[UIFont systemFontOfSize:10.0f]];
    
    self.valueItemArray = valueItems;
    horizontalItemWidth = (rect.size.width - verticalTextSize.width) / (numberOfHorizontalItemCount - 1);
    verticalItemHeight = (rect.size.height - verticalTextSize.height * 2) / maxVerticalValue;
    
    for (int i = 0; i < valueItems.count - 1; i++)
    {
        float value = [(NSNumber *)valueItems[i] floatValue];
        CGPoint point = [self valuePoint:value atIndex:i];
        
        float nextValue = [(NSNumber *)valueItems[i + 1] floatValue];
        CGPoint nextPoint = [self valuePoint:nextValue atIndex:i + 1];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextMoveToPoint(context, point.x, point.y);
        CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    
    //draw horizontal title
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(chartView:horizontalTitleAtIndex:)])
    {
        for (int i = 0; i < valueItems.count; i++)
        {
            NSString *title = [self.dataSource chartView:self horizontalTitleAtIndex:i];
            if (title)
            {
                float value = [(NSNumber *)valueItems[i] floatValue];
                CGPoint point = [self valuePoint:value atIndex:i];
                
                UIFont *font = [UIFont systemFontOfSize:10.0f];
                CGSize size = [title sizeWithFont:font];
                
                HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
                if ([self.dataSource respondsToSelector:@selector(chartView:horizontalTitleAlignmentAtIndex:)])
                {
                    alignment = [self.dataSource chartView:self horizontalTitleAlignmentAtIndex:i];
                }
                
                if (alignment == HorizontalTitleAlignmentLeft)
                {
                    [title drawAtPoint:CGPointMake(point.x, rect.size.height - size.height) withFont:font];
                }
                else if (alignment == HorizontalTitleAlignmentCenter)
                {
                    [title drawAtPoint:CGPointMake(point.x - size.width * 0.5f, rect.size.height - size.height) withFont:font];
                }
                else if (alignment == HorizontalTitleAlignmentRight)
                {
                    [title drawAtPoint:CGPointMake(point.x - size.width, rect.size.height - size.height) withFont:font];
                }
            }
        }
    }
}

#pragma mark - custom method

/**
 *  value item point at index
 */
- (CGPoint)valuePoint:(float)value atIndex:(int)index
{
    CGPoint retPoint = CGPointZero;
    
    retPoint.x = index * horizontalItemWidth + verticalTextSize.width;
    retPoint.y = self.frame.size.height - verticalTextSize.height - value * verticalItemHeight;
    
    return retPoint;
}

/**
 *  display description view
 */
- (void)descriptionViewPointWithTouches:(NSSet *)touches
{
    CGSize size = self.frame.size;
    CGPoint location = [[touches anyObject] locationInView:self];
    if (location.x >= 0 && location.x <= size.width && location.y >= 0 && location.y <= size.height)
    {
        int intValue = location.x / horizontalItemWidth;
        float remainder = location.x - intValue * horizontalItemWidth;
        
        int index = intValue + (remainder >= horizontalItemWidth * 0.5f ? 1 : 0);
        if (index < self.valueItemArray.count)
        {
            float value = [(NSNumber *)self.valueItemArray[index] floatValue];
            CGPoint point = [self valuePoint:value atIndex:index];
            
            if ([self.dataSource respondsToSelector:@selector(chartView:descriptionViewAtIndex:)])
            {
                UIView *descriptionView = [self.dataSource chartView:self descriptionViewAtIndex:index];
                CGRect frame = descriptionView.frame;
                if (point.x + frame.size.width > size.width)
                {
                    frame.origin.x = point.x - frame.size.width;
                }
                else
                {
                    frame.origin.x = point.x;
                }
                
                if (frame.size.height + point.y > size.height)
                {
                    frame.origin.y = point.y - frame.size.height;
                }
                else
                {
                    frame.origin.y = point.y;
                }
                
                descriptionView.frame = frame;
                
                if (self.descriptionView)   [self.descriptionView removeFromSuperview];
                
                if (!self.slideLineView)
                {
                    //slide line view
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(.0f,
                                                                                 verticalTextSize.height,
                                                                                 1.0f,
                                                                                 self.frame.size.height - verticalTextSize.height * 2)] ;
                    lineView.backgroundColor = [UIColor redColor];
                    lineView.hidden = YES;
                    self.slideLineView = lineView;
                    [self addSubview:self.slideLineView];
                }
                
                //draw line
                CGRect slideLineViewFrame = self.slideLineView.frame;
                slideLineViewFrame.origin.x = point.x;
                self.slideLineView.frame = slideLineViewFrame;
                self.slideLineView.hidden = NO;
                
                [self addSubview:descriptionView];
                self.descriptionView = descriptionView;
                
                //delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(chartView:didMovedToIndex:)])
                {
                    [self.delegate chartView:self didMovedToIndex:index];
                }
            }
        }
    }
}

- (void)reloadData
{
    isLoaded = NO;
    [self.valueItemArray removeAllObjects];
    horizontalItemWidth = .0f;
    verticalItemHeight = .0f;
    maxVerticalValue = .0f;
    if (self.descriptionView)   [self.descriptionView removeFromSuperview];
    if (self.slideLineView)   self.slideLineView.hidden = YES;
    [self setNeedsDisplay];
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.valueItemArray || !self.valueItemArray.count || !self.dataSource) return;
    
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.descriptionView && self.hideDescriptionViewWhenTouchesEnd)   [self.descriptionView removeFromSuperview];
}

@end
