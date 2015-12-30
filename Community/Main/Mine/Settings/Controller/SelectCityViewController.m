//
//  SelectCityViewController.m
//  Community
//
//  Created by amber on 15/12/7.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "SelectCityViewController.h"
#import "ChineseString.h"
#import "KeychainIDFA.h"

@interface SelectCityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView     *_tableView;
    //UITableView     *currentCityTabelView;
}

@property (nonatomic,retain) NSArray        *resultArray;

@property (nonatomic,retain) NSMutableArray *cityArray;
@property (nonatomic,retain) NSMutableArray *indexArray;
//设置每个section下的cell内容
@property (nonatomic,retain) NSMutableArray *LetterResultArr;

@property (nonatomic,copy  ) NSString       *currentCity;
@property (nonatomic,copy  ) NSString       *currentProvince;

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
    if ([self.status intValue] != 2) {
        UIButton *backDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backDetailButton.frame = CGRectMake(0, 0, 30, 40);
        [backDetailButton setImage:[UIImage imageNamed:@"back_btn_image"] forState:UIControlStateNormal];
        [backDetailButton addTarget:self action:@selector(backWasClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backDetailButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -12;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backItem,nil];
    }

    self.title = @"选择城市";
    self.cityArray = [[NSMutableArray alloc]init];
    [self initTableView];
    //[self startLocation];
    [self getCityList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)backWasClicked
{
    if ([self.status intValue] == 1) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.mainVC setSelectedIndex:0];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- UI
- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = CELL_COLOR;
    [UIUtils setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
    
    //    currentCityTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44 + 30)];
    //    currentCityTabelView.delegate = self;
    //    currentCityTabelView.dataSource = self;
    //    currentCityTabelView.tag = 1001;
    //    currentCityTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.tableHeaderView = currentCityTabelView;
}

#pragma mark -- HTTP
- (void)getCityList
{
    NSDictionary *params = @{@"Method":@"ReSelectArea",@"Detail":@[@{@"Pid":@"330000",@"PageSize":@"700",@"PageIndex":@"1"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_CITY_LIST WithParam:params withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        
        if (result) {
            self.resultArray = [result objectForKey:@"Detail"];
            for (int i = 0; i < self.resultArray.count; i ++) {
                NSDictionary *dic = [self.resultArray objectAtIndex:i];
                [self.cityArray addObject:[dic objectForKey:@"area_city"]];
            }
            
            self.indexArray = [ChineseString IndexArray:self.cityArray];
            self.LetterResultArr = [ChineseString LetterSortArray:self.cityArray];
            
            [_tableView reloadData];
        }
    } failure:^(NSError *erro) {
        
    }];
}

#pragma mark -- LocationManange
-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"change");
}

////定位代理经纬度回调
//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//
//    //NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
//
//    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        for (CLPlacemark * placemark in placemarks) {
//
//            NSDictionary *test = [placemark addressDictionary];
//            //  Country(国家)  State(城市)  SubLocality(区)
//            self.currentProvince = [test objectForKey:@"State"];
//            self.currentCity     = [test objectForKey:@"City"];
//            [currentCityTabelView reloadData];
//            NSLog(@"%@", [test objectForKey:@"State"]);
//            NSLog(@"city：%@",[test objectForKey:@"City"]);
//
//        }
//    }];
//
//    [self.locationManager stopUpdatingLocation];
//}

#pragma mark -Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag != 1001) {
        NSString *key = [self.indexArray objectAtIndex:section];
        return key;
    }
    return @"定位";
}
#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag != 1001) {
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        sectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, sectionView.height/2-10, ScreenWidth, 20)];
        lab.font = [UIFont systemFontOfSize:14];
        lab.text = [self.indexArray objectAtIndex:section];
        lab.textColor = [UIColor blackColor];
        [sectionView addSubview:lab];
        return sectionView;
    }else{
        //        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        //        sectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];;
        //        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, sectionView.height/2-10, ScreenWidth, 20)];
        //        lab.font = [UIFont systemFontOfSize:14];
        //        lab.text = @"当前定位";
        //        lab.textColor = [UIColor blackColor];
        //        [sectionView addSubview:lab];
        //        return sectionView;
        return nil;
    }
}
#pragma mark - row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag != 1001) {
        return 20;
    }else{
        return 30;
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag != 1001) {
        return self.indexArray;
    }else{
        return @[@" "];
    }
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag != 1001) {
        return [self.indexArray count];
    }else{
        return 1;
    }
}
#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag != 1001) {
        return [[self.LetterResultArr objectAtIndex:section] count];
    }else{
        return 1;
    }
}
#pragma mark -每一行的内容为数组相应索引的值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag != 1001) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
        }
        
        cell.textLabel.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSString *cityName = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        if ([sharedInfo.cityarea isEqualToString:cityName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }else{
        static NSString *identityCell = @"cityCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        if (isStrEmpty(self.currentCity)) {
            cell.textLabel.text = @"正在定位中...";
        }else{
            SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
            if ([sharedInfo.cityarea isEqualToString:[self.currentCity stringByReplacingOccurrencesOfString:@"市" withString:@""]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = [self.currentCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
        }
        return cell;
    }
}
#pragma mark - Select内容为数组相应索引的值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
    NSString *cityName = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSLog(@"CITYname:%@",cityName);
    
    for (int i = 0; i < self.resultArray.count; i ++) {
        NSDictionary *dic = [self.resultArray objectAtIndex:i];
        if ([cityName isEqualToString:[dic objectForKey:@"area_city"]]) {
            NSString *city_id = [dic objectForKey:@"area_szcode"];
            shareInfo.city = city_id;
            NSLog(@"shareInfo.city:%@",city_id);
            [[NSUserDefaults standardUserDefaults] setObject:city_id forKey:@"city"];
            shareInfo.cityarea = [dic objectForKey:@"area_city"];
        }
    }
    
    //第一次使用app
    if ([self.status intValue] == 2) {
        NSDictionary *params = @{@"Method":@"SelectArea",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":@"",@"Detail":@[@{@"Udid":[KeychainIDFA IDFA],@"AreaID":shareInfo.city}]};
        [CKHttpRequest createRequest:HTTP_SELECT_CITY WithParam:params withMethod:@"POST" success:^(id result) {
            NSLog(@"resutlssd:%@",result);
            if (result && [[result objectForKey:@"Success"]intValue] >= 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"FinishLaunchingAPPNotifitcation" object:nil];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }else{
                [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.0];
            }
            
        } failure:^(NSError *erro) {
            
        }];
        //修改和第一次登录时候穿的
    }else if (isStrEmpty(self.status) || [self.status intValue] == 1){
        //已登录的情况下就调用修改
        if (!isStrEmpty(shareInfo.user_id)) {
            NSString *cityName = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            NSDictionary *params = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":@"",@"Detail":@[@{@"ID":isStrEmpty(shareInfo.user_id) ? @"" : shareInfo.user_id,@"Area":shareInfo.city,@"IsShow":@"5"}]};
            
            [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
                NSLog(@"resultddds:%@",result);
                NSLog(@"resultddds:%@",[result objectForKey:@"Msg"]);

                if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                    if ([self.status intValue] == 1) {
                        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [appDelegate.mainVC setSelectedIndex:0];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }else{
                    [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.0];
                }
                
            } failure:^(NSError *erro) {
                
            }];
        }else{ //未登录就Installed
            NSDictionary *params = @{@"Method":@"SelectArea",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":@"",@"Detail":@[@{@"Udid":[KeychainIDFA IDFA],@"AreaID":shareInfo.city}]};
            [CKHttpRequest createRequest:HTTP_SELECT_CITY WithParam:params withMethod:@"POST" success:^(id result) {
                NSLog(@"resutlssd:%@",result);
                if (result && [[result objectForKey:@"Success"]intValue] >= 0) {
                    if ([self.status intValue] == 1) {
                        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [appDelegate.mainVC setSelectedIndex:0];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }else{
                    [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.0];
                }
                
            } failure:^(NSError *erro) {
                
            }];
        }
    }
}

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.locationManager stopUpdatingLocation];
}

@end
