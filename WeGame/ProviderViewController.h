//
//  ProviderViewController.h
//  WeGame
//
//  Created by Lynnrichter on 15/1/20.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeGameHelper.h"

@interface ProviderViewController : UIViewController
{
    float screenWidth;
    float screenHeight;
    UIScrollView *ParentView;

}

@property(nonatomic,strong)NSDictionary *item;

@end
