//
//  UILabel+TextDifferentColor.h
//  妈妈去哪儿
//
//  Created by shlity on 16/1/8.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TextDifferentColor)

/**
 *  根据关键字设置label的不同颜色
 */
- (void)setTextColor:(UIColor *)textColor withText:(NSString *)keyword;

/**
 *  设置label的不同颜色
 */
- (void)setTextColor:(UIColor *)textColor range:(NSRange)range;

/**
 *  设置label的不同大小
 */
- (void)setFont:(UIFont *)font range:(NSRange)range;

/**
 *  同时设置不同颜色和不同字体大小
 */
- (void)setTextColor:(UIColor *)textColor withFont:(UIFont *)font range:(NSRange)range;


@end
