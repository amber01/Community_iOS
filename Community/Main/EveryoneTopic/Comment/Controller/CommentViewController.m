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

@property (nonatomic,retain)NSMutableArray *dataArray;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"评论";
    page = 1;
    [self createCommentTopView];
    [self createTableView];
    [self createCommentFootView];
    [self getCommentListData:1];
    [self setupUploadMore];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, ScreenWidth, ScreenHeight - 64 - 42 - 42) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

- (void)createCommentTopView
{
    commentTopView = [[CommentTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
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

#pragma mark -- HTTP
- (void)getCommentListData:(int)pageIndex
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *parameters = @{@"Method":@"ReCommentInfobyPostID",@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":pageStr,@"Sort":@"0",@"FldSortType":@"1",@"PostID":self.post_id}]};
    
    [CKHttpRequest createRequest:HTTP_METHOD_COMMENT WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        NSArray *items = [EveryoneTopicModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        for (int i = 0; i < items.count; i ++) {
            if (!self.dataArray) {
                self.dataArray = [[NSMutableArray alloc]init];
            }
            [self.dataArray addObject:[items objectAtIndex:i]];
        }
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
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- action
- (void)writeCommentAction
{
    WriteCommentViewController *writeCommentVC = [[WriteCommentViewController alloc]init];
    BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:writeCommentVC];
    [self.navigationController presentViewController:baseNav animated:YES completion:^{
        
    }];
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
