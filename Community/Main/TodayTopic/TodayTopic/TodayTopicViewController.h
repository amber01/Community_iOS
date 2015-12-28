//
//  TodayTopicViewController.h
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TodayTopicViewController : BaseViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager  *locationManager;

@end
