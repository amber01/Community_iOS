//
//  MyDraftListViewController.m
//  Community
//
//  Created by shlity on 15/12/16.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MyDraftListViewController.h"
#import "MyDraftListTableViewCell.h"
#import "SendTopicViewController.h"

@interface MyDraftListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UITableView     *tableView;
@property (nonatomic,retain)NSMutableArray  *dataArray;

@end

@implementation MyDraftListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"草稿箱";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateContent) name:@"updateContentNotification" object:nil];
    
    NSString *plistPath = [UIUtils getDocumentFile:@"myDraft.plist"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:plistPath];
    self.dataArray =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSLog(@"dataArray:%@",_dataArray);
    
    [self setupTableView];
}

- (void)updateContent
{
    NSString *plistPath = [UIUtils getDocumentFile:@"myDraft.plist"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:plistPath];
    self.dataArray =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSLog(@"self.dataArray:%@",self.dataArray);
    
    [_tableView reloadData];
}

#pragma mark -- UI
- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [UIUtils setExtraCellLineHidden:_tableView];
        
        if (isArrEmpty(self.dataArray)) {
            UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.height/2 - 80, ScreenWidth, 20)];
            tipsLabel.textColor = [UIColor grayColor];
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.text = @"您当前没有未保存的草稿哦";
            [_tableView addSubview:tipsLabel];
        }
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    MyDraftListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    
    if (!cell) {
        cell = [[MyDraftListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *detail  = [dic objectForKey:@"content"];
    NSString *date    = [dic objectForKey:@"date"];
    NSString *title   = [dic objectForKey:@"title"];
    cell.topicDetailLabel.text = [NSString stringWithFormat:@"【%@】%@",title,detail];
    cell.topicDateLabel.text = date;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic     = self.dataArray[indexPath.row];
    NSString *detail      = [dic objectForKey:@"content"];
    NSString *title       = [dic objectForKey:@"title"];
    NSMutableArray *imaes = [dic objectForKey:@"imaes"];
    NSString *cate_id     = [dic objectForKey:@"cate_id"];
    
    SendTopicViewController *sendTopicVC = [[SendTopicViewController alloc]init];
    sendTopicVC.topicTitle = title;
    sendTopicVC.topicContent = detail;
    sendTopicVC.myDraftDataArray = imaes;
    sendTopicVC.cate_id = cate_id;
    sendTopicVC.listTag = [NSString stringWithFormat:@"%ld",indexPath.row];
    BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:sendTopicVC];
    [self.navigationController presentViewController:baseNav animated:YES completion:^{
        
    }];

}

#pragma mark -- other

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
