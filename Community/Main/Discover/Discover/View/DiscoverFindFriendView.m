//
//  DiscoverFindFriendView.m
//  Community
//
//  Created by shlity on 16/4/19.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverFindFriendView.h"

@implementation DiscoverFindFriendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        view.backgroundColor = VIEW_COLOR;
        [self addSubview:view];
        
        self.searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, ScreenWidth - 10, 30)];
        [UIUtils setupViewBorder:_searchBtn cornerRadius:5 borderWidth:0.5 borderColor:LINE_COLOR];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = kFont(14);
        _searchBtn.backgroundColor = [UIColor whiteColor];
        [_searchBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [view addSubview:_searchBtn];
        
        self.distanceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, view.bottom + 5, 50, 25)];
        [_distanceBtn setTitle:@"附近" forState:UIControlStateNormal];
        _distanceBtn.titleLabel.font = kFont(14);
        [_distanceBtn setTitleColor:TEXT_COLOR2 forState:UIControlStateNormal];
        [self addSubview:_distanceBtn];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(_distanceBtn.left, _distanceBtn.bottom, _distanceBtn.width, 2)];
        _lineView.backgroundColor = BASE_COLOR;
        [self addSubview:_lineView];
        
        self.activeBtn = [[UIButton alloc]initWithFrame:CGRectMake(_distanceBtn.right, view.bottom + 5, 50, 25)];
        [_activeBtn setTitle:@"活跃" forState:UIControlStateNormal];
        _activeBtn.titleLabel.font = kFont(14);
        [_activeBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [self addSubview:_activeBtn];
    }
    return self;
}

@end
