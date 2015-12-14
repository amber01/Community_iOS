//
//  TopicDetailView.m
//  Community
//
//  Created by amber on 15/12/12.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicDetailView.h"

@implementation TopicDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth - 30, 20)];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_titleLabel];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _titleLabel.bottom + 15, ScreenWidth-20, 30)];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
    }
    
    return self;
}


@end
