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

@interface FansListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    FansListType    currentFansType;
    int             page;
    
    BOOL            isPraise;
}

@property (nonatomic,retain) UITableView    *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *fansDtaArray;
@property (nonatomic,copy)   NSString       *toUserID;

@end

@implementation FansListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    page = 1;
    currentFansType = [self.status intValue];
    if (currentFansType == FollwListCategory) {
        isPraise = YES;
    }
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
        NSDictionary *parameters = @{@"Method":@"ReMyFansInfo",@"RunnerUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"ToUserID":isStrEmpty(self.user_id) ? sharedInfo.user_id : self.user_id,@"IsShow":@"888",@"PageIndex":pageStr,@"PageSize":@"20",@"FldSortType":@"1"}]};
        [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:parameters withMethod:@"POST" success:^(id result) {
            NSLog(@"is resutl:%@",result);
            NSLog(@"msg:%@",[result objectForKey:@"Msg"]);
            if (result) {
                NSArray *items = [FansListModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
                NSArray *praiseItems = [result objectForKey:@"IsPraise"];
                for (int i = 0; i < items.count; i ++) {
                    if (!self.dataArray) {
                        self.dataArray = [[NSMutableArray alloc]init];
                    }
                    [self.dataArray addObject:[items objectAtIndex:i]];
                }
                
                for (int i = 0; i < praiseItems.count; i ++) {
                    if (!self.fansDtaArray) {
                        self.fansDtaArray = [[NSMutableArray alloc]init];
                    }
                    [self.fansDtaArray addObject:[praiseItems objectAtIndex:i]];
                }
              }
            [_tableView reloadData];
        } failure:^(NSError *erro) {
            
        }];
    }else if (fansType == FollwListCategory){
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSDictionary *parameters = @{@"Method":@"ReMyFansInfo",@"RunnerUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"UserID":isStrEmpty(self.user_id) ? sharedInfo.user_id : self.user_id,@"IsShow":@"888",@"PageIndex":pageStr,@"PageSize":@"20",@"FldSortType":@"1"}]};
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
    [cell configureCellWithInfo:model withStatus:currentFansType];

    if (currentFansType == FansListCategory) {
        [cell.followBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary *dic = self.fansDtaArray[indexPath.row];
        if ([[dic objectForKey:@"value"]isEqualToString:@"1"]) {
            [cell.followBtn setImage:[UIImage imageNamed:@"user_finish_follow"] forState:UIControlStateNormal];
        }else{
            [cell.followBtn setImage:[UIImage imageNamed:@"user_add_follow"] forState:UIControlStateNormal];
        }
        
        cell.followBtn.status = [dic objectForKey:@"value"];
        cell.followBtn.user_id = model.userid;
        cell.followBtn.row = indexPath.row;
    }else{
        
        
        [cell.followBtn addTarget:self action:@selector(cancelFollowAction:) forControlEvents:UIControlEventTouchUpInside];
        if (isPraise == YES) {
            [cell.followBtn setImage:[UIImage imageNamed:@"user_finish_follow"] forState:UIControlStateNormal];
        }else{
            [cell.followBtn setImage:[UIImage imageNamed:@"user_add_follow"] forState:UIControlStateNormal];
        }

        
        cell.followBtn.user_id = model.touserid;
        cell.followBtn.row = indexPath.row;
    }
    
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
        mineInfoVC.nickname = model.nickname;
        mineInfoVC.userName = model.username;
        mineInfoVC.avatarUrl = model.logopicture;
        [self.navigationController pushViewController:mineInfoVC animated:YES];
    }else if (fansListType == FollwListCategory){
        mineInfoVC.user_id = model.touserid;
        mineInfoVC.nickname = model.tonickname;
        mineInfoVC.userName = model.tousername;
        mineInfoVC.avatarUrl = model.tologopicture;
        [self.navigationController pushViewController:mineInfoVC animated:YES];
    }
}

#pragma mark -- action
- (void)followAction:(PubliButton *)button
{
    
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    //关注
    if (currentFansType == FansListCategory && [button.status intValue] == 0) {
        
        [self initMBProgress:@""];
        
        NSDictionary *params = @{@"Method":@"AddMyFansInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"ToUserID":button.user_id}]};
        [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:params withMethod:@"POST" success:^(id result) {
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [button setImage:[UIImage imageNamed:@"user_finish_follow"] forState:UIControlStateNormal];
                
                /**
                 *  先删除原来的点赞数，然后再重新加上
                 */
                [self.fansDtaArray removeObjectAtIndex:button.row];
                [self.fansDtaArray insertObject:@{@"value":@"1",@"touserid":button.user_id} atIndex:button.row];
                [_tableView reloadData];
                [self setMBProgreeHiden:YES];
            }
        } failure:^(NSError *erro) {
            
        }];
    }else{ //取消关注
        [self initMBProgress:@""];
        NSDictionary *params = @{@"Method":@"CancelMyFansInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"ToUserID":button.user_id}]};
        [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:params withMethod:@"POST" success:^(id result) {
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [button setImage:[UIImage imageNamed:@"user_add_follow"] forState:UIControlStateNormal];
                [self setMBProgreeHiden:YES];
                /**
                 *  先删除原来的点赞数，然后再重新加上
                 */
                
                [self.fansDtaArray removeObjectAtIndex:button.row];
                [self.fansDtaArray insertObject:@{@"value":@"0",@"touserid":button.user_id} atIndex:button.row];
                [_tableView reloadData];
            }
        } failure:^(NSError *erro) {
            
        }];
    }
}

- (void)cancelFollowAction:(PubliButton *)button
{
    self.toUserID = button.user_id;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定取消关注?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = button.row;
    [alertView show];
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        [self initMBProgress:@""];
        NSDictionary *params = @{@"Method":@"CancelMyFansInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"ToUserID":self.toUserID}]};
        [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:params withMethod:@"POST" success:^(id result) {
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                isPraise = YES;
                [self.dataArray removeObjectAtIndex:alertView.tag];
            }
            [self setMBProgreeHiden:YES];
            [_tableView reloadData];
            
        } failure:^(NSError *erro) {
            
        }];

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
