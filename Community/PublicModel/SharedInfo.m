//
//  SharedInfo.m
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//


#import "SharedInfo.h"

@implementation SharedInfo

+(SharedInfo *)sharedDataInfo
{
    static SharedInfo *shareInfo = nil;
    static dispatch_once_t predicate;
    if (!shareInfo) {
        dispatch_once(&predicate, ^{
            shareInfo = [[SharedInfo alloc]init];
        });
    }
    return shareInfo;
}

@end
