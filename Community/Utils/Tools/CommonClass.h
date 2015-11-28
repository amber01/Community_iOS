//
//  CommonClass.h
//  TLSDPro
//
//  Created by Andy on 15-1-23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSString+MD5.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CommonClass : NSObject
//16进制色转成RGB
+ (UIColor *)getColor:(NSString *)hexColor;
+(void)setExtraCellLineHidden: (UITableView *)tableView;
//加半透明的水印
+(UIImage *)imageWithTransImage:(UIImage *)useImage addtransparentImage:(UIImage *)transparentimg;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;//正则判断手机号码地址格式

+(NSString*)timeDistanceSinceNow:(NSString*)time;
//距离
+(NSString*)distanceBetweenOrderBy:(double)lon1 :(double)lat1 :(double)lon2 :(double)lat2;
//加模糊效果函数，传入参数：image是图片，blur是模糊度（0~2.0之间）
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

//年龄
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;


#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;
#pragma 正则匹配昵称
+ (BOOL) validateNickname:(NSString *)nickname;
#pragma 车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;
#pragma 车型
+ (BOOL) validateCarType:(NSString *)CarType;
#pragma 用户名
+ (BOOL) validateUserName:(NSString *)name;

//手机号码隐匿
+(NSString*)hideTelephone:(NSString *)telephone;
//边框线绘制
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;
//GCJ-02到BD-09
+(CLLocationCoordinate2D)bd_encrypt:(double)lat
                                lng:(double)lng;
//BD-09到GCJ-02
+(CLLocationCoordinate2D)bd_decrypt:(double)lat
                                lng:(double)lng;
//app版本判断
+(int)checkAppVer:(NSString *)oldVer
           newVer:(NSString *)newVer;
@end
