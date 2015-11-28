//
//  NSString+MyCategory.h
//  GoddessClock
//
//  Created by wubing on 14-9-9.
//  Copyright (c) 2014年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MyCategory)

- (BOOL)hasSubString:(NSString *)string;

+(BOOL)stringIsEmpty:(NSString *)aString shouldCleanWhiteSpace:(BOOL)cleanWhiteSpace;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

+ (NSString *)stringWithArab:(int)arab;

-(id)JSONValue;

+ (NSString *) getOffRubbishWithString:(NSString *)str;

@end
