
//
//  CheckMoreView.m
//  妈妈去哪儿
//
//  Created by shlity on 15/11/11.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "CheckMoreView.h"

@implementation CheckMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 9, 0, 18.5, 10)];
        imageView.image = [UIImage imageNamed:@"topic_topView.png"];
        [self addSubview:imageView];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, imageView.bottom, frame.size.width, frame.size.height)];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.8];
        [UIUtils setupViewRadius:bgView cornerRadius:4];
        
        self.latestSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _latestSendBtn.frame = CGRectMake(0, 0, bgView.width, bgView.height/3);
        [_latestSendBtn setTitle:@"最新发布" forState:UIControlStateNormal];
        _latestSendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [CommonClass setBorderWithView:_latestSendBtn top:NO left:NO bottom:YES right:NO borderColor:[UIColor colorWithHexString:@"#4a4a4a"] borderWidth:0.5];
        
        self.lastCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastCommentBtn.frame = CGRectMake(0, _latestSendBtn.bottom, bgView.width, bgView.height/3);
        [_lastCommentBtn setTitle:@"最后评论" forState:UIControlStateNormal];
        _lastCommentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [CommonClass setBorderWithView:_lastCommentBtn top:NO left:NO bottom:YES right:NO borderColor:[UIColor colorWithHexString:@"#4a4a4a"] borderWidth:0.5];

        
        self.lookGoodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookGoodBtn.frame = CGRectMake(0, _lastCommentBtn.bottom, bgView.width, bgView.height/3);
        _lookGoodBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_lookGoodBtn setTitle:@"最多评论" forState:UIControlStateNormal];

        
        [bgView addSubview:_latestSendBtn];
        [bgView addSubview:_lastCommentBtn];
        [bgView addSubview:_lookGoodBtn];
        [self addSubview:bgView];
    }
    return self;
}

@end
