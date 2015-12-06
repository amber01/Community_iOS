//
//  ModifyNicknameViewController.m
//  Community
//
//  Created by amber on 15/12/6.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "ModifyNicknameViewController.h"
#import "ModifyNicknameView.h"

@interface ModifyNicknameViewController ()
{
    ModifyNicknameView *modifyNicknameView;
}

@end

@implementation ModifyNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CELL_COLOR;
    self.title = @"修改用户名";
    
    modifyNicknameView = [[ModifyNicknameView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [modifyNicknameView.commitBtn addTarget:self action:@selector(modifyNicknameAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyNicknameView];
}

- (void)modifyNicknameAction
{
    if (modifyNicknameView.myTextField.text.length < 4) {
        [self initMBProgress:@"长度不能小于4个字符" withModeType:MBProgressHUDModeText afterDelay:1.0];
        return;
    }else if (modifyNicknameView.myTextField.text.length > 16){
        [self initMBProgress:@"长度不能大于16个字符" withModeType:MBProgressHUDModeText afterDelay:1.0];
        return;
    }
    
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *params = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":sharedInfo.user_id,@"Detail":@[@{@"ID":sharedInfo.user_id,@"NickName":modifyNicknameView.myTextField.text,@"IsShow":@"3"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
        if (result && [[result objectForKey:@"Success"]intValue] > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:modifyNicknameView.myTextField.text forKey:@"nickname"];
            sharedInfo.nickname = modifyNicknameView.myTextField.text;
            [[NSNotificationCenter defaultCenter]postNotificationName:kReloadDataNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
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

@end
