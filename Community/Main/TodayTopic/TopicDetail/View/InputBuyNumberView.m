//
//  InputBuyNumberView.m
//  妈妈去哪儿
//
//  Created by shlity on 15/12/21.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "InputBuyNumberView.h"

@implementation InputBuyNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.2];
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(50, ScreenHeight / 2 - 80 - 20, ScreenWidth - 100, 165)];
        _alertView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        _alertView.layer.cornerRadius = 8;
        _alertView.clipsToBounds = YES;
        
        self.myScoreNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15,_alertView.width, 20)];
        _myScoreNumLabel.textAlignment = NSTextAlignmentCenter;
        _myScoreNumLabel.text = @"我的积分：23";
        
        self.scoreNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _myScoreNumLabel.bottom + 10,_alertView.width, 20)];
        _scoreNumLabel.textAlignment = NSTextAlignmentCenter;
        _scoreNumLabel.textColor = [UIColor orangeColor];
        _scoreNumLabel.text = @"23";
        
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _scoreNumLabel.bottom + 15, 30, 20)];
        _leftLabel.text = @"1";
        
        self.mySlider = [[UISlider alloc]initWithFrame:CGRectMake(_leftLabel.right,  _scoreNumLabel.bottom + 15, _alertView.width - 85, 20)];
        _mySlider.minimumTrackTintColor = [UIColor orangeColor];
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(_mySlider.right + 10, _scoreNumLabel.bottom + 15, 40, 20)];
        _mySlider.minimumValue = 1;
        _rightLabel.text = @"221";
        
        self.returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnBtn.frame = CGRectMake(0, _alertView.height - 44,_alertView.width/2, 44);
        [_returnBtn setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
        [_returnBtn setTitle:@"打赏" forState:UIControlStateNormal];
        [_returnBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _returnBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(_returnBtn.right, _alertView.height - 44, _alertView.width/2, 44);
        [_cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [CommonClass setBorderWithView:_returnBtn top:YES left:NO bottom:YES right:YES borderColor:LINE_COLOR borderWidth:0.5];
        [CommonClass setBorderWithView:_cancelBtn top:YES left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        
        [_alertView addSubview:_rightLabel];
        [_alertView addSubview:_mySlider];
        [_alertView addSubview:_leftLabel];
        [_alertView addSubview:_myScoreNumLabel];
        [_alertView addSubview:_scoreNumLabel];
        [_alertView addSubview:_cancelBtn];
        [_alertView addSubview:_returnBtn];
        [bgView addSubview:_alertView];
        
        [self addSubview:bgView];
    }
    return self;
}


@end

