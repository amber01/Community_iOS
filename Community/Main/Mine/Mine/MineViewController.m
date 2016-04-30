//
//  MineViewController.m
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MineViewController.h"
#import "MineInfoTableViewCell.h"
#import "MineBtnTableViewCell.h"
#import "LoginViewController.h"
#import "MineInfoViewController.h"
#import "SettingsViewController.h"
#import "MyDraftListViewController.h"
#import "MyCollectionViewController.h"
#import "ModifyUserInfoViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL  isLogin;
    NSString *myfansnum;
}

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *dataArray;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getUserInfoData];
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"username"]length]> 0) {
        isLogin = YES;
    }else{
        isLogin = NO;
    }
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginFinish:) name:kSendIsLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutFinish) name:kSendIsLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginFinish:) name:@"kReloadAvatarImageNotification" object:nil];
}

- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self getUserInfoData];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)loginFinish:(NSNotification *)notifi
{
    isLogin = YES;
    _tableView = nil;
    [self  setupTableView];
}

- (void)logoutFinish
{
    isLogin = NO;
    _tableView = nil;
    [self  setupTableView];
}

#pragma mark -- HTTP
- (void)getUserInfoData
{
    SharedInfo *shared = [SharedInfo sharedDataInfo];
    
    if (!isStrEmpty(shared.user_id)) {
        NSDictionary *params = @{@"Method":@"ReUserInfo",@"Detail":@[@{@"ID":shared.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
            if (result) {
                NSArray *items = [UserModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
                if (self.dataArray.count > 1) {
                    [self.dataArray removeAllObjects];
                }
                
                for (int i = 0; i < items.count; i ++) {
                    if (!self.dataArray) {
                        self.dataArray = [[NSMutableArray alloc]init];
                    }
                    [self.dataArray addObject:[items objectAtIndex:i]];
                }
            }
            [self getMsgCount];
        } failure:^(NSError *erro) {
            
        }];
    }
}

#pragma mark -- HTTP
- (void)getMsgCount
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        [_tableView reloadData];
        return;
    }
    NSDictionary *parameters = @{@"Method":@"ReCommentInfoRead",@"Detail":@[@{@"UserID":sharedInfo.user_id}]};
    [CKHttpRequest createRequest:HTTP_METHOD_COMMENT WithParam:parameters withMethod:@"POST" success:^(id result) {
        if (result) {
            NSArray *item = [result objectForKey:@"Detail"];
            for (int i = 0; i < item.count; i ++ ) {
                NSDictionary *dic = [item objectAtIndex:i];
                myfansnum = [dic objectForKey:@"myfansnum"];
            }
        }
        [_tableView reloadData];
    } failure:^(NSError *erro) {
        
    }];
    
}


#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isLogin) {
        return 4;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLogin) {
        NSInteger sections[4] = {1,1,3,2};
        return sections[section];
    }else{
        NSInteger sections[3] = {1,1,1};
        return sections[section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isLogin) {
        if (indexPath.section == 0) {
            static NSString *identityCell = @"cell";
            MineInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
            if (!cell) {
                cell = [[MineInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            UserModel *model = self.dataArray[indexPath.row];
            [cell configureCellWithInfo:model withNewFansCount:myfansnum];
            
            return cell;
            
        }else if (indexPath.section == 1) {
            static NSString *identityCell = @"btnCell";
            MineBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
            if (!cell) {
                cell = [[MineBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
            }
            return cell;
        }else if (indexPath.section == 2) {
            
            static NSString *identityCell = @"othercell";
            NSArray *titleArray = @[@"我的物品",@"我的收藏",@"草稿箱"]; //@[@"积分兑换现金",@"我的物品",@"我的收藏",@"草稿箱"];
            NSArray *imageArray = @[@"mine_my_gift",@"mine_my_collect",@"mine_my_draft"]; //@[@"mine_score_ex",@"mine_my_gift",@"mine_my_collect",@"mine_my_draft"];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = titleArray[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
            return cell;
        }else{
            if (indexPath.row == 0) {
                static NSString *identityCell = @"settingcell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell.textLabel.text = @"设置";
                cell.imageView.image = [UIImage imageNamed:@"mine_settings"];
                return cell;
            }else{
                static NSString *identityCell = @"infoCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell.textLabel.text = @"编辑个人信息";
                cell.imageView.image = [UIImage imageNamed:@"mine_edit_info"];
                return cell;
            }
        }
        
    }else{
        if (indexPath.section == 0) {
            static NSString *identityCell = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.imageView.image = [UIImage imageNamed:@"mine_login"];
            cell.textLabel.text = @"登录/注册";
            return cell;
            
        }else if (indexPath.section == 1) {
            static NSString *identityCell = @"btnCell";
            MineBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
            if (!cell) {
                cell = [[MineBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
            }
            return cell;
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                static NSString *identityCell = @"settingcell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell.textLabel.text = @"设置";
                cell.imageView.image = [UIImage imageNamed:@"mine_settings"];
                return cell;
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                if (isLogin) {
                    return 125;
                }
                return 90;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                return 85;
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                return 60;
            }
        }
            break;
        default:
            break;
    }
    return 60;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return CGFLOAT_MIN;
    }
    
    return 13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 70;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isLogin) { //已登录
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                MineInfoViewController *mineInfoVC = [[MineInfoViewController alloc]init];
                [mineInfoVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:mineInfoVC animated:YES];
            }
        }else if (indexPath.section == 3){
            if (indexPath.row == 0) {
                SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
                [settingsVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:settingsVC animated:YES];
            }else{
                ModifyUserInfoViewController *modifyUserInfoVC = [[ModifyUserInfoViewController alloc]init];
                [modifyUserInfoVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:modifyUserInfoVC animated:YES];
            }
        }else if (indexPath.section == 2){
            
            if (indexPath.row == 2){
                MyDraftListViewController *myDraftListVC = [[MyDraftListViewController alloc]init];
                [myDraftListVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:myDraftListVC animated:YES];
            }else if (indexPath.row == 1){
                MyCollectionViewController *myCollectionVC = [[MyCollectionViewController alloc]init];
                [myCollectionVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:myCollectionVC animated:YES];
            }else if (indexPath.row == 0){
                SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
                NSDictionary *parameter = @{@"UserID":sharedInfo.user_id,
                                            @"UserName":sharedInfo.username};
                
                [CKHttpRequest createRequest:HTTP_METHOD_ENCRYPT WithParam:parameter withMethod:@"POST" success:^(id result) {
                    NSLog(@"result:%@",result);
                    if ([[result objectForKey:@"UserID"]length] > 0) {
                        NSString *userID = [result objectForKey:@"UserID"];
                        NSString *userName = [result objectForKey:@"UserName"];

                        WebDetailViewController *webDetailVC = [[WebDetailViewController alloc]init];
                        webDetailVC.url = [NSString stringWithFormat:@"%@my.aspx?UserID=%@&UserName=%@",ROOT_URL,userID,userName];
                        [webDetailVC setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:webDetailVC animated:YES];

                    }
                    
                } failure:^(NSError *erro) {
                    
                }];
            }
        }
    }else{ //未登录
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [loginVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
                [settingsVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:settingsVC animated:YES];
            }
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
