//
//  DeviceTokenUtility.h
//  GoddessClock
//
//  Created by tree on 10/18/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceTokenUtility : NSObject
/**
 *  存储device token
 */
+ (void)saveDeviceToken:(NSString *)token;
/**
 *  获取device token
 */
+ (NSString *)deviceToken;
@end
