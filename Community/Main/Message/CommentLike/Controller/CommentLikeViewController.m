//
//  CommentLikeViewController.m
//  Community
//
//  Created by amber on 15/12/11.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "CommentLikeViewController.h"
#import "MsgCommentTopView.h"
#import "CommentSendTableViewCell.h"
#import "CommentLikeTableViewCell.h"


@interface CommentLikeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UITableView *_sendTabelView;
    MsgCommentTopView *commentTopView;
    
    int         page;
    int         sendPage;
}

@property (nonatomic,retain)NSMutableArray  *dataArray;
@property (nonatomic,retain)NSMutableArray  *sendCommentArray;

@end

@implementation CommentLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论点赞";
    [self createCommentTopView];
    [self createTableView];
    
    page = 1;
    sendPage = 1;
    
    [self getMyReceiveComment:1];
    
    [self setupRefreshHeaderWithReceive];
    [self setupUploadMoreWithReceive];
    
    [self setupRefreshHeaderWithSend];
    [self setupUploadMoreWithSend];
}

#pragma mark -- UI

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
    
    _sendTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, ScreenWidth, ScreenHeight - 64 - 42) style:UITableViewStylePlain];
    _sendTabelView.dataSource = self;
    _sendTabelView.delegate = self;
    _sendTabelView.hidden = YES;
    [UIUtils setExtraCellLineHidden:_sendTabelView];
    _sendTabelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sendTabelView];
}

- (void)createCommentTopView
{
    commentTopView = [[MsgCommentTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    [commentTopView.segmentedView addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
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
    if (commentTopView.segmentedView.selectedSegmentIndex == 0) {
        page = 1;
        [self getMyReceiveComment:page];
    }
    [_tableView.mj_header endRefreshing];
}

- (void)loadMoreReceiveData{
    if (commentTopView.segmentedView.selectedSegmentIndex == 0) {
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
    if (commentTopView.segmentedView.selectedSegmentIndex == 1) {
        sendPage = 1;
        [self getMySendComment:sendPage];
    }
    [_sendTabelView.mj_header endRefreshing];
}

- (void)loadMoreSendData{
    if (commentTopView.segmentedView.selectedSegmentIndex == 1) {
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
    
    NSDictionary *parameters = @{@"Method":@"ReCommentToPraise",@"RunnerUserID":sharedInfo.user_id,@"Detail":@[@{@"ToUserID":sharedInfo.user_id,@"IsShow":@"888",@"PageIndex":pageStr,@"PageSize":@"20",@"FldSortType":@"1"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_COMMENT_LIKE WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if (result) {
            NSArray *items = [CommentLikeModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
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
    
    NSDictionary *parameters = @{@"Method":@"ReCommentToPraise",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"IsShow":@"888",@"PageIndex":pageStr,@"PageSize":@"20",@"FldSortType":@"1"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_COMMENT_LIKE WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if (result) {
            NSArray *items = [CommentLikeModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
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
        CommentLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cell) {
            cell = [[CommentLikeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        }
        CommentLikeModel *model = self.dataArray[indexPath.row];
        [cell configureWithCellInfo:model];
        return cell;
    }else{
        static NSString *identityCell = @"sendCommentCell";
        CommentSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cell) {
            cell = [[CommentSendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        }
        CommentLikeModel *model = self.sendCommentArray[indexPath.row];
        [cell configureWithCellInfo:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- action
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

