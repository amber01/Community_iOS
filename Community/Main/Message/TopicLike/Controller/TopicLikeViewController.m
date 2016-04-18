//
//  TopicLikeViewController.m
//  Community
//
//  Created by amber on 15/12/11.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicLikeViewController.h"
#import "MsgCommentTopView.h"
#import "TopicLikeTableViewCell.h"
#import "TopicSendTableViewCell.h"
#import "TopicDetailViewController.h"

@interface TopicLikeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UITableView *_sendTabelView;
    MsgCommentTopView *commentTopView;
    
    int         page;
    int         sendPage;
    BOOL        isMyReceiveStatus;
}

@property (nonatomic,retain)NSMutableArray  *dataArray;
@property (nonatomic,retain)NSMutableArray  *sendCommentArray;

@end

@implementation TopicLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帖子点赞";
    [self createCommentTopView];
    [self createTableView];
    
    page = 1;
    sendPage = 1;
    
    [self getMyReceiveComment:1];
    
    [self setupRefreshHeaderWithReceive];
    [self setupUploadMoreWithReceive];
    
    [self setupRefreshHeaderWithSend];
    [self setupUploadMoreWithSend];
    
    isMyReceiveStatus = YES;
}

#pragma mark -- UI

- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tag = 1000;
    _tableView.hidden = NO;
    [UIUtils setExtraCellLineHidden:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    _sendTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _sendTabelView.dataSource = self;
    _sendTabelView.delegate = self;
    _sendTabelView.hidden = YES;
    [UIUtils setExtraCellLineHidden:_sendTabelView];
    _sendTabelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sendTabelView];
}

- (void)createCommentTopView
{
    commentTopView = [[MsgCommentTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [commentTopView.myReceiveCommentBtn addTarget:self action:@selector(getMyReceiveCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [commentTopView.mySendCommentBtn addTarget:self action:@selector(getMySendCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentTopView];
}

#pragma mark MJRefresh
- (void)setupRefreshHeaderWithReceive{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewReceiveData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
}

- (void)setupUploadMoreWithReceive{
    __unsafe_unretained __typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreReceiveData];
    }];
}

- (void)loadNewReceiveData{
    if (isMyReceiveStatus == YES) {
        page = 1;
        [self getMyReceiveComment:page];
    }
    [_tableView.mj_header endRefreshing];
}

- (void)loadMoreReceiveData{
    if (isMyReceiveStatus == YES) {
        page = page + 1;
        [self getMyReceiveComment:page];
    }
    [_tableView.mj_footer endRefreshing];
}

//我发出的
- (void)setupRefreshHeaderWithSend{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewSendData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _sendTabelView.mj_header = header;
}

- (void)setupUploadMoreWithSend{
    __unsafe_unretained __typeof(self) weakSelf = self;
    _sendTabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreSendData];
    }];
}

- (void)loadNewSendData{
    if (isMyReceiveStatus == NO) {
        sendPage = 1;
        [self getMySendComment:sendPage];
    }
    [_sendTabelView.mj_header endRefreshing];
}

- (void)loadMoreSendData{
    if (isMyReceiveStatus == NO) {
        sendPage = sendPage + 1;
        [self getMySendComment:sendPage];
    }
    [_sendTabelView.mj_footer endRefreshing];
}

#pragma mark -- HTTP
//我收到的
- (void)getMyReceiveComment:(int)pageIndex
{
    SharedInfo *sharedInfo  = [SharedInfo sharedDataInfo];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    
    NSDictionary *parameters = @{@"Method":@"RePostToPraise",@"RunnerUserID":sharedInfo.user_id,@"Detail":@[@{@"ToUserID":sharedInfo.user_id,@"IsShow":@"888",@"PageIndex":pageStr,@"PageSize":@"20",@"FldSortType":@"1"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if (result) {
            NSArray *items = [TopicLikeModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
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

//我发出的
- (void)getMySendComment:(int)pageIndex
{
    SharedInfo *sharedInfo  = [SharedInfo sharedDataInfo];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    
    NSDictionary *parameters = @{@"Method":@"RePostToPraise",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"IsShow":@"888",@"PageIndex":pageStr,@"PageSize":@"20",@"FldSortType":@"1"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if (result) {
            NSArray *items = [TopicLikeModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
            if (sendPage == 1) {
                [self.sendCommentArray removeAllObjects];
            }
            for (int i = 0; i < items.count; i ++) {
                if (!self.sendCommentArray) {
                    self.sendCommentArray = [[NSMutableArray alloc]init];
                }
                [self.sendCommentArray addObject:[items objectAtIndex:i]];
            }
        }
        [_sendTabelView reloadData];
    } failure:^(NSError *erro) {
        
    }];
    
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        return self.dataArray.count;
    }else{
        return self.sendCommentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        static NSString *identityCell = @"cell";
        TopicLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cell) {
            cell = [[TopicLikeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        }
        TopicLikeModel *model = self.dataArray[indexPath.row];
        [cell configureWithCellInfo:model];
        return cell;
    }else{
        static NSString *identityCell = @"sendCommentCell";
        TopicSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cell) {
            cell = [[TopicSendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        }
        TopicLikeModel *model = self.sendCommentArray[indexPath.row];
        [cell configureWithCellInfo:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1000) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        TopicLikeModel *model = self.dataArray[indexPath.row];
        TopicDetailViewController *topicDetailVC = [[TopicDetailViewController alloc]init];
        topicDetailVC.post_id = model.postid;
        topicDetailVC.user_id = model.touserid;
        [self.navigationController pushViewController:topicDetailVC animated:YES];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        TopicLikeModel *model = self.sendCommentArray[indexPath.row];
        TopicDetailViewController *topicDetailVC = [[TopicDetailViewController alloc]init];
        topicDetailVC.post_id = model.postid;
        topicDetailVC.user_id = model.touserid;
        [self.navigationController pushViewController:topicDetailVC animated:YES];
    }
}

#pragma mark -- action
- (void)getMyReceiveCommentAction
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = commentTopView.lineView.frame;
        frame.origin.x = 0;
        commentTopView.lineView.frame = frame;
        [commentTopView.myReceiveCommentBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [commentTopView.mySendCommentBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    }];
    _tableView.hidden = NO;
    _sendTabelView.hidden = YES;
    isMyReceiveStatus = YES;
    if (isArrEmpty(self.dataArray)) {
        [self getMyReceiveComment:page];
    }
}

- (void)getMySendCommentAction
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = commentTopView.lineView.frame;
        frame.origin.x = ScreenWidth/2;
        commentTopView.lineView.frame = frame;
        [commentTopView.myReceiveCommentBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [commentTopView.mySendCommentBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    }];
    
    isMyReceiveStatus = NO;
    _tableView.hidden = YES;
    _sendTabelView.hidden = NO;
    if (isArrEmpty(self.sendCommentArray)) {
        [self getMySendComment:sendPage];
    }
}

-(void)segmentAction:(UISegmentedControl *)segmented{
    NSInteger index = segmented.selectedSegmentIndex;
    if (index == 0) {
        _tableView.hidden = NO;
        _sendTabelView.hidden = YES;
        if (isArrEmpty(self.dataArray)) {
            [self getMyReceiveComment:page];
        }
    }else{
        _tableView.hidden = YES;
        _sendTabelView.hidden = NO;
        if (isArrEmpty(self.sendCommentArray)) {
            [self getMySendComment:sendPage];
        }
    }
    NSLog(@"%ld",index);
}
#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

