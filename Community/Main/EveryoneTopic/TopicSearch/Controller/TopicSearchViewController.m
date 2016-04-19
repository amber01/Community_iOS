
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
#import "DiscoverTableViewCell.h"
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
    BOOL        isSearchContent;
    float       height;
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
    
    [self createTableView];
    page = 1;
    userPage = 1;
    self.view.backgroundColor = CELL_COLOR;

    searchTopView = [[TopicSearchTopView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth, ScreenHeight)];
    [searchTopView.searchContentBtn addTarget:self action:@selector(searchContentAction) forControlEvents:UIControlEventTouchUpInside];
    [searchTopView.searchUserBtn addTarget:self action:@selector(searchUserAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchTopView];
    
    [self customBackView];
    
    //内容下拉
    [self setupRefreshHeaderWithTopic];
    [self setupUploadMoreWithTopic];
    
    //用户下拉
    [self setupRefreshHeaderWithUser];
    [self setupUploadMoreWithUser];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tag = 1000;
    _tableView.hidden = NO;
    [UIUtils setExtraCellLineHidden:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    _userTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _userTabelView.dataSource = self;
    _userTabelView.delegate = self;
    _userTabelView.hidden = YES;
    [UIUtils setExtraCellLineHidden:_userTabelView];
    _userTabelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_userTabelView];
}


- (void)customBackView
{
    topicSearchBarView = [[TopicSearchBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 70, 32)];
    topicSearchBarView.myTextField.delegate = self;
    if (isStrEmpty(self.searchStatus)) {
        topicSearchBarView.myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索内容" attributes:@{NSForegroundColorAttributeName:  [UIColor whiteColor]}];
        _userTabelView.hidden = YES;
        _tableView.hidden = NO;
        _userTabelView.hidden = YES;
        isSearchContent = YES;
    }else{
        topicSearchBarView.myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索用户" attributes:@{NSForegroundColorAttributeName:  [UIColor whiteColor]}];
        _tableView.hidden = YES;
        _userTabelView.hidden = NO;
        isSearchContent = NO;
        _userTabelView.hidden = NO;
    }
    [topicSearchBarView.cleaBtn addTarget:self action:@selector(cleaAction) forControlEvents:UIControlEventTouchUpInside];
    [topicSearchBarView.myTextField becomeFirstResponder];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithCustomView:topicSearchBarView];
    self.navigationItem.rightBarButtonItem = searchItem;
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
    
    if (isSearchContent == YES) {
        page = 1;
        [self getSearchContent:page keyword:self.keyword];
    }
    [_tableView.mj_header endRefreshing];
}

- (void)loadMoreTopicData{
    if (isSearchContent == YES) {
        page = page + 1;
        [self getSearchContent:page keyword:self.keyword];
    }
    [_tableView.mj_footer endRefreshing];
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
    if (isSearchContent == NO) {
        userPage = 1;
        [self getSearchUser:page keyword:self.keyword];
    }
    [_userTabelView.mj_header endRefreshing];
}

- (void)loadMoreUserData{
    if (isSearchContent == NO) {
        userPage = userPage + 1;
        [self getSearchUser:page keyword:self.keyword];
    }
    [_userTabelView.mj_footer endRefreshing];
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
        static NSString *identifyCell = @"cell";
        DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyCell];
        if (!cell) {
            cell = [[DiscoverTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyCell];
            [cell.likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        FriendSquareModel *model = nil;
        model = [self.dataArray objectAtIndex:indexPath.row];
        cell.likeBtn.row = indexPath.row;
        
        NSLog(@"names:%@",model.name);
        
        [cell configureCellWithInfo:model];
        
        [cell.contentLabel setTextColor:[UIColor greenColor] withText:topicSearchBarView.myTextField.text];
        
        if (!_likeDataArray) {
            self.likeDataArray = [[NSMutableArray alloc]init];
        }
        [_likeDataArray addObject:model.praisenum];
        
        cell.likeImageView.image = [UIImage imageNamed:@"discover_find_friend_high"];
        
        cell.likeBtn.post_id = model.id;
        cell.likeBtn.isPraise = _praiseDataArray[indexPath.row];
        
        cell.likeLabel.text = _likeDataArray[indexPath.row];
        cell.likeBtn.praisenum = _likeDataArray[indexPath.row];
        
        if ([_praiseDataArray[indexPath.row]intValue] > 0) {
            cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
        }else{
            cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
        }
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
        [cell.textLabel setTextColor:[UIColor greenColor] withText:topicSearchBarView.myTextField.text];
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
        FriendSquareModel *model = nil;
        model = [self.dataArray objectAtIndex:indexPath.row];
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        CGSize contentHeight = [model.describe boundingRectWithSize:CGSizeMake(ScreenWidth - 45 - 20 - 10 - 15, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        NSArray *imageArray = [model.images componentsSeparatedByString:@","];
        
        if (model.describe.length == 0) {
            contentHeight.height = 0;
        }
        
        if (imageArray.count > 1) {
            if (imageArray.count <= 3) {
                height = (((ScreenWidth - 45 - 20 - 10 - 15)/3)-5);
            }else if (imageArray.count >3 && imageArray.count<= 6){
                height = ((((ScreenWidth - 45 - 20 - 10 - 15)/3)-5)*2)+5;
            }else if (imageArray.count > 6){
                height = ((((ScreenWidth - 45 - 20 - 10 - 15)/3)-5)*3)+10;
            }
        }else if (imageArray.count == 1){
            int tempWidth;
            int imageMaxWidth = ScreenWidth - 45 - 20 - 10 - 15;
            if ([model.width intValue] >= imageMaxWidth) {
                tempWidth = imageMaxWidth;
                float scaleToHeight = [model.width intValue] - imageMaxWidth;
                height = ([model.height intValue]) - scaleToHeight;
            }else{
                height = [model.height intValue];
            }
        }
        return 70 + contentHeight.height + height + 20 + 14 + 17 - 5;
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

#pragma mark -- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //帖子
    if (isSearchContent == YES) {
        if (topicSearchBarView.myTextField.text.length == 0) {
            [self initMBProgress:@"关键字不能为空" withModeType:MBProgressHUDModeText afterDelay:1.0];
        }else{
            self.keyword = topicSearchBarView.myTextField.text;
            [self getSearchContent:page keyword:self.keyword];
        }
    }else{ //用户
        if (topicSearchBarView.myTextField.text.length == 0) {
            [self initMBProgress:@"关键字不能为空" withModeType:MBProgressHUDModeText afterDelay:1.0];
        }else{
            self.keyword = topicSearchBarView.myTextField.text;
            [self getSearchUser:userPage keyword:self.keyword];
        }
    }
    
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- action
- (void)cleaAction
{
    topicSearchBarView.myTextField.text = @"";
    searchTopView.hidden = NO;
}

- (void)searchContentAction
{
    topicSearchBarView.myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索内容" attributes:@{NSForegroundColorAttributeName:  [UIColor whiteColor]}];
    _tableView.hidden = NO;
    _userTabelView.hidden = YES;
    isSearchContent = YES;
    //    if (self.keyword.length > 0 && isArrEmpty(self.dataArray)) {
    //        [self getSearchContent:page keyword:self.keyword];
    //    }
}

- (void)searchUserAction
{
    topicSearchBarView.myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索用户" attributes:@{NSForegroundColorAttributeName:  [UIColor whiteColor]}];
    _tableView.hidden = YES;
    _userTabelView.hidden = NO;
    isSearchContent = NO;
    //    if (self.keyword.length > 0 && isArrEmpty(self.userDataArray)) {
    //        [self getSearchUser:userPage keyword:self.keyword];
    //    }
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
        searchTopView.hidden = YES;
        NSArray *items = [FriendSquareModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *tempArr = [result objectForKey:@"Detail"];
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
            [_praiseDataArray removeAllObjects];
        }
        
        for (int i = 0; i < items.count; i ++) {
            if (!self.dataArray) {
                self.dataArray = [[NSMutableArray alloc]init];
            }
            [self.dataArray addObject:[items objectAtIndex:i]];
        }
        
        for (int i = 0; i < tempArr.count; i ++) {
            if (!_praiseDataArray) {
                _praiseDataArray = [NSMutableArray new];
            }
            NSDictionary *dic = tempArr[i];
            [_praiseDataArray insertObject:[dic objectForKey:@"ispraise"] atIndex:i];
        }
        
        NSLog(@"dataArraya:%@",_dataArray);
        
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
            searchTopView.hidden = YES;
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
                [self.praiseDataArray insertObject:@"1" atIndex:button.row];
                
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
                [self.praiseDataArray insertObject:@"0" atIndex:button.row];
                [_tableView reloadData];
            }else{
                [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [topicSearchBarView.myTextField resignFirstResponder];
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
