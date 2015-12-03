//
//  MineInfoViewController.m
//  Community
//
//  Created by amber on 15/11/28.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MineInfoViewController.h"
#import "WSHeaderView.h"
#import "MineInfoTopView.h"
#import "EveryoneTopicTableViewCell.h"

@interface MineInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView  *_tableView;
    WSHeaderView *_header;
    int          page;
}

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,retain) NSMutableArray *praiseDataArray;

@property (nonatomic,copy)   NSString       *fldSort;
@property (nonatomic,copy)   NSString       *isEssence;

@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人主页";
    [self createdTabelView];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"mine_share"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 25, 25);
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    page = 1;
    self.fldSort = @"0";
    self.isEssence = @"0";
    [self getEveryoneTopicData:1 withFldSort:@"0" andIsEssence:@"0"];
     [self setupUploadMore];
}

- (void)createdTabelView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //init headview
    _header = [[WSHeaderView alloc]init];
    
    //set header view
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216/2)];
    [imageView setImage:[UIImage imageNamed:@"mine_info_background"]];
    _header = [WSHeaderView expandWithScrollView:_tableView expandView:imageView];
    
    SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
    MineInfoTopView *mineInfoTopView = [[MineInfoTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150) withUserID:isStrEmpty(self.user_id) ? shareInfo.user_id : self.user_id andNickname:isStrEmpty(self.nickname) ? @"" : self.nickname andUserName:isStrEmpty(self.userName)? @"" : self.userName andAvararUrl:isStrEmpty(self.avatarUrl) ? @"" : self.avatarUrl];
    
    _tableView.tableHeaderView = mineInfoTopView;
}

- (void)setupUploadMore{
    __unsafe_unretained __typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
- (void)loadMoreData{
    page = page + 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence];
    [_tableView.mj_footer endRefreshing];
}

#pragma mark -- HTTP
- (void)getEveryoneTopicData:(int)pageIndex withFldSort:(NSString *)fldSort andIsEssence:(NSString *)isEssence
{
    SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
    [self initMBProgress:@"数据加载中..."];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *parameters = @{@"Method":@"RePostInfo",@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":pageStr,@"FldSort":fldSort,@"FldSortType":@"1",@"CityID":@"0",@"ProvinceID":@"0",@"IsEssence":isEssence,@"ClassID":@"",@"UserID":isStrEmpty(self.user_id) ? shareInfo.user_id : self.user_id}]};
    
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        
        NSArray *items = [EveryoneTopicModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *imageItems = [TodayTopicImagesModel arrayOfModelsFromDictionaries:[result objectForKey:@"Images"]];
        NSArray *praiseItems = [TodayTopicPraiseModel arrayOfModelsFromDictionaries:[result objectForKey:@"IsPraise"]];
        
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
        [_tableView reloadData];
    } failure:^(NSError *erro) {
        
    }];
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
    }
    
    EveryoneTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    TodayTopicPraiseModel *praiseModel = [self.praiseDataArray objectAtIndex:indexPath.row];
    //[cell configureCellWithInfo:model withImages:self.imagesArray andPraiseData:praiseModel];
    
    return cell;
}

//cell动态计算高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- action
- (void)shareAction
{
    
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
