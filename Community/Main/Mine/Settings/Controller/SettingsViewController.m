//
//  SettingsViewController.m
//  Community
//
//  Created by amber on 15/12/1.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView   *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sections[3] = {4,4,1};
    return sections[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    const static char *cTitle[3][4] = {{"修改资料","切换城市","消息推送","省流量模式"},{"清除缓存数据和图片","新版本检测","意见反馈","关于微温州"},{""}};
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
        if (indexPath.section == 2 && indexPath.row == 0) {
            UILabel *logoutTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 44/2-10, ScreenWidth, 20)];
            logoutTitle.textColor = BASE_COLOR;
            logoutTitle.text = @"退出当前账号";
            logoutTitle.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:logoutTitle];
        }
    }
    
    cell.textLabel.text = [NSString stringWithCString:cTitle[indexPath.section][indexPath.row] encoding:NSUTF8StringEncoding];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
