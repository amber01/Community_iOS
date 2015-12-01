//
//  ModifyUserInfoViewController.m
//  Community
//
//  Created by amber on 15/11/30.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "ModifyUserInfoViewController.h"
#import "ModifyUserInfoTableViewCell.h"

@interface ModifyUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UITableView *tableView;

@end

@implementation ModifyUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改资料";
    [self setupTableView];
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

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sections[2] = {3,2};
    return sections[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    ModifyUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    const static char *cTitle[2][3] = {{"头像","性别","用户名"},{"修改密码","手机号"}};
    
    if (!cell) {
        cell = [[ModifyUserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [NSString stringWithCString:cTitle[indexPath.section][indexPath.row] encoding:NSUTF8StringEncoding];
    SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if (indexPath.section == 0){
        if (indexPath.row == 0) {
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",picturedomain,BASE_IMAGE_URL,face,shareInfo.picture]]placeholderImage:[UIImage imageNamed:@"mine_login"]];
        }else if (indexPath.row == 2){
            cell.detailTextLabel.text = shareInfo.nickname;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
