//
//  TopicSearchBarView.m
//  Community
//
//  Created by amber on 15/12/9.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicSearchBarView.h"

@implementation TopicSearchBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, frame.size.height)];
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 19, 20)];
        leftImageView.image = [UIImage imageNamed:@"mine_tabbar_high"];
        self.myTextField = [[UITextField alloc]initWithFrame:frame];
        _myTextField.font = [UIFont systemFontOfSize:17];
        _myTextField.textColor = [UIColor whiteColor];
        UIColor *color = [UIColor whiteColor];
        _myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索内容或用户" attributes:@{NSForegroundColorAttributeName: color}];
        _myTextField.backgroundColor = [UIColor clearColor];
        [CommonClass setBorderWithView:_myTextField top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:1];
        _myTextField.leftView = leftView;
        _myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _myTextField.leftViewMode=UITextFieldViewModeAlways;
        [self addSubview:_myTextField];
    }
    
    return self;
}

@end
