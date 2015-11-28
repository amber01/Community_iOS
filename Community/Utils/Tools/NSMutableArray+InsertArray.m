//
//  NSMutableArray+InsertArray.m
//  妈妈去哪儿
//
//  Created by shlity on 15/10/30.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import "NSMutableArray+InsertArray.h"

@implementation NSMutableArray (InsertArray)

- (void)insertArray:(NSArray *)newAdditions atIndex:(NSUInteger)index
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for(int i = (int)index;i < newAdditions.count+index;i++)
    {
        [indexes addIndex:i];
    }
    [self insertObjects:newAdditions atIndexes:indexes];
}

@end
