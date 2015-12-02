//
//  FindPasswordViewController.m
//  Community
//
//  Created by amber on 15/12/1.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "FindPasswordView.h"

@interface FindPasswordViewController ()<UITextFieldDelegate>
{
    FindPasswordView *findPasswordView;
}

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    [self createFindPasswordView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)createFindPasswordView
{
    findPasswordView = [[FindPasswordView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:findPasswordView];
    findPasswordView.phoneNumTextField.delegate = self;
    findPasswordView.phoneNumTextField.tag = 1001;
    findPasswordView.codeTextField.delegate = self;
    findPasswordView.codeTextField.tag = 1002;
    findPasswordView.passwordTextField.delegate = self;
    findPasswordView.passwordTextField.tag = 1003;
    [findPasswordView.modifyPasswordBtn addTarget:self action:@selector(modifyPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [findPasswordView.getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [findPasswordView.phoneNumTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark -- action
- (void)getCodeAction{
    
    NSDictionary *params = @{@"Method":@"SendCMS",@"Detail":@[@{@"Mobile":findPasswordView.phoneNumTextField.text}]};
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

- (void)modifyPasswordAction{
    if (findPasswordView.codeTextField.text.length < 1) {
        [self initMBProgress:@"请输入验证码" withModeType:MBProgressHUDModeText afterDelay:1];
        return;
    }else if  (findPasswordView.phoneNumTextField.text.length < 11){
        [self initMBProgress:@"请输入正确的手机号" withModeType:MBProgressHUDModeText afterDelay:1];
        return;
    }else if (findPasswordView.passwordTextField.text.length < 6){
        [self initMBProgress:@"密码不能小于6位" withModeType:MBProgressHUDModeText afterDelay:1];
        return;
    }
    
    NSDictionary *params = @{@"Method":@"FindPassWord",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":@"",@"Detail":@[@{@"Mobile":findPasswordView.phoneNumTextField.text,@"PassWord":[UIUtils md5:findPasswordView.passwordTextField.text],@"VerCode":findPasswordView.codeTextField.text}]};
    NSLog(@"params:%@",params);
    
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
        if (result && [[result objectForKey:@"Success"]intValue] > 0) {
            NSLog(@"result:%@",result);
            [self initMBProgress:@"密码重置成功，请登录" withModeType:MBProgressHUDModeText afterDelay:1];
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
            findPasswordView.getCodeBtn.enabled = YES;
            [findPasswordView.getCodeBtn setBackgroundColor:BASE_COLOR];
        }else{
            findPasswordView.getCodeBtn.enabled = YES;
            [findPasswordView.getCodeBtn setBackgroundColor:TEXT_COLOR];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
