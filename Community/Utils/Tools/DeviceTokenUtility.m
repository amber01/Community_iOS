//
//  DeviceTokenUtility.m
//  GoddessClock
//
//  Created by tree on 10/18/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DeviceTokenUtility.h"

@implementation DeviceTokenUtility
+ (void)saveDeviceToken:(NSString *)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"deviceToken"];
}

+ (NSString *)deviceToken
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
}
@end
