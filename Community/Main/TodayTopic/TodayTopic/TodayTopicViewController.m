//
//  TodayTopicViewController.m
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TodayTopicViewController.h"
#import "TopicDetailViewController.h"
#import "JXBAdPageView.h"
#import "TodayTopicTableViewCell.h"
#import "PopMenu.h"
#import "SendTopicViewController.h"
#import "NSString+MyCategory.h"
#import "TodayTopicMoreTableViewCell.h"
#import "WebDetailViewController.h"

@interface TodayTopicViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    PopMenu *_popMenu;
    int     page;
}

@property (nonatomic,retain) UITableView    *tableView;
@property (nonatomic,retain) JXBAdPageView  *adView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,retain) NSArray        *cateArray;

@end

@implementation TodayTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日有料";
    self.view.backgroundColor = VIEW_COLOR;
    [self setupTableView];
    [self setupRefreshHeader];
    [self setupUploadMore];
    
    page = 1;
    
    CustomButtonItem *buttonItem = [[CustomButtonItem alloc]initButtonItem:[UIImage imageNamed:@"today_send_topic.png"]];
    [buttonItem.itemBtn addTarget:self action:@selector(selectSendCat) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    [self getTodayTopicDataInfo:1];
    self.cateArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.adView startTimerPlay];
}

#pragma mark -- HTTP
- (void)getTodayTopicDataInfo:(int)pageIndex
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *parameters = @{@"Method":@"RePostInfo",@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"2",@"PageIndex":pageStr,@"FldSort":@"3",@"FldSortType":@"1"}]};
    
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSArray *items = [TodayTopicModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *imageItems = [TodayTopicImagesModel arrayOfModelsFromDictionaries:[result objectForKey:@"Images"]];
        
        NSLog(@"detail:%@",result);
        
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

- (void)getAdImageData
{
    NSDictionary *parameters = @{@"Method":@"ReAdvertis",@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":@"1",@"TypeID":@"3",@"STypeID":@"5"}]};
    
    [CKHttpRequest createRequest:HTTP_COMMAND_ADVERTIS WithParam:parameters withMethod:@"POST" success:^(id result) {
        if (self.adView) {
            
            NSMutableArray *imageArray = [[NSMutableArray alloc]init];
            NSArray *detailArray = [result objectForKey:@"Detail"];
            NSLog(@"detailArray:%@",detailArray);
            for (int i = 0; i < detailArray.count; i ++ ) {
                NSDictionary *dic = [detailArray objectAtIndex:i];
                NSString *tempStr = [dic objectForKey:@"filename"];
                NSString *filedomain = [dic objectForKey:@"filedomain"];
                NSString *imageStr = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",filedomain],BASE_IMAGE_URL,guanggao,tempStr];
                [imageArray addObject:imageStr];
            }
            
            [_adView getCurrentAdData:detailArray];
            [_adView startAdsWithBlock:imageArray block:^(NSInteger clickIndex) {
                NSDictionary *dic = detailArray[clickIndex];
                NSString     *url = [dic objectForKey:@"linkaddress"];
                WebDetailViewController *webDetailVC = [[WebDetailViewController alloc]init];
                webDetailVC.url = url;
                [webDetailVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:webDetailVC animated:YES];
            }];
        }
        [self.tableView reloadData];
    } failure:^(NSError *erro) {
        
    }];
}

- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _adView = [[JXBAdPageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, scaleToScreenHeight * 180)];
        _tableView.tableHeaderView = _adView;
        _adView.iDisplayTime = 3;
        _adView.bWebImage = YES;
        [self.view addSubview:_tableView];
        [self getAdImageData];
    }
    return _tableView;
}

- (void)setupRefreshHeader{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    //[header beginRefreshing];
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
    [self getAdImageData];
    [self getTodayTopicDataInfo:page];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData{
    page = page + 1;
    [self getTodayTopicDataInfo:page];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([model.imagecount intValue] > 1) {
        static NSString *identityCell = @"cell1";
        TodayTopicMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cell) {
            cell = [[TodayTopicMoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        }
        [cell configureCellWithInfo:model withImages:self.imagesArray];
        return cell;
    }else{
        static NSString *identityCell = @"cell2";
        TodayTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cell) {
            cell = [[TodayTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        }
        [cell configureCellWithInfo:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TodayTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model.imagecount intValue] > 1) {
        return 99*scaleToScreenHeight;
    }else{
        return 80*scaleToScreenHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TodayTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    TopicDetailViewController *detailVC = [[TopicDetailViewController alloc]init];
    detailVC.post_id = model.id;
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- action
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

#pragma mark -- ohter
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.adView.myTimer invalidate];
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
