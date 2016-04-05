//
//  UILabel+VerticalUpAlignment.m
//  妈妈去哪儿
//
//  Created by shlity on 15/9/2.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import "UILabel+VerticalUpAlignment.h"

@implementation UILabel (VerticalUpAlignment)

- (void)verticalUpAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight
{
    CGRect frame = self.frame;
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    CGSize size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(frame.size.width, maxHeight)];
    frame.size = CGSizeMake(frame.size.width, size.height);
    self.frame = frame;
    self.text = text;
}

@end
