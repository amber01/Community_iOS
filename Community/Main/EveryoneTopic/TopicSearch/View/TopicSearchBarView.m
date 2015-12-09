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
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 25)];
        self.myTextField = [[UITextField alloc]initWithFrame:frame];
        [UIUtils setupViewRadius:self.myTextField cornerRadius:5];
        self.myTextField.placeholder = @"搜索内容或用户";
        _myTextField.font = [UIFont systemFontOfSize:14];
        _myTextField.backgroundColor = [UIColor whiteColor];
        _myTextField.leftView = leftView;
        _myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _myTextField.leftViewMode=UITextFieldViewModeAlways;
        [self addSubview:_myTextField];
    }
    
    return self;
}

@end
