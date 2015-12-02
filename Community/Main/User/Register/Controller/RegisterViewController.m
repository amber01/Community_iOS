//
//  RegisterViewController.m
//  Community
//
//  Created by amber on 15/11/18.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    RegisterView *registerView;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = VIEW_COLOR;
    [self createRegisterView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)createRegisterView
{
    registerView = [[RegisterView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:registerView];
    registerView.phoneNumTextField.delegate = self;
    registerView.phoneNumTextField.tag = 1001;
    registerView.codeTextField.delegate = self;
    registerView.codeTextField.tag = 1002;
    registerView.passwordTextField.delegate = self;
    registerView.passwordTextField.tag = 1003;
    [registerView.registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [registerView.getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [registerView.phoneNumTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark -- action
- (void)getCodeAction{
 
    NSDictionary *params = @{@"Method":@"SendCMS",@"Detail":@[@{@"Mobile":registerView.phoneNumTextField.text}]};
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_CODE WithParam:params withMethod:@"POST" success:^(id result) {
        if (result && [[result objectForKey:@"Success"]intValue] > 0) {
            NSLog(@"result:%@",result);
            [self initMBProgress:@"验证码已发送" withModeType:MBProgressHUDModeText afterDelay:2];
        }else{
            [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
        }
    } failure:^(NSError *erro) {
        
    }];
}

- (void)registerAction{
    if (registerView.codeTextField.text.length < 1) {
        [self initMBProgress:@"请输入验证码" withModeType:MBProgressHUDModeText afterDelay:1];
        return;
    }else if  (registerView.phoneNumTextField.text.length < 11){
        [self initMBProgress:@"请输入正确的手机号" withModeType:MBProgressHUDModeText afterDelay:1];
        return;
    }else if (registerView.passwordTextField.text.length < 6){
        [self initMBProgress:@"密码不能小于6位" withModeType:MBProgressHUDModeText afterDelay:1];
        return;
    }
    
    NSDictionary *params = @{@"Method":@"AddUserInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":@"",@"Detail":@[@{@"Mobile":registerView.phoneNumTextField.text,@"PassWord":[UIUtils md5:registerView.passwordTextField.text],@"VerCode":registerView.codeTextField.text}]};
    NSLog(@"params:%@",params);
    
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
        if (result && [[result objectForKey:@"Success"]intValue] > 0) {
            NSLog(@"result:%@",result);
            [self initMBProgress:@"注册成功" withModeType:MBProgressHUDModeText afterDelay:1];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }else{
            [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
        }
    } failure:^(NSError *erro) {
        
    }];

}

#pragma mark -- delegate
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.tag == 1001) {
        if (textField.text.length >= 11) {
            registerView.getCodeBtn.enabled = YES;
            [registerView.getCodeBtn setBackgroundColor:BASE_COLOR];
        }else{
            registerView.getCodeBtn.enabled = YES;
            [registerView.getCodeBtn setBackgroundColor:TEXT_COLOR];
        }
    }
}

#pragma mark -- other
- (void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
