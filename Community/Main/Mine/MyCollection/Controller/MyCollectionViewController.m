//
//  MyCollectionViewController.m
//  Community
//
//  Created by amber on 15/12/17.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionTableViewCell.h"
#import "TopicDetailViewController.h"

@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int     page;
}

@property (nonatomic,retain) UITableView    *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    
    page  = 1;
    [self setupTableView];
    [self getMyCollectionData:1];
    
    [self setupRefreshHeader];
    [self setupUploadMore];
}

#pragma mark -- UI
- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [UIUtils setExtraCellLineHidden:_tableView];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark MJRefresh
- (void)setupRefreshHeader{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = header;
}

- (void)setupUploadMore{
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)loadNewData{
    page = 1;
    [self getMyCollectionData:page];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData{
    page = page + 1;
    [self getMyCollectionData:page];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -- HTTP
- (void)getMyCollectionData:(int)pageIndex
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    SharedInfo *shared = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ReMyCollectionInfo",@"Detail":@[@{@"UserID":shared.user_id,@"PageIndex":pageStr,@"PageSize":@"20",@"IsShow":@"888",@"FldSortType":@"1"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_MY_COLLECTION WithParam:parameters withMethod:@"POST" success:^(id result) {
        
        if (result) {
            NSLog(@"reslt:%@",result);
            NSArray *items = [MyCollectionModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
            if (page == 1) {
                [self.dataArray removeAllObjects];
            }
            
            for (int i = 0; i < items.count; i ++) {
                if (!self.dataArray) {
                    self.dataArray = [[NSMutableArray alloc]init];
                }
                [self.dataArray addObject:[items objectAtIndex:i]];
            }
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
    MyCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[MyCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    
    MyCollectionModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configureCellWithInfo:model];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MyCollectionModel *model = [self.dataArray objectAtIndex:indexPath.row];
    TopicDetailViewController *topicDetaiVC = [[TopicDetailViewController alloc]init];
    topicDetaiVC.post_id = model.postid;
    topicDetaiVC.user_id = model.userid;
    [topicDetaiVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:topicDetaiVC animated:YES];
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
