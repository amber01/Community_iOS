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
#import "UMessage.h"
#import "SelectCityView.h"


@interface SelectCityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView     *_tableView;
    //UITableView     *currentCityTabelView;
}

@property (nonatomic,retain) NSArray        *resultArray;
@property (nonatomic,copy  ) NSString       *currentCity;
@property (nonatomic,copy  ) NSString       *currentProvince;
@property (nonatomic,retain) SelectCityView *selectCityView;

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self selectCityView];
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
    
    //    [self initTableView];
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

- (SelectCityView *)selectCityView
{
    if (!_selectCityView) {
        
        _selectCityView = [[SelectCityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        _selectCityView.cityLabel.text = sharedInfo.cityarea;
        [self.view addSubview:_selectCityView];
        }
    return _selectCityView;
}

#pragma mark -- HTTP
- (void)getCityList
{
    NSDictionary *params = @{@"Method":@"ReSelectArea",@"Detail":@[@{@"Pid":@"330000",@"PageSize":@"700",@"PageIndex":@"1"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_CITY_LIST WithParam:params withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        if (result) {
            self.resultArray = [result objectForKey:@"Detail"];
            
            /**
             *  创建城市按钮
             */
            float Start_X = 10.0f;           // 第一个按钮的X坐标
            float Start_Y = _selectCityView.hotCityView.bottom + 10;           // 第一个按钮的Y坐标
            float Width_Space = 10.0f;        // 2个按钮之间的横间距
            float Height_Space = 20.0f;      // 竖间距
            float Button_Height = 35.f;    // 高
            float Button_Width = (ScreenWidth - 50)/4;      // 宽
            
            for (int i = 0 ; i < self.resultArray.count; i++) {
                NSInteger index = i % 4;
                NSInteger page = i / 4;
                
                NSDictionary *dic = [self.resultArray objectAtIndex:i];
                
                // 圆角按钮
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.backgroundColor = [UIColor whiteColor];
                [button setTitle:[dic objectForKey:@"area_city"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [UIUtils setupViewBorder:button cornerRadius:Button_Height/2 borderWidth:1 borderColor:[UIColor colorWithHexString:@"#adadad"]];
                button.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
                button.tag = 100 + i;
                [button addTarget:self action:@selector(selectCityAction:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([sharedInfo.cityarea isEqualToString:[dic objectForKey:@"area_city"]]) {
                    button.backgroundColor = [UIColor colorWithHexString:@"#1ad155"];
                    [UIUtils setupViewBorder:button cornerRadius:Button_Height/2 borderWidth:1 borderColor:[UIColor whiteColor]];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
                _selectCityView.cityLabel.text = sharedInfo.cityarea;
                
                [_selectCityView addSubview:button];
            }
            
            [_tableView reloadData];
        }
    } failure:^(NSError *erro) {
        
    }];
}

#pragma mark -- action
/**
 *  单选
 */
- (void)selectCityAction:(UIButton *)button
{
    for (int i = 100; i <= 100 + self.resultArray.count;i++) {//num为总共设置单选效果按钮的数目
        UIButton *btn = (UIButton*)[self.view viewWithTag:i];//view为这些btn的父视图
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [UIUtils setupViewBorder:btn cornerRadius:35/2 borderWidth:1 borderColor:[UIColor colorWithHexString:@"#adadad"]];
    }
    
    button.backgroundColor = [UIColor colorWithHexString:@"#1ad155"];
    [UIUtils setupViewBorder:button cornerRadius:35/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
    NSDictionary *dic = self.resultArray[button.tag - 100];
    NSString *area_szcode = [dic objectForKey:@"area_szcode"];
    NSString *cityName = [dic objectForKey:@"area_city"];
    shareInfo.city = area_szcode; //城市id
    
    //添加前删除以前的tag，避免其他地区也收到通知
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"city"]length] > 1) {
        [UMessage removeTag:[[NSUserDefaults standardUserDefaults]objectForKey:@"city"]
                   response:^(id responseObject, NSInteger remain, NSError *error) {
                       NSLog(@"剩余次数：%@",[NSString stringWithFormat:@"剩余:%ld",(long)remain]);
                       if(responseObject)
                       {
                           NSLog(@"删除成功！");
                       }
                       else
                       {
                           NSLog(@"error log%@",error.localizedDescription);
                       }
                   }];
    }
    
    //讲tag发送到服务器，然后根据tag发送推送到指定的设备上去
    [UMessage addTag:area_szcode
            response:^(id responseObject, NSInteger remain, NSError *error) {
                NSLog(@"剩余次数：%@",[NSString stringWithFormat:@"剩余:%ld",(long)remain]);
                if(responseObject)
                {
                    NSLog(@"添加成功");
                }
                else
                {
                    NSLog(@"error log%@",error.localizedDescription);
                }
                
            }];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:area_szcode forKey:@"city"];
    [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"area_city"] forKey:@"cityarea"];
    shareInfo.cityarea = [dic objectForKey:@"area_city"];
    
    
    NSLog(@"area_szcode:%@",area_szcode);
    
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
    
    //添加前删除以前的tag，避免其他地区也收到通知
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"city"]length] > 1) {
        [UMessage removeTag:[[NSUserDefaults standardUserDefaults]objectForKey:@"city"]
                   response:^(id responseObject, NSInteger remain, NSError *error) {
                       NSLog(@"剩余次数：%@",[NSString stringWithFormat:@"剩余:%ld",(long)remain]);
                       if(responseObject)
                       {
                           NSLog(@"删除成功！");
                       }
                       else
                       {
                           NSLog(@"error log%@",error.localizedDescription);
                       }
                   }];
    }
    
    //讲tag发送到服务器，然后根据tag发送推送到指定的设备上去
    [UMessage addTag:area_szcode
            response:^(id responseObject, NSInteger remain, NSError *error) {
                NSLog(@"剩余次数：%@",[NSString stringWithFormat:@"剩余:%ld",(long)remain]);
                if(responseObject)
                {
                    NSLog(@"添加成功");
                }
                else
                {
                    NSLog(@"error log%@",error.localizedDescription);
                }
                
            }];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:area_szcode forKey:@"city"];
    [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"area_city"] forKey:@"cityarea"];
    shareInfo.cityarea = [dic objectForKey:@"area_city"];
    
    
    NSLog(@"area_szcode:%@",area_szcode);
    
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
