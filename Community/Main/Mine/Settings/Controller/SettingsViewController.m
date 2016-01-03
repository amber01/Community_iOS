//
//  SettingsViewController.m
//  Community
//
//  Created by amber on 15/12/1.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "SettingsViewController.h"
#import "EaseMob.h"
#import "SettingTableViewCell.h"
#import "ModifyUserInfoViewController.h"
#import "SelectCityViewController.h"
#import "MsgNotificationViewController.h"
#import "MiniNetworkSetViewController.h"
#import "EaseMessageViewController.h"

@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL  isLogin;
}

@property (nonatomic,retain) UITableView   *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginFinish) name:kSendIsLoginNotification object:nil];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"username"]length]> 0) {
        isLogin = YES;
    }else{
        isLogin = NO;
    }
    
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_tableView reloadData];
}

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

- (void)loginFinish
{
    isLogin = YES;
    [_tableView reloadData];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLogin) {
        NSInteger sections[3] = {4,4,1};
        return sections[section];
    }else{
        NSInteger sections[3] = {3,4,1};
        return sections[section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];

    if (!cell) {
        cell = [[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
        [cell layoutSubviews]; 
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (isLogin) {
        const static char *cTitle[3][4] = {{"修改资料","切换城市","消息推送","省流量模式"},{"清除缓存数据和图片","当前版本","意见反馈","关于微温州"},{""}};
        cell.textLabel.text = [NSString stringWithCString:cTitle[indexPath.section][indexPath.row] encoding:NSUTF8StringEncoding];
        if (indexPath.section == 2 && indexPath.row == 0) {
            cell.logoutTitle.text = @"退出当前账号";
            cell.logoutTitle.hidden = NO;
        }else{
            cell.logoutTitle.hidden = YES;
        }
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
            cell.cityDetailLabel.hidden = NO;
            cell.cityDetailLabel.text = sharedInfo.cityarea;
        }else{
            cell.cityDetailLabel.hidden = YES;
        }

        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fMB",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
        }else{
            cell.detailTextLabel.text = @"";
        }
        
    }else{
        const static char *cTitle[3][4] = {{"切换城市","消息推送","省流量模式"},{"清除缓存数据和图片","当前版本","意见反馈","关于微温州"},{""}};
        cell.textLabel.text = [NSString stringWithCString:cTitle[indexPath.section][indexPath.row] encoding:NSUTF8StringEncoding];
        if (indexPath.section == 2 && indexPath.row == 0) {
            cell.logoutTitle.hidden = NO;
            cell.logoutTitle.text = @"立即登录";
        }else{
            cell.logoutTitle.hidden = YES;
        }
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
            cell.cityDetailLabel.hidden = NO;
            cell.cityDetailLabel.text = sharedInfo.cityarea;
        }else{
            cell.cityDetailLabel.hidden = YES;
        }

        
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fMB",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
        }else{
            cell.detailTextLabel.text = @"";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            if (isLogin) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要退出当前账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }else{
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
    }else if (indexPath.section == 0){
        if (isLogin) {
            if (indexPath.row == 0) {
                ModifyUserInfoViewController *modifyUserInfoVC = [[ModifyUserInfoViewController alloc]init];
                [self.navigationController pushViewController:modifyUserInfoVC animated:YES];
            }else if (indexPath.row == 1){
                //切换城市
                SelectCityViewController *selectCityVC = [[SelectCityViewController alloc]init];
                [self.navigationController pushViewController:selectCityVC animated:YES];
            }else if (indexPath.row == 2){
                MsgNotificationViewController *msgNotificationVC = [[MsgNotificationViewController alloc]init];
                [self.navigationController pushViewController:msgNotificationVC animated:YES];
            }else if (indexPath.row == 3){
                MiniNetworkSetViewController *miniNetworkSetVC = [[MiniNetworkSetViewController alloc]init];
                [self.navigationController pushViewController:miniNetworkSetVC animated:YES];
            }
        }else{
            if (indexPath.row == 0) {
                SelectCityViewController *selectCityVC = [[SelectCityViewController alloc]init];
                [self.navigationController pushViewController:selectCityVC animated:YES];
            }else if (indexPath.row == 1){
                MsgNotificationViewController *msgNotificationVC = [[MsgNotificationViewController alloc]init];
                [self.navigationController pushViewController:msgNotificationVC animated:YES];
            }else if (indexPath.row == 2){
                MiniNetworkSetViewController *miniNetworkSetVC = [[MiniNetworkSetViewController alloc]init];
                [self.navigationController pushViewController:miniNetworkSetVC animated:YES];
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要清除缓存吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 1000;
            [alertView show];
        }else if (indexPath.row == 1){
            NSString *version = [NSString stringWithFormat:@"您的当前版本为v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:version delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else if (indexPath.row == 2){
            EaseMessageViewController *easeMessageVC = [[EaseMessageViewController alloc]initWithConversationChatter:@"8115" conversationType:eConversationTypeChat];
            //easeMessageVC.avatarUrl = button.avatarUrl;
            easeMessageVC.title = @"意见反馈";
            [self.navigationController pushViewController:easeMessageVC animated:YES];
            
        }else if (indexPath.row == 3){
            WebDetailViewController *webDetailVC = [[WebDetailViewController alloc]init];
            webDetailVC.url = [NSString stringWithFormat:@"%@Default.aspx?mobile/aboutus",ROOT_URL];
            [self.navigationController pushViewController:webDetailVC animated:YES];
        }
    }
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag != 1000) {
        EaseMob *easemob = [EaseMob sharedInstance];
        [easemob.chatManager asyncLogoffWithUnbindDeviceToken:YES]; //退出环信登陆的账号
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"nickname"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"area"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"address"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"createtime"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"picture"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"myfansnum"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"mytofansnum"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"postnum"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"totalscore"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sex"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"client"];
        
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        sharedInfo.user_id  = @"";
        sharedInfo.nickname  = @"";
        sharedInfo.mobile  = @"";
        sharedInfo.username  = @"";
        sharedInfo.area  = @"";
        sharedInfo.address  = @"";
        sharedInfo.createtime  = @"";
        sharedInfo.picture = @"";
        sharedInfo.myfansnum = @"";
        sharedInfo.mytofansnum = @"";
        sharedInfo.postnum = @"";
        sharedInfo.totalscore = @"";
        sharedInfo.sex = @"";
        sharedInfo.client = @"";
        [[NSNotificationCenter defaultCenter]postNotificationName:kSendIsLogoutNotification object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationHideAlertDot object:nil];
        isLogin = NO;
        [_tableView reloadData];
        [self initMBProgress:@"退出成功" withModeType:MBProgressHUDModeText afterDelay:1.0];
    }else{
        if (buttonIndex == 1) {
            [[SDImageCache sharedImageCache] clearDisk];
            NSIndexPath *index =  [NSIndexPath indexPathForItem:0 inSection:1];
            UITableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fMB",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
        }
    }
}

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
