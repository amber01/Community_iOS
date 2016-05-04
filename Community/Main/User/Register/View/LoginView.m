//
//  LoginView.m
//  Community
//
//  Created by amber on 15/11/19.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "LoginView.h"
#import "RegisterViewController.h"


@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 21, (110 * scaleToScreenHeight) / 2 - 15, 42, 30.5)];
        imageView.image = [UIImage imageNamed:@"mac_wenzhou_logo"];
        [self addSubview:imageView];
        
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 110 * scaleToScreenHeight, ScreenWidth/2, 45)];
        phoneLabel.backgroundColor = [UIColor whiteColor];
        [phoneLabel setText:@"手机号登录"];
        phoneLabel.textColor = [UIColor grayColor];
        phoneLabel.font = [UIFont systemFontOfSize:14];
        phoneLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:phoneLabel];
        
        UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(phoneLabel.right, phoneLabel.top, phoneLabel.width, phoneLabel.height)];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [registerBtn setBackgroundImage:[UIImage imageWithColor:LINE_COLOR] forState:UIControlStateNormal];
        registerBtn.titleLabel.font = kFont(14);
        [registerBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
        [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        [self addSubview:registerBtn];
        
        UIView *phoneLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 45)];
        UIView *passwordLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 45)];
        
        UIImageView *userNameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,45/2 - 23/2, 44/2, 46/2)];
        userNameImageView.image = [UIImage imageNamed:@"mine_login_user"];
        [phoneLeftView addSubview:userNameImageView];
        
        UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45/2 - 23/2, 36/2, 46/2)];
        passwordImageView.image = [UIImage imageNamed:@"mine_login_password"];
        [passwordLeftView addSubview:passwordImageView];
        
        
        self.phoneNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, phoneLabel.bottom, ScreenWidth, 50)];
        _phoneNumTextField.backgroundColor = [UIColor whiteColor];
        _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        [CommonClass setBorderWithView:_phoneNumTextField top:YES left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        _phoneNumTextField.rightViewMode =UITextFieldViewModeAlways;
        _phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumTextField.leftViewMode=UITextFieldViewModeAlways;
        _phoneNumTextField.leftView = phoneLeftView;
        _phoneNumTextField.placeholder = @"手机号";
        
        self.passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, _phoneNumTextField.bottom , ScreenWidth, 50)];
        _passwordTextField.backgroundColor = [UIColor whiteColor];
        _passwordTextField.leftView = passwordLeftView;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.leftViewMode=UITextFieldViewModeAlways;
        _passwordTextField.placeholder = @"密码(6~16位数字、字母)";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.keyboardType = UIKeyboardTypeEmailAddress;
        [CommonClass setBorderWithView:_passwordTextField top:NO left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        

        self.findPassword = [UIButton buttonWithType:UIButtonTypeCustom];
        _findPassword.frame = CGRectMake(0, _passwordTextField.bottom + 15, 100, 20);
        [_findPassword setTitle:@"忘记密码?" forState:UIControlStateNormal];
        _findPassword.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_findPassword setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _findPassword.bottom + 40, ScreenWidth, 1)];
        lineView.backgroundColor = LINE_COLOR;
        [self addSubview:lineView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 75, _findPassword.bottom+30, 150, 20)];
        label.backgroundColor = VIEW_COLOR;
        label.font = kFont(16);
        label.text = @"第三方账号登录";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        self.qqLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth/2 - 30) - 60, lineView.bottom + 30, 60, 60)];
        [_qqLoginBtn setBackgroundImage:[UIImage imageNamed:@"login_qq_btn.png"] forState:UIControlStateNormal];
        [self addSubview:_qqLoginBtn];
        
        self.weiChatBtn = [[UIButton alloc]initWithFrame:CGRectMake(_qqLoginBtn.right + 60, lineView.bottom + 30, 60, 60)];
        [_weiChatBtn setBackgroundImage:[UIImage imageNamed:@"login_weiChat_btn.png"] forState:UIControlStateNormal];
        [self addSubview:_weiChatBtn];
        
        [self addSubview:_findPassword];
        [self addSubview:_phoneNumTextField];
        [self addSubview:_passwordTextField];
        
        self.alwaysBounceVertical = YES;  //默认可以上下滚动
        
        self.contentSize = CGSizeMake(ScreenWidth, _weiChatBtn.bottom + 150);
    }
    return self;
}

#pragma makr -- action
- (void)registAction
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [registerVC setHidesBottomBarWhenPushed:YES];
    [self.viewController.navigationController pushViewController:registerVC animated:NO];
}




@end
