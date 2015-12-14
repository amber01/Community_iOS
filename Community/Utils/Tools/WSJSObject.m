//
//  WSJSObject.h
//  妈妈去哪儿
//
//  Created by shlity on 15/11/5.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import "WSJSObject.h"

@implementation WSJSObject

- (void)exitNowPage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(exitNowPage)]) {
        [self.delegate exitNowPage];
    }
}

- (void)toGoodsPage:(NSString *)goodsId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toGoodsPage:)]) {
        [self.delegate toGoodsPage:goodsId];
    }
}

- (void)toStorePage:(NSString *)storeId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toStorePage:)]) {
        [self.delegate toStorePage:storeId];
    }
}

-(void)showRight:(int)btnIndex TextBtn:(NSString *)title
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRight:TextBtn:)]) {
        [self.delegate showRight:btnIndex TextBtn:title];
    }
}

- (void)makeLoading:(int)isShow
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeLoading:)]) {
        [self.delegate makeLoading:isShow];
    }
}

- (void)sendAgree:(int)isAgree
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendAgree:)]) {
        [self.delegate sendAgree:isAgree];
    }
}

- (void)toCatePage:(NSString *)cateId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toCatePage:)]) {
        [self.delegate toCatePage:cateId];
    }
}

- (void)toCommonUrl:(NSString *)url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toCommonUrl:)]) {
        [self.delegate toCommonUrl:url];
    }
}

@end
