//
//  LoginView.m
//  Community
//
//  Created by amber on 15/11/19.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, ScreenWidth - 30, 20)];
        tipsLabel.textColor = BASE_COLOR;
        tipsLabel.text = @"同城游用户可直接登录";
        [tipsLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:tipsLabel];
        
        UIView *phoneLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 45)];
        UIView *passwordLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 45)];
        
        UIImageView *userNameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,45/2 - 23/2, 44/2, 46/2)];
        userNameImageView.image = [UIImage imageNamed:@"mine_login_user"];
        [phoneLeftView addSubview:userNameImageView];
        
        UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45/2 - 23/2, 36/2, 46/2)];
        passwordImageView.image = [UIImage imageNamed:@"mine_login_password"];
        [passwordLeftView addSubview:passwordImageView];
        
        self.phoneNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, tipsLabel.bottom + 15, ScreenWidth, 45)];
        _phoneNumTextField.backgroundColor = [UIColor whiteColor];
        _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        [CommonClass setBorderWithView:_phoneNumTextField top:YES left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        _phoneNumTextField.rightViewMode =UITextFieldViewModeAlways;
        _phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumTextField.leftViewMode=UITextFieldViewModeAlways;
        _phoneNumTextField.leftView = phoneLeftView;
        _phoneNumTextField.placeholder = @"手机号";
        
        self.passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, _phoneNumTextField.bottom , ScreenWidth, 45)];
        _passwordTextField.backgroundColor = [UIColor whiteColor];
        _passwordTextField.leftView = passwordLeftView;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.leftViewMode=UITextFieldViewModeAlways;
        _passwordTextField.placeholder = @"密码(6~16位数字、字母)";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.keyboardType = UIKeyboardTypeEmailAddress;
        [CommonClass setBorderWithView:_passwordTextField top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(10, _passwordTextField.bottom + 15, ScreenWidth - 20, 40);
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [UIUtils setupViewRadius:_loginBtn cornerRadius:4];
        [_loginBtn setBackgroundImage:[UIImage imageWithColor:BASE_COLOR] forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        self.registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registBtn.frame = CGRectMake(0, _loginBtn.bottom + 15, ScreenWidth/2, 20);
        [_registBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
        _registBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_registBtn setTitleColor:[UIColor colorWithHexString:@"#64b300"] forState:UIControlStateNormal];
        
        self.findPassword = [UIButton buttonWithType:UIButtonTypeCustom];
        _findPassword.frame = CGRectMake(ScreenWidth/2, _loginBtn.bottom + 15, ScreenWidth/2, 20);
        [_findPassword setTitle:@"忘记密码?" forState:UIControlStateNormal];
        _findPassword.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_findPassword setTitleColor:[UIColor colorWithHexString:@"#64b300"] forState:UIControlStateNormal];
        
        [self addSubview:_findPassword];
        [self addSubview:_registBtn];
        [self addSubview:_loginBtn];
        [self addSubview:_phoneNumTextField];
        [self addSubview:_passwordTextField];
    }
    return self;
}

@end
