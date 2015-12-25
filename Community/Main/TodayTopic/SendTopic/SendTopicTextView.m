//
//  SendTopicTextView.m
//  Community
//
//  Created by amber on 15/11/10.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "SendTopicTextView.h"

@implementation SendTopicTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
        self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        _titleTextField.placeholder = @"标题（选填）";
        _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _titleTextField.leftView = leftView;
        _titleTextField.font = [UIFont systemFontOfSize:15];
        _titleTextField.backgroundColor = [UIColor whiteColor];
        _titleTextField.leftViewMode = UITextFieldViewModeAlways;
        [CommonClass setBorderWithView:_titleTextField top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        [self addSubview:_titleTextField];
        
        self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, _titleTextField.bottom, frame.size.width - 10, 90)];//34
        
        _contentTextView.returnKeyType = UIReturnKeyDefault;
        _contentTextView.keyboardType = UIKeyboardTypeDefault;
        _contentTextView.scrollEnabled = YES;
        _contentTextView.delegate = self;
        _contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_contentTextView setFont:[UIFont systemFontOfSize:15.0f]];
        
        self.defaultLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 7, 200, 20)];
        _defaultLabel.textColor = [UIColor lightGrayColor];
        [_defaultLabel setFont:[UIFont systemFontOfSize:15.0f]];
        _defaultLabel.text = @"分享新鲜事...";
        [_contentTextView addSubview:_defaultLabel];
        [self addSubview:_contentTextView];
    }
    return self;
}


@end
