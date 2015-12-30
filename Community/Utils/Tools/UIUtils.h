//
//  UIUtils.h
//  SinaWeiBo
//
//  Created by amber on 14-8-19.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;
// date 格式化为 string
+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate;
// string 格式化为 date
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;

//获取当前时间
+ (NSString *)getCurrentDate:(NSString *)dateFormat;

//格式化这样的日期：Mon Sep 08 20:29:11 +0800 2014
+ (NSString *)fomateString:(NSString *)datestring;

//字符串链接等解析方法
+ (NSString *)parseLink:(NSString *)text;

//随机生成字符串
+ (NSString *)randomString:(int)length;

//比较两个时间的大小
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

//计算两个时间之差
+ (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;

/**
 *  将字符串转为NSDate
 *
 *  @param uiDate 要转的字符串
 *
 *  @return NSDate
 */
+ (NSDate*) convertDateFromString:(NSString*)uiDate;


//MD5  Jason
+(NSString*)md5return:(NSString *)method
               params:(NSString*)params
                 date:(NSString*)date;

//获取本地document目录
+ (NSString *)getDocumentFile:(NSString *)fileName;

//判断输入的是否是数字
+ (BOOL)isPureInt:(NSString*)string;

/**
 *  图片等比缩放
 *
 *  @param scaleImage 想要缩放的图片
 *
 *  @param scale     想要缩放的倍数
 *
 *  @return scale    缩放后的图片
 */
+ (UIImage *)scaleImage:(UIImage *)image proportion:(float)scale;

//将RGB颜色值转为16进制
+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;

//隐藏tablView多余的分割线
+ (void)setExtraCellLineHidden: (UITableView *)tableView;

//将UIView转成UIImage
+ (UIImage*)convertViewToImage:(UIView*)v;

//将时间戳转换为时间
+ (NSString *)converDateTime:(NSString *)time;

//将时间转为时间戳
+ (NSString *)converCurrentDate:(NSString *)timeStr;

//指定边角花弧形
+ (void)drawViewBorder:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

+ (void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners withColor:(UIColor*) color;

//获取当前汉字或字母的length
+ (int)getToInt:(NSString*)strtemp;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

//GCD方式延迟执行某个方法
void RunBlockAfterDelay(NSTimeInterval delay, void (^block)(void));


//只允许输入数字和小数点
+ (BOOL)validateNumber:(NSString*)number;

//图片居中裁剪
+ (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size;

//设置边框
+ (void)setupViewBorder:(UIView *)view cornerRadius:(CGFloat )cornerRadius borderWidth:(CGFloat )borderWidth borderColor:(UIColor *)borderColor;
+ (void)setupViewRadius:(UIView *)view cornerRadius:(CGFloat )cornerRadius;

//图片等比居中
+ (void)cutCurrentImageView:(UIImageView *)imageView;

//根据2个经纬度计算距离
+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;

//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)str;

//设置字符串中的数字的颜色和字体
+ (void)setRichNumberWithLabel:(UILabel*)label Color:(UIColor *) color FontSize:(CGFloat)size;

+ (NSString *)convertDateToString:(NSString *)time;

//获取UUID
+ (NSString *)getUniqueStrByUUID;

//CFUUIDRef和CFStringRef-生成唯一标识符
+ (NSString *)createCUID:(NSString *)prefix;

/**
 *  仿QQ空间时间显示
 *  @param string eg:2015年5月24日 02时21分30秒
 */
+ (NSString *)format:(NSString *)string;

@end
