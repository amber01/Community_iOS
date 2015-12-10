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
        
        self.backgroundColor = [UIColor whiteColor];
        [CommonClass setBorderWithView:self top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        //分隔栏视图
        NSArray *segmentedAarray = @[@"内容",@"用户"];
        self.segmentedView = [[UISegmentedControl alloc]initWithItems:segmentedAarray];
        _segmentedView.segmentedControlStyle= UISegmentedControlStyleBar;
        
        [_segmentedView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#555555"]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        [UIUtils setupViewBorder:_segmentedView cornerRadius:5 borderWidth:0.5 borderColor:[UIColor colorWithHexString:@"#555555"]];
        _segmentedView.tintColor= [UIColor colorWithHexString:@"#555555"];
        _segmentedView.selectedSegmentIndex = 0;
        _segmentedView.frame = CGRectMake(15, 6, ScreenWidth - 30, 30);
        
        //文字大小
        UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
        [_segmentedView setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        [self addSubview:_segmentedView];
        
    }
    return self;
}

@end
