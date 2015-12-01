//
//  WSHeaderView
//  CustomNavignonSimple
//
//  Created by shlity on 15/7/27.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface WSHeaderView : NSObject <UIScrollViewDelegate>
{
    UIScrollView   *_scrollView;
    UIView         *_expandView;
}

+ (id)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView;

@end
