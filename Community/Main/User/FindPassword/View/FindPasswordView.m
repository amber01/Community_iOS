//
//  FindPasswordView.m
//  Community
//
//  Created by amber on 15/12/1.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "FindPasswordView.h"

@implementation FindPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *phoneLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 45)];
        UIView *codeLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 45)];
        UIView *passwordLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 45)];
        UIView *phoneRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 95, 45)];
        
        self.getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.getCodeBtn setBackgroundColor:TEXT_COLOR];
        [UIUtils setupViewRadius:self.getCodeBtn cornerRadius:4];
        self.getCodeBtn.frame = CGRectMake(0, 45/2 - 15, 85, 30);
        self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [phoneRightView addSubview:_getCodeBtn];
        
        self.phoneNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 45)];
        _phoneNumTextField.backgroundColor = [UIColor whiteColor];
        _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        [CommonClass setBorderWithView:_phoneNumTextField top:YES left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        _phoneNumTextField.rightView = phoneRightView;
        _phoneNumTextField.rightViewMode =UITextFieldViewModeAlways;
        _phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumTextField.leftViewMode=UITextFieldViewModeAlways;
        _phoneNumTextField.leftView = phoneLeftView;
        _phoneNumTextField.placeholder = @"手机号";
        
        self.codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, _phoneNumTextField.bottom, ScreenWidth, 45)];
        _codeTextField.backgroundColor = [UIColor whiteColor];
        _codeTextField.leftView = codeLeftView;
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.leftViewMode=UITextFieldViewModeAlways;
        _codeTextField.placeholder = @"验证码";
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, _codeTextField.bottom , ScreenWidth, 45)];
        _passwordTextField.backgroundColor = [UIColor whiteColor];
        _passwordTextField.leftView = passwordLeftView;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.leftViewMode=UITextFieldViewModeAlways;
        _passwordTextField.placeholder = @"密码(6~16位数字、字母)";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.keyboardType = UIKeyboardTypeEmailAddress;
        [CommonClass setBorderWithView:_codeTextField top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        [CommonClass setBorderWithView:_passwordTextField top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        
        self.modifyPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modifyPasswordBtn setBackgroundImage:[UIImage imageWithColor:BASE_COLOR] forState:UIControlStateNormal];
        _modifyPasswordBtn.frame = CGRectMake(10, _passwordTextField.bottom + 15, ScreenWidth - 20,42);
        [_modifyPasswordBtn setTitle:@"重置密码" forState:UIControlStateNormal];
        [UIUtils setupViewRadius:_modifyPasswordBtn cornerRadius:4];
        
        
        [self addSubview:_modifyPasswordBtn];
        [self addSubview:_phoneNumTextField];
        [self addSubview:_codeTextField];
        [self addSubview:_passwordTextField];
    }
    return self;
}


@end
