//
//  DiscoverViewController.m
//  Community
//
//  Created by shlity on 16/4/6.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverView.h"
#import "DiscoverTableViewCell.h"

@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int     page;
}

@property (nonatomic,retain)DiscoverView    *discoverView;
@property (nonatomic,retain)UITableView     *tableView;
@property (nonatomic,retain)NSMutableArray  *dataArray;
@property (nonatomic,retain)NSMutableArray  *imagesArray;
@end

@implementation DiscoverViewController

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

- (void)initViews
{
    [self discoverView];
    [self createTableView];
}

#pragma mark -- UI
- (UITableView *)createTableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 55, ScreenWidth, ScreenHeight - _discoverView.height - 64 - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (DiscoverView *)discoverView
{
    if (!_discoverView) {
        _discoverView = [[DiscoverView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        for (int i = 200; i <= _discoverView.topTabbarBtn.tag; i ++) {
            UIButton *tempBtn = (UIButton *)[_discoverView viewWithTag:i];
            [tempBtn addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:_discoverView];
    }return _discoverView;
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
        NSArray *imageItems = [FriendSquareImageModel arrayOfModelsFromDictionaries:[result objectForKey:@"Images"]];
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
            [self.imagesArray removeAllObjects];
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
    }
    return cell;
}


#pragma mark -- action
- (void)onClickAction:(UIButton *)button
{

    NSArray *imageNormalArray = @[@"discover_friend_square_normal.png",
                                  @"discover_topic_normal.png",
                                  @"discover_find_friend_normal.png",
                                  @"discover_find_topic_normal.png"];
    
    NSArray *imageHighArray   = @[@"discover_friend_square_high.png",
                                  @"discover_topic_high.png",
                                  @"discover_find_friend_high.png",
                                  @"discover_find_topic_high.png"];
    
    for (int i = 200; i <= _discoverView.topTabbarBtn.tag; i ++) {
        UIButton *tempBtn = (UIButton *)[_discoverView viewWithTag:i];
        if (i == button.tag) {
           [tempBtn setImage:[UIImage imageNamed:[imageHighArray objectAtIndex:i - 200]] forState:UIControlStateNormal];
            [tempBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        }else{
            [tempBtn setImage:[UIImage imageNamed:[imageNormalArray objectAtIndex:i - 200]] forState:UIControlStateNormal];
            [tempBtn setTitleColor:TEXT_COLOR1 forState:UIControlStateNormal];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _discoverView.lineView.frame;
        frame.origin.x = (button.tag - 200) * ScreenWidth/4;
        _discoverView.lineView.frame = frame;
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
