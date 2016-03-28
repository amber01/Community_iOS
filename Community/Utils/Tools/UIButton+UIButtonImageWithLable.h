//
//  UIButton+UIButtonImageWithLable.h
//  妈妈去哪儿
//
//  Created by shlity on 16/1/8.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonImageWithLable)

/**
 *  让button上的图片和文字上下显示
 *
 *  @param image     image
 *  @param title     title
 *  @param stateType stateType
 */
- (void) setImage:(UIImage *)image withTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)color forState:(UIControlState)stateType;

/**
 *  让button上的图片和文字横向显示(图片在左，文字在右)
 *
 *  @param image     image
 *  @param title     title
 *  @param stateType stateType
 */
- (void) setImageHorizontal:(UIImage *)image withTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)color forState:(UIControlState)stateType;

/**
 *  让button上的图片和文字横向显示(图片在右，文字在左)
 *
 *  @param image     image
 *  @param title     title
 *  @param stateType stateType
 */
- (void) setImageRightHorizontal:(UIImage *)image withTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)color forState:(UIControlState)stateType;

/**
 *  创建一个普通的button
 *
 *  @param image     button的背景图片或颜色
 *  @param title     title
 *  @param font      font
 *  @param color     color
 *  @param stateType stateType
 */
- (void) setBackgroundView:(UIImage *)image withTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)color forState:(UIControlState)stateType;

/**
 *  创建一个普通的button
 *
 *  @param backgroundColor     button的背景颜色
 *  @param title               title
 *  @param font                font
 *  @param color               color
 *  @param stateType           stateType
 */
- (void) setBackgroundColor:(UIColor *)backgroundColor withTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)color forState:(UIControlState)stateType;
@end
