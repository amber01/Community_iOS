//
//  RegisterView.m
//  Community
//
//  Created by amber on 15/11/18.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, ScreenWidth - 30, 20)];
        tipsLabel.textColor = BASE_COLOR;
        tipsLabel.text = @"手机号可用于登录或重置密码";
        [tipsLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:tipsLabel];
        
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
        
        self.phoneNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, tipsLabel.bottom + 10, ScreenWidth, 45)];
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
        
        self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setBackgroundImage:[UIImage imageWithColor:BASE_COLOR] forState:UIControlStateNormal];
        _registerBtn.frame = CGRectMake(10, _passwordTextField.bottom + 15, ScreenWidth - 20,42);
        [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        [UIUtils setupViewRadius:_registerBtn cornerRadius:4];
        
        //summaryLabel
        self.summaryLabel= [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, _registerBtn.bottom + 5, ScreenWidth, 35)];
        _summaryLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        _summaryLabel.textColor = [UIColor blackColor];
        _summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _summaryLabel.numberOfLines = 0;
        [_summaryLabel setTextAlignment:NSTextAlignmentCenter];
        
        NSString *str = @"我已阅读并同意《立即注册》";
        @weakify(self)
        [_summaryLabel setText:str afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString  *(NSMutableAttributedString *mutableAttributedString) {
            CGSize textSize = [str sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            @strongify(self)
            /**
             *  大于这个宽度就换行
             */
            if (textSize.width >= ScreenWidth - 20) {
                [self.summaryLabel setTextAlignment:NSTextAlignmentLeft];
            }
            //设置文本的颜色
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"#64b300"] CGColor] range:NSMakeRange(7,6)];
            return mutableAttributedString;
        }];

        self.autoRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _autoRegisterBtn.frame = CGRectMake(10, _summaryLabel.bottom + 5, ScreenWidth - 20, 20);
        //[_autoRegisterBtn setTitle:@"一键注册" forState:UIControlStateNormal];
        _autoRegisterBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_autoRegisterBtn setTitleColor:[UIColor colorWithHexString:@"#64b300"] forState:UIControlStateNormal];
        
        //[self addSubview:_autoRegisterBtn];
        [self addSubview:_summaryLabel];
        [self addSubview:_registerBtn];
        [self addSubview:tipsLabel];
        [self addSubview:_phoneNumTextField];
        [self addSubview:_codeTextField];
        [self addSubview:_passwordTextField];
    }
    return self;
}

@end
