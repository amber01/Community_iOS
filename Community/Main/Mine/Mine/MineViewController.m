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

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL  isLogin;
}

@property (nonatomic,retain)UITableView *tableView;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
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

- (void)loginFinish:(NSNotification *)notifi
{
    isLogin = YES;
    _tableView = nil;
    [self  setupTableView];
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
        NSInteger sections[4] = {1,1,3,1};
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
            
            SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
            [cell configureCellWithInfo:shareInfo];
            
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
            NSArray *titleArray = @[@"我的物品",@"我的收藏",@"草稿箱"];
            NSArray *imageArray = @[@"mine_my_gift",@"mine_my_collect",@"mine_my_draft"];
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
                return 44;
            }
        }
            break;
        default:
            break;
    }
    return 44;
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
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [loginVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:loginVC animated:YES];
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
