//
//  EveryoneTopicViewController.m
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "EveryoneTopicViewController.h"
#import "EvenyoneTopView.h"
#import "EveryoneTopicTableViewCell.h"
#import "EveryoneTopicHeadView.h"
#import "EveryoneTopicModel.h"
#import "CheckMoreView.h"
#import "PopMenu.h"
#import "SendTopicViewController.h"
#import "TopicSearchViewController.h"
#import "TopicDetailViewController.h"

@interface EveryoneTopicViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    int    page;
    EvenyoneTopView *topView;
    CheckMoreView *checkMoreView;
    BOOL    isShowMore;
    BOOL    isFirst;
    PopMenu *_popMenu;
}

@property (nonatomic,retain) UITableView    *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,retain) NSMutableArray *praiseDataArray; //自己是否点赞的数据

@property (nonatomic,copy)   NSString       *fldSort;
@property (nonatomic,copy)   NSString       *isEssence;

@property (nonatomic,retain) NSMutableArray *likeDataArray;  //记录本地点赞的状态
@property (nonatomic,retain) NSArray        *cateArray;

@end

@implementation EveryoneTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"大家在聊";
    self.view.backgroundColor = CELL_COLOR;
    [self setupTableView];
    page = 1;
    self.fldSort = @"0";
    self.isEssence = @"0";
    [self getEveryoneTopicData:1 withFldSort:@"0" andIsEssence:@"0"];
    
    [self setupRefreshHeader];
    [self setupUploadMore];
    isFirst = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginFinish) name:kSendIsLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataList) name:kReloadDataNotification object:nil];
    
    CustomButtonItem *buttonItem = [[CustomButtonItem alloc]initButtonItem:[UIImage imageNamed:@"today_send_topic.png"]];
    [buttonItem.itemBtn addTarget:self action:@selector(selectSendCat) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    [leftBtn setImage:[UIImage imageNamed:@"topic_search_icon"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.cateArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13"];
}

- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        topView = [[EvenyoneTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 190 + 50)];
        [topView.topicHeadView.sendCatBtn addTarget:self action:@selector(showMoreView) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableHeaderView = topView;
        [topView setupTopButton:2];
    }
    return _tableView;
}

- (void)showMoreView
{
    if (!checkMoreView) {
        checkMoreView = [[CheckMoreView alloc]initWithFrame:CGRectMake(ScreenWidth - 135,  topView.height - 10, 130, 120)];
        checkMoreView.hidden = YES;
        [checkMoreView.latestSendBtn addTarget:self action:@selector(checkNewSendAction) forControlEvents:UIControlEventTouchUpInside];
        [checkMoreView.lastCommentBtn addTarget:self action:@selector(checkLastCommentAction) forControlEvents:UIControlEventTouchUpInside];
        [checkMoreView.lookGoodBtn addTarget:self action:@selector(checklookGoodAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (isFirst) {
            [checkMoreView.latestSendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        
        [self.tableView addSubview:checkMoreView];
    }
    
    if (isShowMore == YES) {
        [self hidenView];
        isShowMore = NO;
        return;
    }
    
    @weakify(self)
    checkMoreView.hidden = NO;
    checkMoreView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.3
                     animations:^{
                         checkMoreView.transform = CGAffineTransformMakeScale(1, 1);
                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:0.1
                                          animations:^{
                                              @strongify(self)
                                              checkMoreView.transform = CGAffineTransformMakeScale(1, 1);
                                              UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenView)];
                                              singleTap.delegate = self;
                                              [self.view addGestureRecognizer:singleTap];
                                              isShowMore = YES;
                                          }completion:^(BOOL finish){
                                              [UIView animateWithDuration:3
                                                               animations:^{
                                                                   
                                                               }completion:^(BOOL finish){
                                                                   
                                                               }];
                                          }];
                     }];
}

- (void)hidenView
{
    isFirst = NO;
    checkMoreView.hidden= YES;
}

#pragma mark -- Notification
- (void)loginFinish
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark -- action
- (void)checkNewSendAction
{
    self.fldSort = @"0";
    self.isEssence = @"0";
    page = 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence];
    topView.topicHeadView.sendTitle.text = @"最新发布";
    [checkMoreView.latestSendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [checkMoreView.lastCommentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkMoreView.lookGoodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkMoreView.hidden= YES;
}

- (void)checkLastCommentAction
{
    self.fldSort = @"6";
    self.isEssence = @"0";
    page = 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence];
    topView.topicHeadView.sendTitle.text = @"最后评论";
    [checkMoreView.lastCommentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [checkMoreView.latestSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkMoreView.lookGoodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkMoreView.hidden= YES;
}

- (void)checklookGoodAction
{
    self.fldSort = @"6";
    self.isEssence = @"1";
    page = 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence];
    topView.topicHeadView.sendTitle.text = @"只看精华";
    [checkMoreView.latestSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkMoreView.lastCommentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkMoreView.lookGoodBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    checkMoreView.hidden= YES;
}

- (void)searchAction
{
    TopicSearchViewController *topicSearchVC = [[TopicSearchViewController alloc]init];
    [topicSearchVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:topicSearchVC animated:YES];
}

-(void)selectSendCat
{
    SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(shareInfo.user_id)) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [loginVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    
    MenuItem *menuItem = [MenuItem itemWithTitle:@"同城互动" iconName:@"topic_send_city"];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"秀自拍" iconName:@"topic_send_show" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"百姓话题" iconName:@"topic_send_people" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"看资讯" iconName:@"topic_send_information" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"聊美食" iconName:@"topic_send_food" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"去哪玩" iconName:@"topic_send_play" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"谈感情" iconName:@"topic_send_feeling" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"搞笑吧" iconName:@"topic_send_funny" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"育儿经" iconName:@"topic_send_education" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"爱健康" iconName:@"topic_send_health" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"灌水区" iconName:@"topic_send_community" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"供求信息" iconName:@"topic_send_shareinfo" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"提建议" iconName:@"topic_send_suggestion" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    
    if (!_popMenu) {
        _popMenu = [[PopMenu alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) items:items];
        _popMenu.perRowItemCount = 4;
        _popMenu.menuAnimationType = kPopMenuAnimationTypeNetEase;
    }
    if (_popMenu.isShowed) {
        return;
    }
    @weakify(self)
    _popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
        @strongify(self)
        SendTopicViewController *sendTopVC = [[SendTopicViewController alloc]init];
        sendTopVC.title = selectedItem.title;
        sendTopVC.cate_id = self.cateArray[selectedItem.index];
        BaseNavigationController *navi =[[BaseNavigationController alloc] initWithRootViewController:sendTopVC];
        [self.navigationController presentViewController:navi animated:YES completion:^{
            
        } ];
    };
    [_popMenu showMenuAtView:self.view.window];
}

#pragma mark -- HTTP
- (void)getEveryoneTopicData:(int)pageIndex withFldSort:(NSString *)fldSort andIsEssence:(NSString *)isEssence
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *parameters = @{@"Method":@"RePostInfo",@"LoginUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":pageStr,@"FldSort":fldSort,@"FldSortType":@"1",@"CityID":@"0",@"ProvinceID":@"0",@"IsEssence":isEssence,@"ClassID":@"",@"Area":isStrEmpty(sharedInfo.city) ? @"" : sharedInfo.city}]};
    
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        NSLog(@"msg:%@",[result objectForKey:@"Msg"]);
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
        
        [self.tableView reloadData];
    } failure:^(NSError *erro) {
        [self setMBProgreeHiden:YES];
    }];
}

#pragma mark MJRefresh
- (void)setupRefreshHeader{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    topView.topicHeadView.lastTimeLabel.text = header.lastUpdatedTimeLabel.text;
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
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData{
    page = page + 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -- NSNotificationCenter
- (void)reloadDataList
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    topView.topicHeadView.lastTimeLabel.text = header.lastUpdatedTimeLabel.text;
    [header beginRefreshing];
    _tableView.mj_header = header;
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EveryoneTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    TopicDetailViewController *topicDetaiVC = [[TopicDetailViewController alloc]init];
    topicDetaiVC.post_id = model.id;
    topicDetaiVC.user_id = model.userid;
    [topicDetaiVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:topicDetaiVC animated:YES];
}

#pragma mark -- action
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

#pragma mark--
#pragma mark--UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [checkMoreView removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
