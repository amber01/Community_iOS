//
//  DiscoverFindFriendViewController.m
//  Community
//
//  Created by amber on 16/4/10.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverFindFriendViewController.h"
#import "DiscoverFindFriendTableViewCell.h"
#import "DiscoverFindFriendView.h"
#import "TopicSearchViewController.h"

@interface DiscoverFindFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int     page;
    DiscoverFindFriendView *discoverFindFriendView;
    BOOL    isNearby;
}

@property (nonatomic,retain)UITableView     *tableView;
@property (nonatomic,retain)NSMutableArray  *dataArray;
@property (nonatomic,retain)NSMutableArray  *toFansArray;

@end

@implementation DiscoverFindFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_COLOR;
    [self tableView];
    isNearby = YES;
    page  = 1;
    [self getUserListInfo:page];
    [self setupRefreshHeader];
    [self setupUploadMore];
}

#pragma mark -- UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -2, ScreenWidth, ScreenHeight  - 64 - 49 - 12) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = VIEW_COLOR;
        discoverFindFriendView = [[DiscoverFindFriendView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
        [discoverFindFriendView.searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [discoverFindFriendView.distanceBtn addTarget:self action:@selector(distanceAction) forControlEvents:UIControlEventTouchUpInside];
        [discoverFindFriendView.activeBtn addTarget:self action:@selector(activeAction) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableHeaderView = discoverFindFriendView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma makr -- HTTP
- (void)getUserListInfo:(int)pageIndex
{
    [self initMBProgress:@""];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters;
    if (isNearby) { //附近
        parameters = @{@"Method":@"ReUserNearInfo",
                       @"RunnerUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,
                       @"Detail":@[@{@"PageSize":@"20",
                                     @"PageIndex":pageStr,
                                     @"Latitudes":isStrEmpty(sharedInfo.latitude) ? @"27.9186" : sharedInfo.latitude,
                                     @"Longitudes":isStrEmpty(sharedInfo.longitude) ? @"120.857852" : sharedInfo.longitude,
                                     }]};
    }else{  //活跃
        parameters = @{@"Method":@"ReUserInfo",
                       @"RunnerUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,
                       @"Detail":@[@{@"PageSize":@"20",
                                     @"IsShow":@"888",
                                     @"PageIndex":pageStr,
                                     @"FldSort":@"4",
                                     @"FldSortType":@"1",
                                     }]};
    }
    
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        NSArray *items;
        if (isNearby) {
            items = [DiscoverNearbyFriendModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        }else{
            items = [DiscoverFindFriendModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        }
        NSArray *tempArr = [result objectForKey:@"Detail"];
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
            [_toFansArray removeAllObjects];
        }
        
        for (int i = 0; i < items.count; i ++) {
            if (!self.dataArray) {
                self.dataArray = [[NSMutableArray alloc]init];
            }
            [self.dataArray addObject:[items objectAtIndex:i]];
        }
        
        for (int i = 0; i < tempArr.count; i ++) {
            if (!_toFansArray) {
                _toFansArray = [NSMutableArray new];
            }
            NSDictionary *dic = [tempArr objectAtIndex:i];
            [_toFansArray addObject:[dic objectForKey:@"isfocus"]];
        }
        
        [self setMBProgreeHiden:YES];
        [self.tableView reloadData];
        
    } failure:^(NSError *erro) {
        
    }];
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
    [self getUserListInfo:page];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData{
    page = page + 1;
    [self getUserListInfo:page];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifyCell = @"cell";
    DiscoverFindFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyCell];
    if (!cell) {
        cell = [[DiscoverFindFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyCell];
        [cell.addFollowBtn addTarget:self action:@selector(addFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (isNearby) {
        DiscoverNearbyFriendModel *model = nil;
        model = [self.dataArray objectAtIndex:indexPath.row];
        cell.addFollowBtn.user_id = model.id;
        [cell configureCellWithNearbyInfo:model];
    }else{
        DiscoverFindFriendModel *model = nil;
        model = [self.dataArray objectAtIndex:indexPath.row];
        cell.addFollowBtn.user_id = model.id;
        [cell configureCellWithInfo:model];
    }
    
    cell.addFollowBtn.row = indexPath.row;
    
    if ([_toFansArray[indexPath.row]intValue] == 1) { //已关注
        [cell.addFollowBtn setBackgroundImage:[UIImage imageNamed:@"discover_cancel_follow.png"] forState:UIControlStateNormal];
        cell.addFollowBtn.isTrue = YES;
    }else{
        [cell.addFollowBtn setBackgroundImage:[UIImage imageNamed:@"discover_add_follow.png"] forState:UIControlStateNormal];
        cell.addFollowBtn.isTrue = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark -- action
- (void)searchAction
{
    TopicSearchViewController *topicSearchVC = [[TopicSearchViewController alloc]init];
    [topicSearchVC setHidesBottomBarWhenPushed:YES];
    topicSearchVC.searchStatus = @"1";
    [self.navigationController pushViewController:topicSearchVC animated:YES];
}

- (void)addFollowAction:(PubliButton *)button
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        [self initMBProgress:@""];
        //关注
        if (button.isTrue == NO) {
            NSDictionary *params = @{@"Method":@"AddMyFansInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"ToUserID":button.user_id}]};
            [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:params withMethod:@"POST" success:^(id result) {
                if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                    [_toFansArray removeObjectAtIndex:button.row];
                    [_toFansArray insertObject:@"1" atIndex:button.row];
                    [_tableView reloadData];
                    [self setMBProgreeHiden:YES];                }
            } failure:^(NSError *erro) {
                
            }];
        }else{ //取消关注
            NSDictionary *params = @{@"Method":@"CancelMyFansInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"ToUserID":button.user_id}]};
            [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:params withMethod:@"POST" success:^(id result) {
                if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                    [_toFansArray removeObjectAtIndex:button.row];
                    [_toFansArray insertObject:@"0" atIndex:button.row];
                    [_tableView reloadData];
                    [self setMBProgreeHiden:YES];
                }
            } failure:^(NSError *erro) {
                
            }];
        }
    }
}


- (void)distanceAction
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = discoverFindFriendView.lineView.frame;
        frame.origin.x = 0;
        discoverFindFriendView.lineView.frame = frame;
    }];
    isNearby = YES;
    page = 1;
    [self getUserListInfo:page];
}

- (void)activeAction
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = discoverFindFriendView.lineView.frame;
        frame.origin.x = discoverFindFriendView.activeBtn.width;
        discoverFindFriendView.lineView.frame = frame;
    }];
    
    
    isNearby = NO;
    page = 1;
    [self getUserListInfo:page];
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
