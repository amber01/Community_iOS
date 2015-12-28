//
//  CheckTopicDetailViewController.m
//  Community
//
//  Created by amber on 15/12/27.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "CheckTopicDetailViewController.h"
#import "EveryoneTopicTableViewCell.h"
#import "TopicSearchTableViewCell.h"
#import "MineInfoViewController.h"
#import "CheckMoreView.h"
#import "CheckTopicTopView.h"
#import "TopicDetailViewController.h"

@interface CheckTopicDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView    *_tableView;
    int            page;
    BOOL           isSearch;
    
    BOOL           isFirst;
    BOOL           isShowMore;
    CheckTopicTopView  *checkTopicTopView;
    CheckMoreView *checkMoreView;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,retain) NSMutableArray *praiseDataArray; //自己是否点赞的数据
@property (nonatomic,retain) NSMutableArray *likeDataArray;  //记录本地点赞的状态
@property (nonatomic,retain) NSMutableArray *fansDtaArray;
@property (nonatomic,copy)   NSString       *fldSort;
@property (nonatomic,copy)   NSString       *isEssence;


@end

@implementation CheckTopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    page = 1;
    self.view.backgroundColor = CELL_COLOR;
    self.title = @"话题";
    self.fldSort = @"0";
    self.isEssence = @"0";
    
    [self getEveryoneTopicData:1 withFldSort:self.fldSort andIsEssence:self.isEssence keyword:self.keyword];
    
    //内容下拉
    [self setupRefreshHeaderWithTopic];
    [self setupUploadMoreWithTopic];
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
    checkTopicTopView = [[CheckTopicTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    checkTopicTopView.topicLabel.text = [NSString stringWithFormat:@"#%@#",self.keyword];
    _tableView.tableHeaderView = checkTopicTopView;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 100, checkTopicTopView.height - 40, 90, 40)];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(showMoreView) forControlEvents:UIControlEventTouchUpInside];
    [checkTopicTopView addSubview:button];

    
    [self.view addSubview:_tableView];
}

- (void)showMoreView
{
    if (!checkMoreView) {
        checkMoreView = [[CheckMoreView alloc]initWithFrame:CGRectMake(ScreenWidth - 135,  checkTopicTopView.height - 10, 130, 120)];
        checkMoreView.hidden = YES;
        [checkMoreView.latestSendBtn addTarget:self action:@selector(checkNewSendAction) forControlEvents:UIControlEventTouchUpInside];
        [checkMoreView.lastCommentBtn addTarget:self action:@selector(checkLastCommentAction) forControlEvents:UIControlEventTouchUpInside];
        [checkMoreView.lookGoodBtn addTarget:self action:@selector(checklookGoodAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (isFirst) {
            [checkMoreView.latestSendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        
        [_tableView addSubview:checkMoreView];
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
    
#pragma mark MJRefresh
- (void)setupRefreshHeaderWithTopic{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopicData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    checkTopicTopView.lastTimeLabel.text = header.lastUpdatedTimeLabel.text;
    _tableView.mj_header = header;
}

- (void)setupUploadMoreWithTopic{
    __unsafe_unretained __typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreTopicData];
    }];
}

- (void)loadNewTopicData{
    page = 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence keyword:self.keyword];
    [_tableView.mj_header endRefreshing];
}

- (void)loadMoreTopicData{
    page = page + 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence keyword:self.keyword];
    [_tableView.mj_footer endRefreshing];
}

#pragma mark -- UITableViewDelegate
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
    
    if (tableView.tag == 1000) {
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else{
        return 45 + 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TopicDetailViewController *topicDetailVC = [[TopicDetailViewController alloc]init];
    EveryoneTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    topicDetailVC.post_id = model.id;
    topicDetailVC.user_id = model.userid;
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

#pragma mark -- action

- (void)checkNewSendAction
{
    self.fldSort = @"0";
    self.isEssence = @"0";
    page = 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence keyword:self.keyword];
    checkTopicTopView.sendTitle.text = @"最新发布";
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
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence keyword:self.keyword];
    checkTopicTopView.sendTitle.text = @"最后评论";
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
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence keyword:self.keyword];
    checkTopicTopView.sendTitle.text = @"只看精华";
    [checkMoreView.latestSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkMoreView.lastCommentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkMoreView.lookGoodBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    checkMoreView.hidden= YES;
}


//帖子
- (void)getEveryoneTopicData:(int)pageIndex withFldSort:(NSString *)fldSort andIsEssence:(NSString *)isEssence keyword:(NSString *)keyword
{
    SharedInfo *sharedInfo  = [SharedInfo sharedDataInfo];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
        NSDictionary *parameters = @{@"Method":@"RePostInfo",@"LoginUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":pageStr,@"FldSort":fldSort,@"FldSortType":@"1",@"CityID":@"0",@"ProvinceID":@"0",@"IsEssence":isEssence,@"ClassID":@"",@"SearchKey":keyword}]};

    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if ([[result objectForKey:@"Detail"]count] < 1) {
            //[self initMBProgress:@"未找到相关的内容" withModeType:MBProgressHUDModeText afterDelay:1.5];
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
