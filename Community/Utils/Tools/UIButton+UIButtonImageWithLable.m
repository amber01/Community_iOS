//
//  UIButton+UIButtonImageWithLable.m
//  妈妈去哪儿
//
//  Created by shlity on 16/1/8.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "UIButton+UIButtonImageWithLable.h"

@implementation UIButton (UIButtonImageWithLable)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)color forState:(UIControlState)stateType
{
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title sizeWithFont:font];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:font];
    [self.titleLabel setTextColor:color];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

- (void) setImageHorizontal:(UIImage *)image withTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)color forState:(UIControlState)stateType
{
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    //CGSize titleSize = [title sizeWithFont:font];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                              0.0,
                                              0.0,
                                              0.0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:font];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                              2.0,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

- (void) setImageRightHorizontal:(UIImage *)image withTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)color forState:(UIControlState)stateType
{
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:font];
    [self setTitleColor:color forState:UIControlStateNormal];

    [self setTitle:title forState:stateType];
    
    self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    [self setImage:image forState:stateType];
}

- (void) setBackgroundView:(UIImage *)image withTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)color forState:(UIControlState)stateType
{
    [self setTitle:title forState:stateType];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setImage:image forState:stateType];
    [self.titleLabel setFont:font];
}

- (void) setBackgroundColor:(UIColor *)backgroundColor withTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)color forState:(UIControlState)stateType
{
    [self setTitle:title forState:stateType];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setBackgroundColor:backgroundColor];
    [self.titleLabel setFont:font];
}

@end
