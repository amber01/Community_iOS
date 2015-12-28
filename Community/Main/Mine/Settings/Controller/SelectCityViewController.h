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
@property (strong, nonatomic) NSString           *status;

@end
