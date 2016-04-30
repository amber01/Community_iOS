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
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 30, 0, 60, 60)];
        _imageView.image = [UIImage imageNamed:@"cc_default_tips"];
        [self addSubview:_imageView];
        
        self.tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.bottom + 15, ScreenWidth, 20)];
        _tipsLabel.textColor = TEXT_COLOR1;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [self addSubview:_tipsLabel];
        
        self.onClickBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, _tipsLabel.bottom +30, ScreenWidth - 20, 44)];
        [UIUtils setupViewRadius:_onClickBtn cornerRadius:4];
        _onClickBtn.hidden = YES;
        [_onClickBtn setBackgroundImage:[UIImage imageWithColor:BASE_COLOR] forState:UIControlStateNormal];
        [self addSubview:_onClickBtn];
    }
    return self;
}

@end
