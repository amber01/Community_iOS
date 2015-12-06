//
//  ModifyNicknameView.m
//  Community
//
//  Created by amber on 15/12/6.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "ModifyNicknameView.h"

@implementation ModifyNicknameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CELL_COLOR;
        UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, ScreenWidth, 42)];
        textView.backgroundColor = [UIColor whiteColor];
        [CommonClass setBorderWithView:textView top:YES left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        
        self.myTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 42)];
        _myTextField.backgroundColor = [UIColor clearColor];
        _myTextField.placeholder = @"4~16个字符，中文算2个字符";
        _myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _myTextField.font = [UIFont systemFontOfSize:15];
        _myTextField.leftViewMode = UITextFieldViewModeAlways;
        [textView addSubview:_myTextField];
        
        self.commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.frame = CGRectMake(10, textView.bottom + 30, ScreenWidth - 20, 42);
        [UIUtils setupViewRadius:_commitBtn cornerRadius:4];
        [_commitBtn setBackgroundImage:[UIImage imageWithColor:BASE_COLOR] forState:UIControlStateNormal];
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        
        [self addSubview:_commitBtn];
        [self addSubview:textView];
    }
    return self;
}

@end
