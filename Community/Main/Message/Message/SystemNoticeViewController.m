//
//  SystemNoticeViewController.m
//  Community
//
//  Created by amber on 15/12/22.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "SystemNoticeViewController.h"
#import "SystemNoticeTableViewCell.h"

@interface SystemNoticeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)UITableView     *tableView;
@property (nonatomic,retain)NSMutableArray  *dataArray;

@end

@implementation SystemNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统通知";
    [self setupTableView];
    [self getNoticeData];
    self.view.backgroundColor = CELL_COLOR;
}

#pragma mark -- UI
- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = CELL_COLOR;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -- HTTP
- (void)getNoticeData
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ReNotice",@"RunnerUserID":sharedInfo.user_id,@"Detail":@[@{@"ID":@"消息ID",@"IsShow":@"888"}]};
    [CKHttpRequest createRequest:HTTP_SYSTEM_NOTICE WithParam:parameters withMethod:@"POST" success:^(id result) {
        if (result) {
            self.dataArray = [SystemNoticeModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
            NSLog(@"result1:%@",result);
        }
        [_tableView reloadData];
    } failure:^(NSError *erro) {
        
    }];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    SystemNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SystemNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    SystemNoticeModel *model = self.dataArray [indexPath.row];
    [cell configureCellWithInfo:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- action


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
