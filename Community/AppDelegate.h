//
//  AppDelegate.h
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager  *locationManager;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain)  MainViewController *mainVC;

@end

