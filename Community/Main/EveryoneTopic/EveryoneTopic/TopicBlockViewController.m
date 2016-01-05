//
//  TopicBlockViewController.m
//  Community
//
//  Created by amber on 15/11/28.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicBlockViewController.h"
#import "TopicBlockTopView.h"
#import "EveryoneTopicTableViewCell.h"
#import "EveryoneTopicModel.h"
#import "CheckMoreView.h"
#import "PopMenu.h"
#import "SendTopicViewController.h"
#import "TopicSendNavigationView.h"
#import "SendTopicBtnView.h"
#import "TopicDetailViewController.h"

@interface TopicBlockViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    TopicBlockTopView *topicBlockTopView;
    int    page;
    CheckMoreView *checkMoreView;
    BOOL    isShowMore;
    BOOL    isFirst;
    PopMenu *_popMenu;
    TopicSendNavigationView *sendNavigationView;
    SendTopicBtnView      *sendTopicBtnView;
    BOOL  isHidenSendView;
}

@property (nonatomic,retain) UITableView    *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,retain) NSMutableArray *praiseDataArray;

@property (nonatomic,copy)   NSString       *fldSort;
@property (nonatomic,copy)   NSString       *isEssence;

@property (nonatomic,retain) NSMutableArray *likeDataArray;  //记录本地点赞的状态
@property (nonatomic,retain) NSMutableArray *isLikeDataArray;  //是否已经点赞

@property (nonatomic,retain) NSArray        *cateArray;

@end

@implementation TopicBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([_cate_id intValue] == 12) {
        topicBlockTopView = [[TopicBlockTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45 + 30 + 10 + 15 + 15 + 10 + 54)withImageName:self.imageName wihtIsShowSubView:YES];
        NSDictionary *parameters = @{@"Method":@"ReClassInfo",@"Detail":@[@{@"TableName":@"postinfo",@"IsShow":@"888",@"PageIndex":@"1",@"PageSize":@"100",@"ParentID":@"12"}]};
        [CKHttpRequest createRequest:HTTP_SUB_CLASS_CATE WithParam:parameters withMethod:@"POST" success:^(id result) {
            if (result) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SubCateDataNotification" object:[result objectForKey:@"Detail"]];
            }
        } failure:^(NSError *erro) {
            
        }];
    }else{
        topicBlockTopView = [[TopicBlockTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45 + 30 + 10 + 15 + 15 + 10)withImageName:self.imageName wihtIsShowSubView:NO];
    }
    
    topicBlockTopView.backgroundColor = [UIColor whiteColor];
    CustomButtonItem *buttonItem = [[CustomButtonItem alloc]initButtonItem:[UIImage imageNamed:@"today_send_topic.png"]];
    [buttonItem.itemBtn addTarget:self action:@selector(selectSendCat) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    topicBlockTopView.blockNameLabel.text = self.blockName;
    [self.view addSubview:topicBlockTopView];
    
    [self setupTableView];
    
    page = 1;
    self.fldSort = @"0";
    self.isEssence = @"0";
    [self getEveryoneTopicData:1 withFldSort:@"0" andIsEssence:@"0"];
    isFirst = YES;
    
    self.cateArray = @[@"11",@"1",@"2",@"3",@"4",@"5",@"6",@"12",@"7",@"9",@"10",@"8",@"13"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginFinish) name:kSendIsLoginNotification object:nil];
    
    sendNavigationView = [[TopicSendNavigationView alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth - 200, 64)];
    [sendNavigationView setNavigationTitle:@"板块"];
    UITapGestureRecognizer *tapGestureSinge = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCatTap)];
    [sendNavigationView addGestureRecognizer:tapGestureSinge];
    [self.navigationController.view addSubview:sendNavigationView];
    
    [self setupRefreshHeader];
    [self setupUploadMore];
    
    NSLog(@"cuuuuuuL%@",_cate_id);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    sendNavigationView.hidden = NO;
}

- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = topicBlockTopView;
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 100, topicBlockTopView.height - 40, 90, 40)];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(showMoreView) forControlEvents:UIControlEventTouchUpInside];
        [topicBlockTopView addSubview:button];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)showMoreView
{
    if (!checkMoreView) {
        checkMoreView = [[CheckMoreView alloc]initWithFrame:CGRectMake(ScreenWidth - 135,  topicBlockTopView.height - 10, 130, 120)];
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
- (void)changeCatTap
{
    if (!sendTopicBtnView) {
        sendTopicBtnView = [[SendTopicBtnView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        for (int i = 100; i < sendTopicBtnView.mineBtn.tag + 1; i ++) {
            UIButton *button = (UIButton *)[sendTopicBtnView viewWithTag:i];
            [button addTarget:self action:@selector(onClickPageOne:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:sendTopicBtnView];
    }
    if (!isHidenSendView) {
        sendTopicBtnView.hidden = NO;
        isHidenSendView = YES;
    }else{
        sendTopicBtnView.hidden = YES;
        isHidenSendView = NO;
    }
    [self.view endEditing:YES];
}

- (void)onClickPageOne:(UIButton *)button
{
    self.cate_id = self.cateArray[button.tag - 100];
    NSLog(@"current cati :%@",_cate_id);
    page = 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence];
    
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSString *cityName;
    
    NSRange foundObj=[sharedInfo.cityarea rangeOfString:@"城区"];  // options:NSCaseInsensitiveSearch
    if(foundObj.length>0){
        cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"城区" withString:@""];
    }else{
        NSRange foundObj2 = [sharedInfo.cityarea rangeOfString:@"县"];
        if (foundObj2.length > 0) {
            cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"县" withString:@""];
        }else{
            NSRange foundObj3 = [sharedInfo.cityarea rangeOfString:@"区"];
            if (foundObj3.length > 0) {
                cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"区" withString:@""];
            }else{
                cityName = sharedInfo.cityarea;
            }
        }
    }
    
    NSString *tempCityName = [NSString stringWithFormat:@"%@热点",cityName];
    
    NSArray *titleArr = @[@"本地散件",@"同城互助",@"秀自拍",@"相亲交友",tempCityName,@"吃货吧",@"去哪玩",@"供求信息",@"男女情感",@"汽车之家",@"健康养生",@"轻松一刻",@"提建议"];
    NSArray *btnImage = @[@"topic_send_community",@"topic_send_city",@"topic_send_show",@"topic_send_people",@"topic_send_information",@"topic_send_food",@"topic_send_play",@"topic_send_shareinfo",@"topic_send_feeling",@"topic_send_education",@"topic_send_health",@"topic_send_funny",@"topic_send_suggestion"];
    topicBlockTopView.blockNameLabel.text = titleArr[button.tag - 100];
    if ([_cate_id intValue] == 12) {
        [topicBlockTopView setTopImageIcon:btnImage[button.tag - 100] withIsShowSubView:YES];
        topicBlockTopView.frame = CGRectMake(0, 0, ScreenWidth, 45 + 30 + 10 + 15 + 15 + 10 + 54);
        _tableView.tableHeaderView = topicBlockTopView;
        
        NSDictionary *parameters = @{@"Method":@"ReClassInfo",@"Detail":@[@{@"TableName":@"postinfo",@"IsShow":@"888",@"PageIndex":@"1",@"PageSize":@"100",@"ParentID":@"12"}]};
        [CKHttpRequest createRequest:HTTP_SUB_CLASS_CATE WithParam:parameters withMethod:@"POST" success:^(id result) {
            if (result) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SubCateDataNotification" object:[result objectForKey:@"Detail"]];
            }
        } failure:^(NSError *erro) {
            
        }];
        
    }else{
        [topicBlockTopView setTopImageIcon:btnImage[button.tag - 100] withIsShowSubView:NO];
        topicBlockTopView.frame = CGRectMake(0, 0, ScreenWidth, 45 + 30 + 10 + 15 + 15 + 10);
        _tableView.tableHeaderView = topicBlockTopView;
    }
    
    sendTopicBtnView.hidden = YES;
    isHidenSendView = NO;
}

- (void)checkNewSendAction
{
    self.fldSort = @"0";
    self.isEssence = @"0";
    page = 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence];
    topicBlockTopView.topicHeadView.sendTitle.text = @"最新发布";
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
    topicBlockTopView.topicHeadView.sendTitle.text = @"最后评论";
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
    topicBlockTopView.topicHeadView.sendTitle.text = @"最多评论";
    [checkMoreView.latestSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkMoreView.lastCommentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkMoreView.lookGoodBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    checkMoreView.hidden= YES;
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
    
    SendTopicViewController *sendTopVC = [[SendTopicViewController alloc]init];
    sendTopVC.title = self.blockName;
    sendTopVC.cate_id = self.cate_id;
    BaseNavigationController *navi =[[BaseNavigationController alloc] initWithRootViewController:sendTopVC];
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    } ];
}


#pragma mark -- HTTP
- (void)getEveryoneTopicData:(int)pageIndex withFldSort:(NSString *)fldSort andIsEssence:(NSString *)isEssence
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    [self initMBProgress:@"数据加载中..."];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *parameters = @{@"Method":@"RePostInfo",@"LoginUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":pageStr,@"FldSort":fldSort,@"FldSortType":@"1",@"CityID":@"",@"ProvinceID":@"",@"IsEssence":isEssence,@"ClassID":self.cate_id,@"Area":sharedInfo.city}]};
    
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSString *allTopicCount = [result objectForKey:@"Counts"];
        NSString *todayTopicCount = [result objectForKey:@"ClassPostDayNum"];
        topicBlockTopView.topicNumberLabel.text = [NSString stringWithFormat:@"总帖数：%@",allTopicCount];
        topicBlockTopView.todayNumberLabel.text = [NSString stringWithFormat:@"今日：%@",todayTopicCount];
        
        NSArray *items = [EveryoneTopicModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *imageItems = [TodayTopicImagesModel arrayOfModelsFromDictionaries:[result objectForKey:@"Images"]];
        NSArray *praiseItems = [result objectForKey:@"IsPraise"];
        NSLog(@"result:%@",result);
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
        
        [self setMBProgreeHiden:YES];
        [self.tableView reloadData];
    } failure:^(NSError *erro) {
        [self setMBProgreeHiden:YES];
    }];
}

#pragma mark MJRefresh
- (void)setupRefreshHeader{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    topicBlockTopView.topicHeadView.lastTimeLabel.text = header.lastUpdatedTimeLabel.text;
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
    
    cell.likeBtn.post_id = model.id;
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

//cell动态计算高度
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
    
    //点赞
    if ([button.isPraise intValue] == 0) {
        NSDictionary *parameters = @{@"Method":@"AddPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIp":@"1",@"Detail":@[@{@"PostID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
            
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
        NSDictionary *parameters = @{@"Method":@"DelPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIp":@"1",@"Detail":@[@{@"PostID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
            
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    sendNavigationView.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [checkMoreView removeFromSuperview];
    [sendNavigationView removeFromSuperview];
}


@end
