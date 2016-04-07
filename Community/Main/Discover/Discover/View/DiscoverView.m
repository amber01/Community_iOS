//
//  DiscoverView.m
//  Community
//
//  Created by shlity on 16/4/6.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverView.h"

@implementation DiscoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [CommonClass setBorderWithView:self top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        
        NSArray *imageArray = @[@"discover_friend_square_high.png",
                                @"discover_topic_normal.png",
                                @"discover_find_friend_normal.png",
                                @"discover_find_topic_normal.png"];
        NSArray *titleArray = @[@"朋友圈",@"话题圈",@"找朋友",@"找话题"];
        
        for (int i = 0; i < titleArray.count; i ++) {
            self.topTabbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _topTabbarBtn.frame = CGRectMake((ScreenWidth/4) * i, 3, ScreenWidth/4, 40);
            _topTabbarBtn.tag = i + 200;
            [_topTabbarBtn setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] withTitle:[titleArray objectAtIndex:i] withFont:[UIFont systemFontOfSize:13] withTitleColor:TEXT_COLOR1 forState:UIControlStateNormal];
            if (i == 0) {
                [_topTabbarBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
            }
            [self addSubview:_topTabbarBtn];
        }
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-2.5, ScreenWidth/4, 2)];
        _lineView.backgroundColor = BASE_COLOR;
        [self addSubview:_lineView];
    }
    return self;
}

@end
