//
//  ModifyPasswordViewController.m
//  Community
//
//  Created by amber on 15/12/6.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "ModifyNicknameView.h"

@interface ModifyPasswordViewController ()
{
    ModifyNicknameView *modifyNicknameView;
}

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CELL_COLOR;
    self.title = @"修改密码";
    
    modifyNicknameView = [[ModifyNicknameView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    modifyNicknameView.myTextField.placeholder = @"新密码，6~16位数字、字母";
    modifyNicknameView.myTextField.keyboardType = UIKeyboardTypeEmailAddress;
    modifyNicknameView.myTextField.secureTextEntry = YES;
    [modifyNicknameView.commitBtn addTarget:self action:@selector(modifyPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyNicknameView];
}

- (void)modifyPasswordAction
{
    if (modifyNicknameView.myTextField.text.length < 6) {
        [self initMBProgress:@"密码不能小于6位" withModeType:MBProgressHUDModeText afterDelay:1.0];
        return;
    }else if (modifyNicknameView.myTextField.text.length > 16){
        [self initMBProgress:@"密码不能大于16位" withModeType:MBProgressHUDModeText afterDelay:1.0];
        return;
    }
    
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *params = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":sharedInfo.user_id,@"Detail":@[@{@"ID":sharedInfo.user_id,@"PassWord":[UIUtils md5:modifyNicknameView.myTextField.text],@"IsShow":@"4"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {

        if (result && [[result objectForKey:@"Success"]intValue] > 0) {
            [self initMBProgress:@"修改成功" withModeType:MBProgressHUDModeText afterDelay:1.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.0];
            
        }else{
            [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.0];
        }
    } failure:^(NSError *erro) {
        
    }];
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
