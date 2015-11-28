//
//  UIImage+Scale.m
//  妈妈去哪儿
//
//  Created by shlity on 15/8/27.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{

    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
