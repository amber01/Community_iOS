//
//  SelectCityViewController.h
//  Community
//
//  Created by amber on 15/12/7.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SelectCityViewController : BaseViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager  *locationManager;
@property (strong, nonatomic) NSString           *status;  //1 第一次登录，2第一次使用app 
@property (strong, nonatomic) NSString           *fristLoad;

@end
