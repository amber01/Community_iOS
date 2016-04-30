//
//  DiscoverFriendSquareViewController.m
//  Community
//
//  Created by amber on 16/4/10.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverFriendSquareViewController.h"
#import "DiscoverTableViewCell.h"
#import "CCTipsView.h"

@interface DiscoverFriendSquareViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int         page;
    float       height;
    CCTipsView *tipsView;
}

@property (nonatomic,retain)UITableView             *tableView;
@property (nonatomic,retain)NSMutableArray          *dataArray;
@property (nonatomic,retain)NSMutableDictionary     *heightsCache;
@property (nonatomic,retain)NSMutableArray          *likeDataArray;//记录本地点赞的状态
@property (nonatomic,retain)NSMutableArray          *praiseDataArray;//自己是否点赞的数据

@end

@implementation DiscoverFriendSquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"发现";
    
    page  = 1;
    [self initViews];
    [self getDiscoverData:page];
    
    [self setupRefreshHeader];
    [self setupUploadMore];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (sharedInfo.user_id.length == 0) {
        if (!tipsView) {
            tipsView = [[CCTipsView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            tipsView.imageView.hidden = YES;
            tipsView.tipsLabel.text = @"您还未登录，请登录后查看";
            tipsView.backgroundColor = VIEW_COLOR;
            [tipsView.onClickBtn setTitle:@"立即登录" forState:UIControlStateNormal];
            tipsView.onClickBtn.hidden = NO;
            [tipsView.onClickBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
            [_tableView addSubview:tipsView];
        }
        tipsView.hidden = NO;
    }
}

- (void)initViews
{
    [self createTableView];
}

#pragma mark -- UI
- (UITableView *)createTableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -2, ScreenWidth, ScreenHeight  - 64 - 49  - 12) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [UIUtils setExtraCellLineHidden:_tableView];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
        _tableView.backgroundColor = VIEW_COLOR;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -- HTTP
- (void)getDiscoverData:(int)pageIndex
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"RePengyouQuan",
                                 @"RunnerUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,
                                 @"RunnerIsClient":@"1",
                                 @"Detail":@[@{@"UserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,
                                               @"PageSize":@"20",
                                               @"IsShow":@"888",
                                               @"PageIndex":pageStr,
                                               @"FldSort":@"0",
                                               @"FldSortType":@"1",
                                               }]};
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
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
    [self getDiscoverData:page];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData{
    page = page + 1;
    [self getDiscoverData:page];
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
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyCell];
    if (!cell) {
        cell = [[DiscoverTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyCell];
        [cell.likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    FriendSquareModel *model = nil;
    model = [self.dataArray objectAtIndex:indexPath.row];
    cell.likeBtn.row = indexPath.row;
    
    [cell configureCellWithInfo:model];
    
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return 70 + contentHeight.height + height + 20 + 14 + 17  - 5;
}

#pragma mark -- action
- (void)onClickAction:(UIButton *)button
{
    
}

- (void)loginAction
{
    LoginViewController *loginVC = [[LoginViewController  alloc]init];
    [loginVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:loginVC animated:YES];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
