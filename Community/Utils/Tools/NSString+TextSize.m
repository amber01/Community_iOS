//
//  NSString+TextSize.m
//  妈妈去哪儿
//
//  Created by shlity on 15/11/5.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import "NSString+TextSize.h"

@implementation NSString (TextSize)

//返回字符串所占用的尺寸.

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
