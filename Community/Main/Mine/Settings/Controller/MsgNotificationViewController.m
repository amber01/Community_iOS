//
//  MsgNotificationViewController.m
//  Community
//
//  Created by shlity on 15/12/17.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MsgNotificationViewController.h"
#import "MsgNotificationTableViewCell.h"

@interface MsgNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView   *tableView;

@end

@implementation MsgNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息推送";
    [self setupTableView];
}

#pragma mark -- UI
- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    NSArray *titleArray = @[@"评论、新粉丝",@"私信",@"热点内容"];
    MsgNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    
    if (!cell) {
        cell = [[MsgNotificationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        
        [cell.msgSwitch addTarget:self action:@selector(isCommentChange:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ismessagepush"]intValue] > 0) {
            cell.msgSwitch.on = YES;
        }else{
            cell.msgSwitch.on = NO;
        }
    }else if (indexPath.row == 1){
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isbbs"]intValue] > 0) {
            cell.msgSwitch.on = YES;
        }else{
            cell.msgSwitch.on = NO;
        }
        
        [cell.msgSwitch addTarget:self action:@selector(isMsgChange:) forControlEvents:UIControlEventValueChanged];
    }else{
        [cell.msgSwitch addTarget:self action:@selector(isHotContentChange:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ishotnews"]intValue] > 0) {
            cell.msgSwitch.on = YES;
        }else{
            cell.msgSwitch.on = NO;
        }
    }
    
    cell.textLabel.text = titleArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- action
- (void)isCommentChange:(UISwitch *)msgSwitch
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"1",@"RunnerIsClient":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"RunnerUserID":@"",@"Detail":@[@{@"ID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"IsBBS":@(msgSwitch.isOn),@"IsShow":@"6"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:parameters withMethod:@"POST" success:^(id result) {
        if (result) {
            NSLog(@"result:%@",result);
            NSLog(@"result:%@",[result objectForKey:@"Msg"]);
        }
    } failure:^(NSError *erro) {
        
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(msgSwitch.isOn) forKey:@"ismessagepush"];
    
    
    NSLog(@"isOn1:%d",msgSwitch.isOn);
}

- (void)isMsgChange:(UISwitch *)msgSwitch
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"1",@"RunnerIsClient":@"",@"RunnerUserID":@"",@"Detail":@[@{@"ID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"IsMessagePush":@(msgSwitch.isOn),@"IsShow":@"6"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:parameters withMethod:@"POST" success:^(id result) {
        if (result) {
            NSLog(@"result:%@",result);
            [[NSUserDefaults standardUserDefaults] setObject:@(msgSwitch.isOn) forKey:@"isbbs"];
        }
    } failure:^(NSError *erro) {
        
    }];
    NSLog(@"isOn2:%d",msgSwitch.isOn);
}

- (void)isHotContentChange:(UISwitch *)msgSwitch
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"1",@"RunnerIsClient":@"",@"RunnerUserID":@"",@"Detail":@[@{@"ID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"IsHotNews":@(msgSwitch.isOn),@"IsShow":@"6"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:parameters withMethod:@"POST" success:^(id result) {
        if (result) {
            NSLog(@"result:%@",result);
            [[NSUserDefaults standardUserDefaults] setObject:@(msgSwitch.isOn) forKey:@"ishotnews"];
        }
    } failure:^(NSError *erro) {
        
    }];
    NSLog(@"isOn3:%d",msgSwitch.isOn);
}

#pragma mark -- other
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
