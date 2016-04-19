//
//  UILabel+TextDifferentColor.m
//  妈妈去哪儿
//
//  Created by shlity on 16/1/8.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "UILabel+TextDifferentColor.h"

@implementation UILabel (TextDifferentColor)

- (void)setTextColor:(UIColor *)textColor withText:(NSString *)keyword
{
//    NSAttributedString *str = [[NSAttributedString alloc]initWithString:self.text];
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:str];
//    [text addAttribute:NSForegroundColorAttributeName value:textColor range:[text.string rangeOfString:keyword]];
//    [self setAttributedText:text];
    
    if (![self respondsToSelector:@selector(setAttributedText:)])
    {
        return;
    }
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:keyword options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!error)
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self text]];
        NSArray *allMatches = [regex matchesInString:[self text] options:0 range:NSMakeRange(0, [[self text] length])];
        for (NSTextCheckingResult *aMatch in allMatches)
        {
            NSRange matchRange = [aMatch range];
            [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:matchRange];
        }
        [self setAttributedText:attributedString];
    }
}

- (void)setTextColor:(UIColor *)textColor range:(NSRange)range
{
    NSAttributedString *str = [[NSAttributedString alloc]initWithString:self.text];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:str];
    [text addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    [self setAttributedText:text];
}

- (void)setFont:(UIFont *)font range:(NSRange)range
{
    NSAttributedString *str = [[NSAttributedString alloc]initWithString:self.text];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:str];
    [text addAttribute:NSFontAttributeName value:font range:range];
    [self setAttributedText:text];
}

- (void)setTextColor:(UIColor *)textColor withFont:(UIFont *)font range:(NSRange)range
{
    NSAttributedString *str = [[NSAttributedString alloc]initWithString:self.text];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:str];
    [text addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    [text addAttribute:NSFontAttributeName value:font range:range];
    [self setAttributedText:text];
}

@end
