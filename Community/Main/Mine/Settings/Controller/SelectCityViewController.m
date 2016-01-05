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
    [self initTableView];
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
}

#pragma mark -- HTTP
- (void)getCityList
{
    NSDictionary *params = @{@"Method":@"ReSelectArea",@"Detail":@[@{@"Pid":@"330000",@"PageSize":@"700",@"PageIndex":@"1"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_CITY_LIST WithParam:params withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        
        if (result) {
            self.resultArray = [result objectForKey:@"Detail"];
            [_tableView reloadData];
        }
    } failure:^(NSError *erro) {
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    
    NSDictionary *dic = self.resultArray [indexPath.row];
    NSString *cityName = [dic objectForKey:@"area_city"];
    cell.textLabel.text = cityName;
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if ([sharedInfo.cityarea isEqualToString:cityName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
    NSDictionary *dic = self.resultArray [indexPath.row];
    NSString *area_szcode = [dic objectForKey:@"area_szcode"];
    NSString *cityName = [dic objectForKey:@"area_city"];
    shareInfo.city = area_szcode; //城市id
    
    [[NSUserDefaults standardUserDefaults] setObject:area_szcode forKey:@"city"];
    [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"area_city"] forKey:@"cityarea"];
    shareInfo.cityarea = [dic objectForKey:@"area_city"];

    
    NSLog(@"citynameL%@",cityName);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kReloadDataNotification object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:kChangeCityNameNotification object:nil];
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
