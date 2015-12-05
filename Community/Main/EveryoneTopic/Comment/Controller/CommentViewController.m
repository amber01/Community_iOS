//
//  CommentViewController.m
//  Community
//
//  Created by amber on 15/11/26.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTopView.h"
#import "CommentTableViewCell.h"
#import "CommentFootView.h"
#import "WriteCommentViewController.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView    *_tableView;
    CommentTopView *commentTopView;
    int            page;
}

@property (nonatomic,copy) NSString  *sortStr;

@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *likeDataArray;  //记录本地点赞的状态
@property (nonatomic,retain) NSMutableArray *praiseDataArray; //自己是否点赞的数据

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"评论";
    page = 1;
    self.sortStr = @"0"; //默认按照最新时间排序
    [self createCommentTopView];
    [self createTableView];
    [self createCommentFootView];
    [self getCommentListData:1];
    [self setupUploadMore];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataList) name:kReloadDataNotification object:nil];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, ScreenWidth, ScreenHeight - 64 - 42 - 42) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [UIUtils setExtraCellLineHidden:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

- (void)createCommentTopView
{
    commentTopView = [[CommentTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    [commentTopView.segmentedView addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:commentTopView];
}

- (void)createCommentFootView
{
    CommentFootView *commentFootView = [[CommentFootView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 42, ScreenWidth, 42)];
    [commentFootView.writeCommentBtn addTarget:self action:@selector(writeCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentFootView];
}

- (void)setupUploadMore{
    __unsafe_unretained __typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
- (void)loadMoreData{
    page = page + 1;
    [self getCommentListData:page];
    [_tableView.mj_footer endRefreshing];
}

#pragma makr -- NSNotification
- (void)reloadDataList
{
    page = 1;
    [self getCommentListData:page];
    [_tableView.mj_header endRefreshing];
}

#pragma mark -- HTTP
- (void)getCommentListData:(int)pageIndex
{
    [self initMBProgress:@""];
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *parameters = @{@"Method":@"ReCommentInfobyPostID",@"LoginUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":pageStr,@"Sort":self.sortStr,@"FldSortType":@"1",@"PostID":self.post_id}]};
    
    [CKHttpRequest createRequest:HTTP_METHOD_COMMENT WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        NSArray *items = [CommentModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *praiseItems = [result objectForKey:@"IsPraise"];
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
            [self.praiseDataArray removeAllObjects];
            [self.likeDataArray removeAllObjects];
        }
        
        for (int i = 0; i < items.count; i ++) {
            if (!self.dataArray) {
                self.dataArray = [[NSMutableArray alloc]init];
            }
            [self.dataArray addObject:[items objectAtIndex:i]];
        }
        
        for (int i = 0; i < praiseItems.count; i ++) {
            if (!self.praiseDataArray) {
                self.praiseDataArray = [[NSMutableArray alloc]init];
            }
            [self.praiseDataArray addObject:[praiseItems objectAtIndex:i]];
        }
        
        [self setMBProgreeHiden:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *erro) {
        
    }];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        [cell.likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CommentModel *model = self.dataArray[indexPath.row];
    
    if (!_likeDataArray) {
        self.likeDataArray = [[NSMutableArray alloc]init];
    }
    
    [_likeDataArray addObject:model.praisenum];
    
    if (!isArrEmpty(self.dataArray)) {
        [cell configureCellWithInfo:model withRow:indexPath.row andPraiseData:self.praiseDataArray];
    }
    
    if (!isArrEmpty(self.praiseDataArray)) {
        NSDictionary *dic = [self.praiseDataArray objectAtIndex:indexPath.row];
        cell.likeBtn.post_id = [dic objectForKey:@"commentid"];
        cell.likeBtn.isPraise = [dic objectForKey:@"value"];
    }
    
    cell.likeBtn.row = indexPath.row;
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
        NSDictionary *parameters = @{@"Method":@"AddCommentToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"CommentID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_COMMENT_LIKE WithParam:parameters withMethod:@"POST" success:^(id result) {
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
                [self.praiseDataArray insertObject:@{@"commentid":button.post_id,@"value":@"1"} atIndex:button.row];
                
                //点赞之后改变点赞的状态
                NSIndexPath *index =  [NSIndexPath indexPathForItem:button.row inSection:0];
                CommentTableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
                cell.likeLabel.text = _likeDataArray[button.row];
                
                cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
                [_tableView reloadData];
            }else{
                [self initMBProgress:@"你已经赞过了" withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }else{  //取消点赞
        NSDictionary *parameters = @{@"Method":@"DelCommentToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"CommentID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_COMMENT_LIKE WithParam:parameters withMethod:@"POST" success:^(id result) {
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
                [self.praiseDataArray insertObject:@{@"commentid":button.post_id,@"value":@"0"} atIndex:button.row];
                
                //点赞之后改变点赞的状态
                NSIndexPath *index =  [NSIndexPath indexPathForItem:button.row inSection:0];
                CommentTableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
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
        self.sortStr = @"0";
    }else if (index == 1){
        self.sortStr = @"1";
    }else{
        self.sortStr = @"0";
    }
    
    page = 1;
    [self getCommentListData:page];
    [_tableView.mj_header endRefreshing];
}

- (void)writeCommentAction
{
    WriteCommentViewController *writeCommentVC = [[WriteCommentViewController alloc]init];
    writeCommentVC.post_id = self.post_id;
    BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:writeCommentVC];
    [self.navigationController presentViewController:baseNav animated:YES completion:^{
        
    }];
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
