
//
//  TopicSearchViewController.m
//  Community
//
//  Created by amber on 15/12/9.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicSearchViewController.h"
#import "TopicSearchBarView.h"
#import "TopicSearchTopView.h"
#import "EveryoneTopicTableViewCell.h"
#import "TopicSearchTableViewCell.h"
#import "MineInfoViewController.h"

@interface TopicSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView    *_tableView;
    UITableView    *_userTabelView;
    TopicSearchBarView      *topicSearchBarView;
    TopicSearchTopView *searchTopView;
    int         page;
    int         userPage;
    BOOL        isSearch;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *userDataArray;

@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,retain) NSMutableArray *praiseDataArray; //自己是否点赞的数据
@property (nonatomic,retain) NSMutableArray *likeDataArray;  //记录本地点赞的状态
@property (nonatomic,retain) NSMutableArray *fansDtaArray;

@property (nonatomic,retain) NSString    *keyword;

@end

@implementation TopicSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackView];
    [self createTableView];
    page = 1;
    userPage = 1;
    self.view.backgroundColor = CELL_COLOR;
    
    searchTopView = [[TopicSearchTopView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth, 42)];
    [searchTopView.segmentedView addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:searchTopView];
    
    //内容下拉
    [self setupRefreshHeaderWithTopic];
    [self setupUploadMoreWithTopic];
    
    //用户下拉
    [self setupRefreshHeaderWithUser];
    [self setupUploadMoreWithUser];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, ScreenWidth, ScreenHeight - 64 - 42) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tag = 1000;
    _tableView.hidden = NO;
    [UIUtils setExtraCellLineHidden:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    _userTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, ScreenWidth, ScreenHeight - 64 - 42) style:UITableViewStylePlain];
    _userTabelView.dataSource = self;
    _userTabelView.delegate = self;
    _userTabelView.hidden = YES;
    [UIUtils setExtraCellLineHidden:_userTabelView];
    _userTabelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_userTabelView];
}


- (void)customBackView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];  //自定义返回按钮
    button.frame = CGRectMake(0, 0, 35, 35);
    [button setImage:[UIImage imageNamed:@"back_btn_image"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [self setHidesBottomBarWhenPushed:YES];
    
    topicSearchBarView = [[TopicSearchBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 125, 35)];
    topicSearchBarView.myTextField.delegate = self;
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithCustomView:topicSearchBarView];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, searchItem,nil];
    
    
    UIButton *serarchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serarchBtn.frame = CGRectMake(0, 0, 22, 22);
    [serarchBtn setImage:[UIImage imageNamed:@"topic_search_icon"] forState:UIControlStateNormal];
    [serarchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchItems = [[UIBarButtonItem alloc]initWithCustomView:serarchBtn];
    //self.navigationItem.rightBarButtonItem = searchItems;
}

#pragma mark MJRefresh
- (void)setupRefreshHeaderWithTopic{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopicData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
}

- (void)setupUploadMoreWithTopic{
    __unsafe_unretained __typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreTopicData];
    }];
}

- (void)loadNewTopicData{
    if (isSearch) {
        if (searchTopView.segmentedView.selectedSegmentIndex == 0) {
            page = 1;
            [self getSearchContent:page keyword:self.keyword];
        }
        [_tableView.mj_header endRefreshing];
    }
}

- (void)loadMoreTopicData{
    if (isSearch) {
        if (searchTopView.segmentedView.selectedSegmentIndex == 0) {
            page = page + 1;
            [self getSearchContent:page keyword:self.keyword];
        }
        [_tableView.mj_footer endRefreshing];
    }
}

//搜索用户刷新
- (void)setupRefreshHeaderWithUser{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUserData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _userTabelView.mj_header = header;
}

- (void)setupUploadMoreWithUser{
    __unsafe_unretained __typeof(self) weakSelf = self;
    _userTabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreUserData];
    }];
}

- (void)loadNewUserData{
    if (isSearch) {
        if (searchTopView.segmentedView.selectedSegmentIndex == 1) {
            userPage = 1;
            [self getSearchUser:page keyword:self.keyword];
        }
        [_userTabelView.mj_header endRefreshing];
    }
}

- (void)loadMoreUserData{
    if (isSearch) {
        if (searchTopView.segmentedView.selectedSegmentIndex == 1) {
            userPage = userPage + 1;
            [self getSearchUser:page keyword:self.keyword];
        }
        [_userTabelView.mj_footer endRefreshing];
    }
}


#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        return self.dataArray.count;
    }else{
        return self.userDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        static NSString *identityCell = @"cell";
        EveryoneTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cell) {
            cell = [[EveryoneTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
            [cell.likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        EveryoneTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
        cell.likeBtn.row = indexPath.row;
        
        if (!_likeDataArray) {
            self.likeDataArray = [[NSMutableArray alloc]init];
        }
        [_likeDataArray addObject:model.praisenum];
        
        [cell configureCellWithInfo:model withImages:self.imagesArray andPraiseData:self.praiseDataArray andRow:indexPath.row];
        
        if (!isArrEmpty(self.praiseDataArray)) {
            NSDictionary *dic = [self.praiseDataArray objectAtIndex:indexPath.row];
            cell.likeBtn.post_id = [dic objectForKey:@"postid"];
            cell.likeBtn.isPraise = [dic objectForKey:@"value"];
        }
        
        cell.likeLabel.text = _likeDataArray[indexPath.row];
        cell.likeBtn.praisenum = _likeDataArray[indexPath.row];
        return cell;
    }else{
        static NSString *identityCell = @"fansCell";
        TopicSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cell) {
            cell = [[TopicSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
            [cell.followBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        UserModel *model = self.userDataArray[indexPath.row];
        [cell configureCellWithInfo:model];
        
        NSDictionary *dic = self.fansDtaArray[indexPath.row];
        if ([[dic objectForKey:@"value"]isEqualToString:@"1"]) {
            [cell.followBtn setImage:[UIImage imageNamed:@"user_finish_follow"] forState:UIControlStateNormal];
        }else{
            [cell.followBtn setImage:[UIImage imageNamed:@"user_add_follow"] forState:UIControlStateNormal];
        }
        
        cell.followBtn.status = [dic objectForKey:@"value"];
        cell.followBtn.user_id = model.id;
        cell.followBtn.row = indexPath.row;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1000) {
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else{
        return 45 + 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MineInfoViewController *mineInfoVC = [[MineInfoViewController alloc]init];
    UserModel *model = self.userDataArray[indexPath.row];
    mineInfoVC.user_id = model.id;
    mineInfoVC.nickname = model.nickname;
    mineInfoVC.userName = model.username;
    mineInfoVC.avatarUrl = model.picture;
    [self.navigationController pushViewController:mineInfoVC animated:YES];
}

#pragma mark -- action
- (void)searchAction
{
    //帖子
    if (searchTopView.segmentedView.selectedSegmentIndex == 0) {
        if (topicSearchBarView.myTextField.text.length == 0) {
            [self initMBProgress:@"关键字不能为空" withModeType:MBProgressHUDModeText afterDelay:1.0];
        }else{
            self.keyword = topicSearchBarView.myTextField.text;
            [self getSearchContent:page keyword:self.keyword];
            isSearch = YES;
        }
    }else{ //用户
        if (topicSearchBarView.myTextField.text.length == 0) {
            [self initMBProgress:@"关键字不能为空" withModeType:MBProgressHUDModeText afterDelay:1.0];
        }else{
            self.keyword = topicSearchBarView.myTextField.text;
            [self getSearchUser:userPage keyword:self.keyword];
            isSearch = YES;
        }
    }
}

//帖子
- (void)getSearchContent:(int )pageIndex keyword:(NSString *)keyword
{
    SharedInfo *sharedInfo  = [SharedInfo sharedDataInfo];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *parameters = @{@"Method":@"RePostInfo",@"LoginUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":pageStr,@"FldSort":@"0",@"FldSortType":@"1",@"SearchKey":keyword}]};
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if ([[result objectForKey:@"Detail"]count] < 1) {
            [self initMBProgress:@"未找到相关的内容" withModeType:MBProgressHUDModeText afterDelay:1.5];
            return;
        }
        if (result) {
            NSArray *items = [EveryoneTopicModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
            NSArray *imageItems = [TodayTopicImagesModel arrayOfModelsFromDictionaries:[result objectForKey:@"Images"]];
            NSArray *praiseItems = [result objectForKey:@"IsPraise"];
            
            if (page == 1) {
                [self.dataArray removeAllObjects];
                [self.imagesArray removeAllObjects];
                [self.praiseDataArray removeAllObjects];
            }
            
            for (int i = 0; i < items.count; i ++) {
                if (!self.dataArray) {
                    self.dataArray = [[NSMutableArray alloc]init];
                }
                [self.dataArray addObject:[items objectAtIndex:i]];
            }
            
            for (int i = 0; i < imageItems.count; i ++) {
                if (!self.imagesArray) {
                    self.imagesArray = [[NSMutableArray alloc]init];
                }
                [self.imagesArray addObject:[imageItems objectAtIndex:i]];
            }
            
            for (int i = 0; i < praiseItems.count; i ++) {
                if (!self.praiseDataArray) {
                    self.praiseDataArray = [[NSMutableArray alloc]init];
                }
                [self.praiseDataArray addObject:[praiseItems objectAtIndex:i]];
            }
        }
        [_tableView reloadData];
    } failure:^(NSError *erro) {
        
    }];
}

//用户
- (void)getSearchUser:(int )pageIndex keyword:(NSString *)keyword
{
    SharedInfo *sharedInfo  = [SharedInfo sharedDataInfo];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *parameters = @{@"Method":@"ReUserInfo",@"RunnerUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"ID":@"",@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":pageStr,@"SearchKey":keyword}]};
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if ([[result objectForKey:@"Detail"]count] < 1) {
            [self initMBProgress:@"未找到该用户" withModeType:MBProgressHUDModeText afterDelay:1.5];
            return;
        }
        if (result) {
            NSArray *items = [UserModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
            NSArray *praiseItems = [result objectForKey:@"IsPraise"];
            if (userPage == 1) {
                [self.userDataArray removeAllObjects];
                [self.fansDtaArray removeAllObjects];
            }
            
            for (int i = 0; i < items.count; i ++) {
                if (!self.userDataArray) {
                    self.userDataArray = [[NSMutableArray alloc]init];
                }
                [self.userDataArray addObject:[items objectAtIndex:i]];
            }
            
            for (int i = 0; i < praiseItems.count; i ++) {
                if (!self.fansDtaArray) {
                    self.fansDtaArray = [[NSMutableArray alloc]init];
                }
                [self.fansDtaArray addObject:[praiseItems objectAtIndex:i]];
            }
        }
        [_userTabelView reloadData];
    } failure:^(NSError *erro) {
        
    }];
}

- (void)followAction:(PubliButton *)button
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if ([sharedInfo.user_id isEqualToString:button.user_id]) {
        [self initMBProgress:@"不能关注自己" withModeType:MBProgressHUDModeText afterDelay:1.0];
        return;
    }
    
    //关注
    if ([button.status intValue] == 0) {
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
                [_userTabelView reloadData];
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
                [_userTabelView reloadData];
            }
        } failure:^(NSError *erro) {
            
        }];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)likeAction:(PubliButton *)button
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        LoginViewController *loginVC = [[LoginViewController  alloc]init];
        [loginVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    [self initMBProgress:@""];
    //点赞
    if ([button.isPraise intValue] == 0) {
        NSDictionary *parameters = @{@"Method":@"AddPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"PostID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
            [self setMBProgreeHiden:YES];
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self initMBProgress:@"点赞+1" withModeType:MBProgressHUDModeText afterDelay:1.5];
                int praisenum = [button.praisenum intValue];
                praisenum = praisenum + 1;
                
                /**
                 *  先删除原来的点赞数，然后再重新加上
                 */
                [self.likeDataArray removeObjectAtIndex:button.row];
                [self.likeDataArray insertObject:[NSString stringWithFormat:@"%d",praisenum] atIndex:button.row];
                
                /**
                 *  记录点赞状态
                 */
                [self.praiseDataArray removeObjectAtIndex:button.row];
                [self.praiseDataArray insertObject:@{@"postid":button.post_id,@"value":@"1"} atIndex:button.row];
                
                //点赞之后改变点赞的状态
                NSIndexPath *index =  [NSIndexPath indexPathForItem:button.row inSection:0];
                EveryoneTopicTableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
                cell.likeLabel.text = _likeDataArray[button.row];
                
                cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
                [_tableView reloadData];
            }else{
                [self initMBProgress:@"你已经赞过了" withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }else{  //取消点赞
        NSDictionary *parameters = @{@"Method":@"DelPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"PostID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
            [self setMBProgreeHiden:YES];
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self initMBProgress:@"取消点赞" withModeType:MBProgressHUDModeText afterDelay:1.5];
                int praisenum = [button.praisenum intValue];
                praisenum = praisenum - 1;
                
                /**
                 *  先删除原来的点赞数，然后再重新加上
                 */
                [self.likeDataArray removeObjectAtIndex:button.row];
                [self.likeDataArray insertObject:[NSString stringWithFormat:@"%d",praisenum] atIndex:button.row];
                
                /**
                 *  记录点赞状态
                 */
                [self.praiseDataArray removeObjectAtIndex:button.row];
                [self.praiseDataArray insertObject:@{@"postid":button.post_id,@"value":@"0"} atIndex:button.row];
                
                //点赞之后改变点赞的状态
                NSIndexPath *index =  [NSIndexPath indexPathForItem:button.row inSection:0];
                EveryoneTopicTableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
                cell.likeLabel.text = _likeDataArray[button.row];
                
                cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
                [_tableView reloadData];
            }else{
                [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }
}


-(void)segmentAction:(UISegmentedControl *)segmented{
    NSInteger index = segmented.selectedSegmentIndex;
    if (index == 0) {
        _tableView.hidden = NO;
        _userTabelView.hidden = YES;
        if (self.keyword.length > 0 && isArrEmpty(self.dataArray)) {
            [self getSearchContent:page keyword:self.keyword];
        }
        
    }else{
        _tableView.hidden = YES;
        _userTabelView.hidden = NO;
        if (self.keyword.length > 0 && isArrEmpty(self.userDataArray)) {
            [self getSearchUser:userPage keyword:self.keyword];
        }
    }
    NSLog(@"%ld",index);
}

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
