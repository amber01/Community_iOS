//
//  FansListViewController.m
//  Community
//
//  Created by amber on 15/12/5.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "FansListViewController.h"
#import "FansTableViewCell.h"
#import "MineInfoViewController.h"

@interface FansListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL            isToFans;
    FansListType    currentFansType;
    int             page;
}

@property (nonatomic,retain) UITableView    *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *fansDtaArray;


@end

@implementation FansListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    page = 1;
    currentFansType = [self.status intValue];
    [self getFansListData:currentFansType withPage:1];
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

#pragma mark -- HTTP
- (void)getFansListData:(FansListType )fansType withPage:(int)pageIndex
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    if (fansType == FansListCategory) {
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSDictionary *parameters = @{@"Method":@"ReMyFansInfo",@"Detail":@[@{@"ToUserID":isStrEmpty(self.user_id) ? sharedInfo.user_id : self.user_id,@"IsShow":@"888",@"PageIndex":pageStr,@"PageSize":@"20",@"FldSortType":@"1"}]};
        [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:parameters withMethod:@"POST" success:^(id result) {
            NSLog(@"is resutl:%@",result);
            if (result) {
                NSArray *items = [FansListModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
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
    }else if (fansType == FollwListCategory){
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSDictionary *parameters = @{@"Method":@"ReMyFansInfo",@"Detail":@[@{@"UserID":isStrEmpty(self.user_id) ? sharedInfo.user_id : self.user_id,@"IsShow":@"888",@"PageIndex":pageStr,@"PageSize":@"20",@"FldSortType":@"1"}]};
        [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:parameters withMethod:@"POST" success:^(id result) {
            NSLog(@"is resutl:%@",result);
            if (result) {
                NSArray *items = [FansListModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
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
}

#pragma mark -- MJRefresh
- (void)setupUploadMore{
    __unsafe_unretained __typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
- (void)loadMoreData{
    page = page + 1;
    [self getFansListData:currentFansType withPage:page];
    [_tableView.mj_footer endRefreshing];
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
    FansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[FansTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
    }
    FansListModel *model = self.dataArray[indexPath.row];
    [cell configureCellWithInfo:model withFollowData:self.fansDtaArray andRow:indexPath.row withStatus:currentFansType];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45 + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FansListType fansListType = [self.status intValue];
    MineInfoViewController *mineInfoVC = [[MineInfoViewController alloc]init];
    FansListModel *model = self.dataArray[indexPath.row];
 
    if (fansListType == FansListCategory) {
        mineInfoVC.user_id = model.userid;
        [self.navigationController pushViewController:mineInfoVC animated:YES];
    }else if (fansListType == FollwListCategory){
        mineInfoVC.user_id = model.touserid;
        [self.navigationController pushViewController:mineInfoVC animated:YES];
    }
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
