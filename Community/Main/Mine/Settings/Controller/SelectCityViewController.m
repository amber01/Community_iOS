//
//  SelectCityViewController.m
//  Community
//
//  Created by amber on 15/12/7.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "SelectCityViewController.h"
#import "ChineseString.h"

@interface SelectCityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView     *_tableView;
    UITableView     *currentCityTabelView;
}

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
    self.title = @"选择城市";
    self.cityArray = [[NSMutableArray alloc]init];
    [self initTableView];
    [self startLocation];
    [self getCityList];
}

#pragma mark -- UI
- (void)initTableView
{
    currentCityTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44 + 30)];
    currentCityTabelView.delegate = self;
    currentCityTabelView.dataSource = self;
    currentCityTabelView.tag = 1001;
    [self.view addSubview:currentCityTabelView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, currentCityTabelView.bottom, ScreenWidth, ScreenHeight - 64 - currentCityTabelView.height)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark -- HTTP
- (void)getCityList
{
    NSDictionary *params = @{@"Method":@"ReArea",@"Detail":@[@{@"Pid":@"330000",@"PageSize":@"100",@"PageIndex":@"1"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_CITY_LIST WithParam:params withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        
        if (result) {
            NSArray *items = [result objectForKey:@"Detail"];
            for (int i = 0; i < items.count; i ++) {
                NSDictionary *dic = [items objectAtIndex:i];
                [self.cityArray addObject:[dic objectForKey:@"area_city"]];
            }

            self.indexArray = [ChineseString IndexArray:self.cityArray];
            self.LetterResultArr = [ChineseString LetterSortArray:self.cityArray];
            
            NSLog(@"indext:%@",self.indexArray );
            NSLog(@":%@",self.LetterResultArr);
            [_tableView reloadData];
        }
    } failure:^(NSError *erro) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            self.currentProvince = [test objectForKey:@"State"];
            self.currentCity     = [test objectForKey:@"City"];
            [currentCityTabelView reloadData];
            NSLog(@"%@", [test objectForKey:@"State"]);
            NSLog(@"city：%@",[test objectForKey:@"City"]);
            
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
}

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
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        sectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, sectionView.height/2-10, ScreenWidth, 20)];
        lab.font = [UIFont systemFontOfSize:14];
        lab.text = @"当前定位";
        lab.textColor = [UIColor blackColor];
        [sectionView addSubview:lab];
        return sectionView;
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
            cell.textLabel.text = [self.currentCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
        }
        return cell;
    }
}
#pragma mark - Select内容为数组相应索引的值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag != 1001) {
        SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
        NSString *cityName = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        NSDictionary *params = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":@"",@"Detail":@[@{@"ID":isStrEmpty(shareInfo.user_id) ? @"" : shareInfo.user_id,@"Province":@"浙江省",@"City":cityName,@"IsShow":@"5"}]};
        [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
            NSLog(@"result:%@",result);
            NSLog(@"msg:%@",[result objectForKey:@"Msg"]);
        } failure:^(NSError *erro) {
            
        }];
    }else{
        if (isStrEmpty(self.currentCity)) {
            [self initMBProgress:@"请开启定位" withModeType:MBProgressHUDModeText afterDelay:1.0];
        }else{
            SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
            NSString *cityName = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            NSDictionary *params = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":@"",@"Detail":@[@{@"ID":isStrEmpty(shareInfo.user_id) ? @"" : shareInfo.user_id,@"Province":self.currentProvince,@"City":cityName,@"IsShow":@"5"}]};
            [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
                NSLog(@"result:%@",result);
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
