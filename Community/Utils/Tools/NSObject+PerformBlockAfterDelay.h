//
//  NSObject+PerformBlockAfterDelay.h
//  妈妈去哪儿
//
//  Created by shlity on 15/10/13.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlockAfterDelay)

//让某个方法延时执行
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
