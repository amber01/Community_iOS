//
//  CCTipsView.m
//  Community
//
//  Created by amber on 16/4/16.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "CCTipsView.h"

@implementation CCTipsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 30, 0, 60, 60)];
        imageView.image = [UIImage imageNamed:@"cc_default_tips"];
        [self addSubview:imageView];
        
        self.tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom + 15, ScreenWidth, 20)];
        _tipsLabel.textColor = TEXT_COLOR1;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [self addSubview:_tipsLabel];
    }
    return self;
}

@end
