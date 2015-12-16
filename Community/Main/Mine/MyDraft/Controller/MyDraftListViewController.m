//
//  MyDraftListViewController.m
//  Community
//
//  Created by shlity on 15/12/16.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MyDraftListViewController.h"
#import "MyDraftListTableViewCell.h"

@interface MyDraftListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UITableView     *tableView;
@property (nonatomic,retain)NSMutableArray  *dataArray;

@end

@implementation MyDraftListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"草稿箱";
    [self setupTableView];
    
    NSString *plistPath = [UIUtils getDocumentFile:@"myDraft.plist"];
    self.dataArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    
    NSLog(@"dataArray:%@",_dataArray);
}

#pragma mark -- UI
- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    MyDraftListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    
    if (!cell) {
        cell = [[MyDraftListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
    }
    cell.textLabel.text = @"test";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
