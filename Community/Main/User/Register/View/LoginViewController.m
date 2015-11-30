//
//  LoginViewController.m
//  Community
//
//  Created by amber on 15/11/19.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "RegisterViewController.h"
#import "EaseMob.h"

@interface LoginViewController ()
{
    LoginView *loginView;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = VIEW_COLOR;
    [self setupLoginView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark -- UI
- (void)setupLoginView
{
    loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [loginView.registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [loginView.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginView];
}

#pragma mark -- action
- (void)registAction
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [registerVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginAction
{
    if (loginView.phoneNumTextField.text.length < 11) {
        [self initMBProgress:@"手机号码格式错误" withModeType:MBProgressHUDModeText afterDelay:1.5];
        return;
    }else if (loginView.passwordTextField.text.length < 6){
        [self initMBProgress:@"密码不能少于6位" withModeType:MBProgressHUDModeText afterDelay:1.5];
        return;
    }
    
    NSDictionary *parameters = @{@"Method":@"ClientLogin",@"RunnerUserID":@"0",@"RunnerIP":@"",@"Detail":@[@{@"UserName":loginView.phoneNumTextField.text,@"Pwd":loginView.passwordTextField.text}]};
    [CKHttpRequest createRequest:HTTP_METHOD_LOGIN WithParam:parameters withMethod:@"POST" success:^(id result) {
        
        if (result && [[result objectForKey:@"Success"]intValue] > 0) {
            NSArray *userInfoArr = [result objectForKey:@"Detail"];
            
            NSLog(@"result:%@",result);
            
            for (int i = 0; i < userInfoArr.count; i ++) {
                
                NSDictionary *dic = [userInfoArr objectAtIndex:i];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"nickname"] forKey:@"nickname"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"mobile"] forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"username"] forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"id"] forKey:@"user_id"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"isshow"] forKey:@"isshow"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"isbbs"] forKey:@"isbbs"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"createtime"] forKey:@"createtime"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"address"] forKey:@"address"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"area"] forKey:@"area"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"city"] forKey:@"city"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"picture"] forKey:@"picture"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"myfansnum"] forKey:@"myfansnum"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"mytofansnum"] forKey:@"mytofansnum"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"postnum"] forKey:@"postnum"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"totalscore"] forKey:@"totalscore"];
                
                SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
                sharedInfo.user_id  = [dic objectForKey:@"id"];
                sharedInfo.nickname  = [dic objectForKey:@"nickname"];
                sharedInfo.mobile  = [dic objectForKey:@"username"];
                sharedInfo.username  = [dic objectForKey:@"username"];
                sharedInfo.area  = [dic objectForKey:@"area"];
                sharedInfo.address  = [dic objectForKey:@"address"];
                sharedInfo.createtime  = [dic objectForKey:@"createtime"];
                sharedInfo.picture = [dic objectForKey:@"picture"];
                sharedInfo.myfansnum = [dic objectForKey:@"myfansnum"];
                sharedInfo.mytofansnum = [dic objectForKey:@"mytofansnum"];
                sharedInfo.postnum = [dic objectForKey:@"postnum"];
                sharedInfo.totalscore = [dic objectForKey:@"totalscore"];
            }
            
            
            [self initMBProgress:@"登录成功" withModeType:MBProgressHUDModeText afterDelay:1];
            [[NSNotificationCenter defaultCenter]postNotificationName:kSendIsLoginNotification object:userInfoArr];
            [self performBlock:^{
                
                SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
                EaseMob *easemob = [EaseMob sharedInstance];
                //登陆时记住HuanXin密码
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:sharedInfo.username forKey:@"username"];
                [userDefaults setObject:@"123456" forKey:@"password"];
                [easemob.chatManager asyncLoginWithUsername:sharedInfo.username password:@"123456"];
                
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }else{
            [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
        }
    } failure:^(NSError *erro) {
        
    }];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
