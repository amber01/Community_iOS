//
//  MiniNetworkSetViewController.m
//  Community
//
//  Created by amber on 15/12/17.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MiniNetworkSetViewController.h"
#import "MsgNotificationTableViewCell.h"

@interface MiniNetworkSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView   *tableView;

@end

@implementation MiniNetworkSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"流量模式设置";
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    MsgNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    
    if (!cell) {
        cell = [[MsgNotificationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        
        [cell.msgSwitch addTarget:self action:@selector(isMiniNetworkChange:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isMiniNetwork"]intValue] > 0) {
            cell.msgSwitch.on = YES;
        }else{
            cell.msgSwitch.on = NO;
        }
    }
    cell.textLabel.text = @"开启省流量模式";
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
- (void)isMiniNetworkChange:(UISwitch *)msgSwitch
{
    [[NSUserDefaults standardUserDefaults] setObject:@(msgSwitch.isOn) forKey:@"isMiniNetwork"];
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
