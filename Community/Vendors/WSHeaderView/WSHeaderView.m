//
//  WSHeaderView
//  CustomNavignonSimple
//
//  Created by shlity on 15/7/27.
//  Copyright (c) 2015年 shlity. All rights reserved.
//


#define WS_TABLE_HEADER_HEIGHT 263
#define WS_NAVIGATION_HEIGHT 64
#define kHeaderViewContentOffset @"contentOffset"

#import "WSHeaderView.h"

@implementation WSHeaderView{
    CGFloat _expandHeight;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (id)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView{
    WSHeaderView *expandHeader = [WSHeaderView new];
    [expandHeader expandWithScrollView:scrollView expandView:expandView];
    return expandHeader;
}

- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView{
    
    
    _expandHeight = CGRectGetHeight(expandView.frame);
    
    _scrollView = scrollView;
    _scrollView.contentInset = UIEdgeInsetsMake(_expandHeight, 0, 0, 0);
    [_scrollView insertSubview:expandView atIndex:0];
    [_scrollView addObserver:self forKeyPath:kHeaderViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView setContentOffset:CGPointMake(0, - WS_TABLE_HEADER_HEIGHT)];

    _expandView = expandView;
    
    _expandView.contentMode= UIViewContentModeScaleAspectFill;
    _expandView.clipsToBounds = YES;
    
    [self reSizeView];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (![keyPath isEqualToString:kHeaderViewContentOffset]) {
        return;
    }
    [self scrollViewDidScroll:_scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < _expandHeight * -1) {
        CGRect currentFrame = _expandView.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = -1*offsetY;
        _expandView.frame = currentFrame;
    }
}

- (void)reSizeView{
    [_expandView setFrame:CGRectMake(0, -1*_expandHeight, CGRectGetWidth(_expandView.frame), _expandHeight)];
}

- (void)dealloc{
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:kHeaderViewContentOffset];
        _scrollView = nil;
    }
    _expandView = nil;
}

- (void)backAction
{
    NSLog(@"action");
}

@end
