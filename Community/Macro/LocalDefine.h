//
//  LocalDefine.h
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#ifndef LocalDefine_h
#define LocalDefine_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#define BASE_COLOR   [UIColor colorWithRed:239 / 255.0 green:87 / 255.0 blue:85 / 255.0 alpha:1.0]
#define VIEW_COLOR   [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1.0]
#define CELL_COLOR   [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0]
#define TEXT_COLOR   [UIColor colorWithRed:173 / 255.0 green:173 / 255.0 blue:173 / 255.0 alpha:1.0]
#define TEXT_COLOR1  [UIColor colorWithRed:163 / 255.0 green:163 / 255.0 blue:163 / 255.0 alpha:1.0]
#define TEXT_COLOR2  [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.0]

#define LINE_COLOR_CGCOLOR [UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.0].CGColor
#define LINE_COLOR [UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.0]


#define ScreenHeight  [UIScreen mainScreen].bounds.size.height //获取当前设备的高度
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width  //获取当前设备的宽度
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define scaleToScreenHeight ScreenWidth/320.0f
//系统判定
#define  IOS_VERSION        [[[UIDevice currentDevice]systemVersion]floatValue]

//NSNotification
#define kHideSendTopicNotification  @"kHideSendTopicNotification"
#define kIsShowPhotoNotification    @"kIsShowPhotoNotification"
#define kSendIsLoginNotification    @"kSendIsLoginNotification"
#define kSendIsLogoutNotification   @"kSendIsLogoutNotification"
#define kReloadDataNotification     @"kReloadDataNotification"
#define kNotificationShowAlertDot   @"kNotificationShowAlertDot"
#define kNotificationHideAlertDot   @"kNotificationHideAlertDot"
#define kReloadCommentNotification  @"kReloadCommentNotification"
#define kChangeCityNameNotification @"kChangeCityNameNotification"

#endif /* LocalDefine_h */

#define kDefaultAppKey @"35172747#communtiy"
#define kDefaultCustomerName @"zhimore_kefu1"

#define kAppKey @"35172747#communtiy"
#define kCustomerName @"zhimore_kefu1"

#define Umeng_key         @"56500ca9e0f55a4819002e85"

#define KEY_UUID      @"com.company.app.uuid"
#define KEY_APPNAME   @"com.company.app.appname"
