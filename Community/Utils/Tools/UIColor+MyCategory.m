//
//  UIColor+MyCategory.m
//  GoddessClock
//
//  Created by wubing on 14-9-13.
//  Copyright (c) 2014年 iMac. All rights reserved.
//

#import "UIColor+MyCategory.h"

@implementation UIColor (MyCategory)

+ (UIColor *)colorWithRGB:(NSInteger)rgb
{
    CGFloat red = (rgb>>16)&0xff;
    CGFloat green = (rgb>>8)&0xff;
    CGFloat blue = rgb&0xff;
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0];
}
@end
