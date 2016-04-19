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
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, frame.size.height)];
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 19, 20)];
        leftImageView.image = [UIImage imageNamed:@"mine_tabbar_high"];
        [leftImageView imageWithColor:[UIColor whiteColor]];
        [leftView addSubview:leftImageView];
        
        self.cleaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cleaBtn.frame = CGRectMake(-4, 0,20,20);
        [_cleaBtn setImage:[UIImage imageNamed:@"topic_search_close.png"]forState:UIControlStateNormal];
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, _cleaBtn.frame.size.height)];
        [rightView addSubview:_cleaBtn];

        self.myTextField = [[UITextField alloc]initWithFrame:frame];
        _myTextField.font = [UIFont systemFontOfSize:17];
        _myTextField.textColor = [UIColor whiteColor];
        UIColor *color = [UIColor whiteColor];
        
        //改变Placeholder的颜色
        _myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索内容" attributes:@{NSForegroundColorAttributeName: color}];
        _myTextField.backgroundColor = [UIColor clearColor];
        _myTextField.returnKeyType = UIReturnKeySearch;
        [CommonClass setBorderWithView:_myTextField top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:1];
        _myTextField.leftView = leftView;
        _myTextField.rightView = rightView;
        //_myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _myTextField.leftViewMode = UITextFieldViewModeAlways;
        _myTextField.rightViewMode = UITextFieldViewModeAlways;
        [self addSubview:_myTextField];
    }
    
    return self;
}

@end
