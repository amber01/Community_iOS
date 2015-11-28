//
//  UIImage+Mycategory.m
//  GoddessClock
//
//  Created by wubing on 14-9-13.
//  Copyright (c) 2014年 iMac. All rights reserved.
//

#import "UIImage+Mycategory.h"

@implementation UIImage (Mycategory)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
