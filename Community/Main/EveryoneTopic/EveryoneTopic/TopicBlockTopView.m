//
//  TopicBlockTopView.m
//  Community
//
//  Created by amber on 15/11/28.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicBlockTopView.h"
#import "EveryoneTopicHeadView.h"

@implementation TopicBlockTopView

- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *topicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 45, 45)];
        topicImageView.image = [UIImage imageNamed:imageName];
        [self addSubview:topicImageView];
        
        self.topicHeadView = [[EveryoneTopicHeadView alloc]initWithFrame:CGRectMake(0, 45+15+15, ScreenWidth, 10)];
        self.blockNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(topicImageView.right + 10, 17, ScreenWidth - _topicHeadView.width + 20 + 50, 20)];
        
        self.topicNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(topicImageView.right + 10, _blockNameLabel.bottom + 5, (ScreenWidth - topicImageView.width - 20)/2, 20)];
        _topicNumberLabel.textColor = [UIColor grayColor];
        _topicNumberLabel.font = [UIFont systemFontOfSize:15];
        _topicNumberLabel.text = @"总帖数：0";
        
        self.todayNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_topicNumberLabel.right + 15, _blockNameLabel.bottom + 5, (ScreenWidth - topicImageView.width - 20)/2, 20)];
        _todayNumberLabel.textColor = [UIColor grayColor];
        _todayNumberLabel.font = [UIFont systemFontOfSize:15];
        _todayNumberLabel.text = @"今日：0";
        
        [self addSubview:_blockNameLabel];
        [self addSubview:_todayNumberLabel];
        [self addSubview:_topicNumberLabel];
        [self addSubview:_topicHeadView];
        
    }
    return self;
}

@end
