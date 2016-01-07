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
#import "SelectCityViewController.h"

@interface TodayTopicViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    PopMenu *_popMenu;
    int     page;
    BOOL    isSelectCity;
    UIImageView *headLogImageView;
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
    //self.title = @"今日有料";
    self.view.backgroundColor = VIEW_COLOR;
    [self setupTableView];
    [self setupRefreshHeader];
    [self setupUploadMore];
    
    page = 1;
    
    CustomButtonItem *buttonItem = [[CustomButtonItem alloc]initButtonItem:[UIImage imageNamed:@"today_send_topic.png"]];
    [buttonItem.itemBtn addTarget:self action:@selector(selectSendCat) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = buttonItem;
    headLogImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-55, 27, 111, 29)];
    [headLogImageView setImage:[UIImage imageNamed:@"today_topic_log"]];
    [self.navigationController.view addSubview:headLogImageView];
    [self getTodayTopicDataInfo:1];
    self.cateArray = @[@"11",@"1",@"2",@"3",@"4",@"5",@"6",@"12",@"7",@"9",@"10",@"8",@"13"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataList) name:kReloadDataNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBtnTitle) name:kChangeCityNameNotification object:nil];
    /**
     *  第一次使用app
     */
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isFistUseApp"]intValue] == 0) {
        SelectCityViewController *selectCityVC = [[SelectCityViewController alloc]init];
        selectCityVC.status = @"2";
        selectCityVC.fristLoad = @"1";
        
        BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:selectCityVC];
        [self.navigationController presentViewController:baseNav animated:YES completion:^{
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isFistUseApp"]; //是否第一次使用app
        }];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    headLogImageView.hidden = NO;
    [self.adView startTimerPlay];
}

#pragma mark -- NSNotificationCenter
- (void)reloadDataList
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    _tableView.mj_header = header;
}

#pragma mark -- HTTP
- (void)getTodayTopicDataInfo:(int)pageIndex
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"RePostInfo",@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"2",@"PageIndex":pageStr,@"FldSort":@"3",@"FldSortType":@"1",@"Area":isStrEmpty(sharedInfo.city) ? @"" : sharedInfo.city}]};
    
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSArray *items = [TodayTopicModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *imageItems = [TodayTopicImagesModel arrayOfModelsFromDictionaries:[result objectForKey:@"Images"]];
        
        NSLog(@"detail2:%@",result);
        
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
    NSDictionary *parameters = @{@"Method":@"ReAdvertis",@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":@"1",@"TypeID":@"3",@"STypeID":@"5",@"AreaID":isStrEmpty([[NSUserDefaults standardUserDefaults] objectForKey:@"city"]) ? @"" : [[NSUserDefaults standardUserDefaults] objectForKey:@"city"]}]};
    
    [CKHttpRequest createRequest:HTTP_COMMAND_ADVERTIS WithParam:parameters withMethod:@"POST" success:^(id result) {
        if (result) {
            if (self.adView) {
                
                NSLog(@"resulaat:%@",result);
                NSLog(@"resulaat:%@",[result objectForKey:@"Msg"]);
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
                
                if (detailArray.count < 1) {
                    return ;
                }
                
                [_adView getCurrentAdData:detailArray];
                [_adView startAdsWithBlock:imageArray block:^(NSInteger clickIndex) {
                    NSDictionary *dic = detailArray[clickIndex];
                    NSString     *url = [dic objectForKey:@"linkaddress"];
                    NSString     *status = [dic objectForKey:@"width"]; //width = 0表示链接URL地址,=1表示链接app帖子
                    NSString     *post_id = [dic objectForKey:@"height"];
                    if ([status intValue] == 0) {
                        WebDetailViewController *webDetailVC = [[WebDetailViewController alloc]init];
                        webDetailVC.url = url;
                        [webDetailVC setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:webDetailVC animated:YES];
                    }else{
                        TopicDetailViewController *topicDetailVC = [[TopicDetailViewController alloc]init];
                        [topicDetailVC setHidesBottomBarWhenPushed:YES];
                        topicDetailVC.post_id = post_id;
                        [self.navigationController pushViewController:topicDetailVC animated:YES];
                    }
                }];
            }
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
        [UIUtils setExtraCellLineHidden:_tableView];
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
        return 28 + 5 + (80 *scaleToScreenHeight);
    }else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TodayTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    TopicDetailViewController *detailVC = [[TopicDetailViewController alloc]init];
    detailVC.post_id = model.id;
    detailVC.user_id = model.userid;
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)changeBtnTitle
{
    isSelectCity = YES;
}


#pragma mark -- action
-(void)selectSendCat
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [loginVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }

    
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
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    
    MenuItem *menuItem = [MenuItem itemWithTitle:@"本地散讲" iconName:@"topic_send_community"];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"同城互助" iconName:@"topic_send_city"];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"秀自拍" iconName:@"topic_send_show" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"相亲交友" iconName:@"topic_send_people" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:tempCityName iconName:@"topic_send_information" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"吃货吧" iconName:@"topic_send_food" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"去哪玩" iconName:@"topic_send_play" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"供求信息" iconName:@"topic_send_shareinfo" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"男女情感" iconName:@"topic_send_feeling" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"汽车之家" iconName:@"topic_send_education" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"健康养生" iconName:@"topic_send_health" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"轻松一刻" iconName:@"topic_send_funny" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"提建议" iconName:@"topic_send_suggestion" glowColor:[UIColor clearColor]];
    [items addObject:menuItem];
    
    if (!_popMenu | isSelectCity) {
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
    isSelectCity = NO;
}

#pragma mark -- ohter
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.adView.myTimer invalidate];
    headLogImageView.hidden = YES;
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end