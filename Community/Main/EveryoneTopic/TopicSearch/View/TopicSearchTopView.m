//
//  TopicSearchTopView.m
//  Community
//
//  Created by amber on 15/12/9.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicSearchTopView.h"

@implementation TopicSearchTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = VIEW_COLOR;
        self.searchContentBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/3 - 48, 60, 64, 64)];
        [_searchContentBtn setImage:[UIImage imageNamed:@"topic_search_content.png"] forState:UIControlStateNormal];
        [self addSubview:_searchContentBtn];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_searchContentBtn.left, _searchContentBtn.bottom + 20, _searchContentBtn.width, 20)];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.font = kFont(15);
        contentLabel.text = @"内容";
        contentLabel.textColor = TEXT_COLOR2;
        [self addSubview:contentLabel];
        
        self.searchUserBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - _searchContentBtn.left - 64, 60, 64, 64)];
        [_searchUserBtn setImage:[UIImage imageNamed:@"topic_search_user.png"] forState:UIControlStateNormal];
        [self addSubview:_searchUserBtn];
        
        UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(_searchUserBtn.left, _searchUserBtn.bottom + 20, _searchUserBtn.width, 20)];
        userLabel.textAlignment = NSTextAlignmentCenter;
        userLabel.font = kFont(15);
        userLabel.text = @"用户";
        userLabel.textColor = TEXT_COLOR2;
        [self addSubview:userLabel];
    }
    return self;
}

@end
