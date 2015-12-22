//
//  WSJSObject.h
//  妈妈去哪儿
//
//  Created by shlity on 15/11/5.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import "WSJSObject.h"

@implementation WSJSObject

- (void)toTheme:(NSString *)theme
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toTheme:)]) {
        [self.delegate toTheme:theme];
    }
}

- (void)toWebUrl:(NSString *)url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toWebUrl:)]) {
        [self.delegate toWebUrl:url];
    }
}

- (void)toStartApp:(NSString *)url;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toStartApp:)]) {
        [self.delegate toStartApp:url];
    }
}

- (void)toShareWeiXin:(NSString *)jsonObject;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toShareWeiXin:)]) {
        [self.delegate toShareWeiXin:jsonObject];
    }
}

- (void)toShareSMS:(NSString *)jsonObject;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toShareSMS:)]) {
        [self.delegate toShareSMS:jsonObject];
    }
}

- (void)toLogin:(NSString *)login
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toLogin:)]) {
        [self.delegate toLogin:login];
    }
}

- (void)toFinsh
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toFinsh)]) {
        [self.delegate toFinsh];
    }
}

- (void)toShowImg:(NSString *)imageData
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toShowImg:)]) {
        [self.delegate toShowImg:imageData];
    }
}

- (void)toShowTitle:(NSString *)title
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toShowTitle:)]) {
        [self.delegate toShowTitle:title];
    }
}

- (void)toGoback
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toGoback)]) {
        [self.delegate toGoback];
    }
}


@end
