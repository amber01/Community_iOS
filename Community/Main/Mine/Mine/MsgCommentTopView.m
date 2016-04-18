
//
//  MineCommentTopView.m
//  Community
//
//  Created by amber on 15/11/26.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MsgCommentTopView.h"

@implementation MsgCommentTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [CommonClass setBorderWithView:self top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        
        self.myReceiveCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _myReceiveCommentBtn.frame = CGRectMake(0, 0, ScreenWidth/2, frame.size.height);
        [_myReceiveCommentBtn setTitle:@"我收到的" forState:UIControlStateNormal];
        _myReceiveCommentBtn.titleLabel.font = kFont(16);
        [_myReceiveCommentBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [self addSubview:_myReceiveCommentBtn];
        
        self.mySendCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mySendCommentBtn.frame = CGRectMake(_myReceiveCommentBtn.right, 0, ScreenWidth/2, frame.size.height);
        [_mySendCommentBtn setTitle:@"我发出的" forState:UIControlStateNormal];
        _mySendCommentBtn.titleLabel.font = kFont(16);
        [_mySendCommentBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [self addSubview:_mySendCommentBtn];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 2, ScreenWidth/2, 2)];
        _lineView.backgroundColor = BASE_COLOR;
        [self addSubview:_lineView];
        
        
//        //分隔栏视图
//        NSArray *segmentedAarray = @[@"我收到的",@"我发出的"];
//        self.segmentedView = [[UISegmentedControl alloc]initWithItems:segmentedAarray];
//        _segmentedView.segmentedControlStyle= UISegmentedControlStyleBar;
//        
//        [_segmentedView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [_segmentedView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#555555"]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//        
//        [UIUtils setupViewBorder:_segmentedView cornerRadius:5 borderWidth:0.5 borderColor:[UIColor colorWithHexString:@"#555555"]];
//        _segmentedView.tintColor= [UIColor colorWithHexString:@"#555555"];
//        _segmentedView.selectedSegmentIndex = 0;
//        _segmentedView.frame = CGRectMake(15, 6, ScreenWidth - 30, 30);
//        
//        //文字大小
//        UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
//        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
//        [_segmentedView setTitleTextAttributes:attributes forState:UIControlStateNormal];
//        
//        [self addSubview:_segmentedView];
        
    }
    return self;
}

@end
