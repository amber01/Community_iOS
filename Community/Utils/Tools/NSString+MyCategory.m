//
//  NSString+MyCategory.m
//  GoddessClock
//
//  Created by wubing on 14-9-9.
//  Copyright (c) 2014年 iMac. All rights reserved.
//

#import "NSString+MyCategory.h"
#import "Commen.h"


@implementation NSString (MyCategory)

- (BOOL)hasSubString:(NSString *)string
{
    if (IOS_VERSION  < 8.0)
    {
       if ( [self rangeOfString:string].length >0)
       {
           return YES;
       }
    }else{
        if ([self containsString:string])
        {
            return YES;
        }
    }
    return NO;
}

+(BOOL)stringIsEmpty:(NSString *)aString shouldCleanWhiteSpace:(BOOL)cleanWhiteSpace
{
    if (!aString) {
        return YES;
    }
    if ((NSNull *)aString == [NSNull null] ) {
        return YES;
    }
    if ([aString length] == 0) {
        return YES;
    }
    if (cleanWhiteSpace) {
        aString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    return NO;
}
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,                                                                         (CFStringRef)self,                                                                     NULL,                                                                          CFSTR("!*'();:@&=+$,/?%#[]"),                                                                 kCFStringEncodingUTF8));
    return result;
}
- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,                                                                                           (CFStringRef)self,                                                                                       CFSTR(""),                                                                                       kCFStringEncodingUTF8));
    return result;
}

+ (NSString *)stringWithArab:(int)arab
{
    NSArray * array = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    return array[arab-1];
}

- (id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

/**
 *  替换斜杠方法
 *
 *  @param str
 *
 *  @return
 */
+ (NSString *) getOffRubbishWithString:(NSString *)str
{
    NSMutableString *responseString = [NSMutableString stringWithString:str];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    
    [responseString stringByReplacingOccurrencesOfString:@"\'" withString:@""];
    
    return responseString;
}

@end
