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
        [CommonClass setBorderWithView:self top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:1.0];
        
        self.friendSquareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _friendSquareBtn.frame = CGRectMake(0, 3, ScreenWidth/4, 40);
        [_friendSquareBtn setImage:[UIImage imageNamed:@"discover_friend_square_high.png"] withTitle:@"朋友圈" withFont:[UIFont systemFontOfSize:13] withTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [self addSubview:_friendSquareBtn];
        
        self.topicSquareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicSquareBtn.frame = CGRectMake(_friendSquareBtn.right, 3, ScreenWidth/4, 40);
        [_topicSquareBtn setImage:[UIImage imageNamed:@"discover_topic_normal.png"] withTitle:@"话题圈" withFont:[UIFont systemFontOfSize:13] withTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [self addSubview:_topicSquareBtn];
        
        self.findFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _findFriendBtn.frame = CGRectMake(_topicSquareBtn.right, 5, ScreenWidth/4, 40);
        [_findFriendBtn setImage:[UIImage imageNamed:@"discover_find_friend_normal.png"] withTitle:@"找朋友" withFont:[UIFont systemFontOfSize:13] withTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [self addSubview:_findFriendBtn];
        
        self.findTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _findTopicBtn.frame = CGRectMake(_findFriendBtn.right, 3, ScreenWidth/4, 40);
        [_findTopicBtn setImage:[UIImage imageNamed:@"discover_find_topic_normal.png"] withTitle:@"找话题" withFont:[UIFont systemFontOfSize:13] withTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [self addSubview:_findTopicBtn];
    }
    return self;
}

@end
