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


@interface TopicBlockViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    TopicBlockTopView *topicBlockTopView;
    int    page;
    CheckMoreView *checkMoreView;
    BOOL    isShowMore;
    BOOL    isFirst;
}

@property (nonatomic,retain) UITableView    *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *imagesArray;

@property (nonatomic,copy)   NSString       *fldSort;
@property (nonatomic,copy)   NSString       *isEssence;

@end

@implementation TopicBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"板块";
    self.view.backgroundColor = [UIColor whiteColor];
    
    topicBlockTopView = [[TopicBlockTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45 + 30 + 10 + 15 + 15 + 10)withImageName:self.imageName];
    topicBlockTopView.backgroundColor = [UIColor whiteColor];
    topicBlockTopView.blockNameLabel.text = self.blockName;
    [self.view addSubview:topicBlockTopView];
    
    [self setupTableView];
    
    page = 1;
    self.fldSort = @"0";
    self.isEssence = @"0";
    [self getEveryoneTopicData:1 withFldSort:@"0" andIsEssence:@"0"];
    isFirst = YES;
    

    
    [self setupRefreshHeader];
    [self setupUploadMore];
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

#pragma mark -- action
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
    topicBlockTopView.topicHeadView.sendTitle.text = @"只看精华";
    [checkMoreView.latestSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkMoreView.lastCommentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkMoreView.lookGoodBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    checkMoreView.hidden= YES;
}


#pragma mark -- HTTP
- (void)getEveryoneTopicData:(int)pageIndex withFldSort:(NSString *)fldSort andIsEssence:(NSString *)isEssence
{
    [self initMBProgress:@"数据加载中..."];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *parameters = @{@"Method":@"RePostInfo",@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":pageStr,@"FldSort":fldSort,@"FldSortType":@"1",@"CityID":@"0",@"ProvinceID":@"0",@"IsEssence":isEssence,@"ClassID":self.cate_id}]};
    
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        
        NSArray *items = [EveryoneTopicModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *imageItems = [TodayTopicImagesModel arrayOfModelsFromDictionaries:[result objectForKey:@"Images"]];
        
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
        [self setMBProgreeHiden:YES];
        [self.tableView reloadData];
    } failure:^(NSError *erro) {
        
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
    }
    
    EveryoneTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configureCellWithInfo:model withImages:self.imagesArray];
    
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
}


@end

