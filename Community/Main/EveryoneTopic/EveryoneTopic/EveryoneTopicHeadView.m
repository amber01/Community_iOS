//
//  EveryoneTopicHeadView.m
//  Community
//
//  Created by amber on 15/11/22.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "EveryoneTopicHeadView.h"

@implementation EveryoneTopicHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
        [CommonClass setBorderWithView:lineView top:YES left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        
        UIView *headInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, lineView.bottom, ScreenWidth, 40)];
        headInfoView.backgroundColor = [UIColor whiteColor];
        [CommonClass setBorderWithView:headInfoView top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        
        self.lastTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40/2 - 10, 200, 20)];
        _lastTimeLabel.textColor = [UIColor grayColor];
        _lastTimeLabel.font = [UIFont systemFontOfSize:14];
        _lastTimeLabel.text = @"最后刷新:11-12 23:12";
        
        self.sendCatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendCatBtn.frame = CGRectMake(ScreenWidth - 100, 0, 90, 40);
        self.sendTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 40/2-10, 80, 20)];
        _sendTitle.textColor = [UIColor grayColor];
        _sendTitle.font = [UIFont systemFontOfSize:15];
        _sendTitle.text = @"最新发布";
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_sendCatBtn.width - 15, 40/2-3, 11, 6)];
        imageView.image = [UIImage imageNamed:@"everyoneTopic_send_down"];
        
        [_sendCatBtn addSubview:imageView];
        [_sendCatBtn addSubview:_sendTitle];
        [headInfoView addSubview:_sendCatBtn];
        [headInfoView addSubview:_lastTimeLabel];
        [self addSubview:lineView];
        [self addSubview:headInfoView];
    }
    return self;
}

@end
