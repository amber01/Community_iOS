//
//  UIImageView+ImageColor.m
//  Community
//
//  Created by shlity on 16/4/19.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "UIImageView+ImageColor.h"

@implementation UIImageView (ImageColor)

- (void)imageWithColor:(UIColor *)color
{
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setTintColor:color];
}

@end
