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
#import "EveryoneLeftItemView.h"
#import "TopicSearchViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TodayTopicViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate>
{
    PopMenu *_popMenu;
    int     page;
    BOOL    isSelectCity;
    UIImageView *headLogImageView;
}

@property (nonatomic,retain) UITableView          *tableView;
@property (nonatomic,retain) JXBAdPageView        *adView;
@property (nonatomic,retain) NSMutableArray       *dataArray;
@property (nonatomic,retain) NSArray              *cateArray;
@property (nonatomic,retain) EveryoneLeftItemView *everyoneLeftItemView;
@property (nonatomic,retain)CLLocationManager     *locationManage;

@end

@implementation TodayTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"今日有料";
    self.view.backgroundColor = VIEW_COLOR;
    [self setupTableView];
    [self setupRefreshHeader];
    [self setupUploadMore];
    
    [self everyoneLeftItemView];
    
    page = 1;
    

    CustomButtonItem *buttonItem = [[CustomButtonItem alloc]initButtonItem:[UIImage imageNamed:@"home_top_search.png"]];
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
    _everyoneLeftItemView.hidden = NO;
    [self getCurrentCityName];
    [self.adView startTimerPlay];
    
    [self createLocationManage];
}

#pragma mark -- Location
-(void)createLocationManage
{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        if (!_locationManage) {
            //定位初始化
            _locationManage=[[CLLocationManager alloc] init];
            _locationManage.delegate=self;
            _locationManage.desiredAccuracy=kCLLocationAccuracyBest;
            _locationManage.distanceFilter=10;
            [_locationManage startUpdatingLocation];//开启定位
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                [_locationManage requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
            }
        }
        
    }else {
        //提示用户无法进行定位操作
        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请开启定位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    }
    // 开始定位
    [_locationManage startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    //    当前的经度
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    sharedInfo.latitude = [[NSString alloc]
                       initWithFormat:@"%f",
                       newLocation.coordinate.latitude];
    //NSLog(@"currentLatitude:%@",currentLatitude);
    
    //    当前的纬度
    sharedInfo.longitude = [[NSString alloc]
                        initWithFormat:@"%f",
                        newLocation.coordinate.longitude];
    
    //定位城市通过CLGeocoder
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            sharedInfo.tempProvincearea = placemark.administrativeArea;
            sharedInfo.tempCityarea = placemark.locality;
        }
    }];

}


#pragma mark -- NSNotificationCenter
- (void)reloadDataList
{
    page = 1;
    [self getTodayTopicDataInfo:page];
}

#pragma mark -- HTTP
- (void)getTodayTopicDataInfo:(int)pageIndex
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"RePostInfo",@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"2",@"PageIndex":pageStr,@"FldSort":@"3",@"FldSortType":@"1",@"Area":isStrEmpty(sharedInfo.city) ? @"" : sharedInfo.city}]};
    
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        
        NSLog(@"result:%@",result);
        NSArray *items = [TodayTopicModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        for (int i = 0; i < items.count; i ++) {
            if (!self.dataArray) {
                self.dataArray = [[NSMutableArray alloc]init];
            }
            [self.dataArray addObject:[items objectAtIndex:i]];
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

- (EveryoneLeftItemView *)everyoneLeftItemView
{
    if (!_everyoneLeftItemView) {
        _everyoneLeftItemView = [[EveryoneLeftItemView alloc]initWithFrame:CGRectMake(0, 20, 120, 44)];
        [_everyoneLeftItemView.leftBtn addTarget:self action:@selector(selectCityAction) forControlEvents:UIControlEventTouchUpInside];
        [self getCurrentCityName];
        [self.navigationController.view addSubview:_everyoneLeftItemView];
    }
    return _everyoneLeftItemView;
}

- (void)getCurrentCityName
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    
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
    _everyoneLeftItemView.titleLabel.text = cityName;
}

- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [UIUtils setExtraCellLineHidden:_tableView];
        _adView = [[JXBAdPageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, scaleToScreenHeight * 150)]; //scaleToScreenHeight * 180
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, (scaleToScreenHeight * 150) + 10)];
        headerView.backgroundColor = VIEW_COLOR;
        [headerView addSubview:_adView];
        _tableView.tableHeaderView = headerView;
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
    
    if ([model.istreephoto intValue] == 1) { //3张图片
        static NSString *identityCell = @"cell1";
        TodayTopicMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (!cell) {
            cell = [[TodayTopicMoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        }
        [cell configureCellWithInfo:model];
        return cell;
    }else{ //1张图片
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
    if ([model.istreephoto intValue] == 1) {
        return 30 + 28 + 5 + (80 *scaleToScreenHeight);
    }else{
        return 85;
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

/**
 *  选择城市
 */
- (void)selectCityAction
{
    SelectCityViewController    *selectCityVC = [[SelectCityViewController alloc]init];
    [selectCityVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:selectCityVC animated:YES];
    
//    BaseNavigationController    *baseNav = [[BaseNavigationController alloc]initWithRootViewController:selectCityVC];
//    
//    [self.navigationController presentViewController:baseNav animated:YES completion:^{
//        
//    }];
}

-(void)selectSendCat
{
    TopicSearchViewController *topicSearchVC = [[TopicSearchViewController alloc]init];
    [topicSearchVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:topicSearchVC animated:YES];
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
    _everyoneLeftItemView.hidden = YES;
    [super viewWillDisappear:YES];
    [_locationManage stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end