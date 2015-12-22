//
//  WSJSObject.h
//  妈妈去哪儿
//
//  Created by shlity on 15/11/5.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

/**
 *
 *  通过试下以下协议方法，让js来调用oc的方法，达到js和oc交互的目的
 *
 */

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

//首先创建一个实现了JSExport协议的协议
@protocol JSObjectProtocolDelegate <JSExport>

/**
 *  跳转话题
 *
 *  @param theme 话题
 */
- (void)toTheme:(NSString *)theme;

/**
 *  跳转网页
 *
 *  @param url
 */
- (void)toWebUrl:(NSString *)url;

/**
 *  跳转app
 *
 *  @param url
 */
- (void)toStartApp:(NSString *)url;

/**
 *  返回 分享 标题。内容 。Url链接
 *
 *  @param JsonObject
 */
- (void)toShareWeiXin:(NSString *)jsonObject;

/**
 *  返回 分享 标题。内容 。Url链接
 *
 *  @param JsonObject
 */
- (void)toShareSMS:(NSString *)jsonObject;

/**
 *  去登录
 *
 *  @param login 如果没有 可以 传 空字符串
 */
- (void)toLogin:(NSString *)login;

/**
 *  关闭这个页面
 */
- (void)toFinsh;

/**
 *  点击图片
 *
 *  @param iamgeData 返回一个字符串
 */
- (void)toShowImg:(NSString *)imageData;

/**
 *  调js 显示标题
 *
 *  @param title
 */
- (void)toShowTitle:(NSString *)title;

/**
 *  返回上一个页面
 */
- (void)toGoback;

@end

//为创建的类实现上边的协议
@interface WSJSObject : NSObject<JSObjectProtocolDelegate>

- (void)toTheme:(NSString *)theme;
- (void)toWebUrl:(NSString *)url;
- (void)toStartApp:(NSString *)url;
- (void)toShareWeiXin:(NSString *)jsonObject;
- (void)toShareSMS:(NSString *)jsonObject;
- (void)toLogin:(NSString *)login;
- (void)toFinsh;
- (void)toShowImg:(NSString *)imageData;
- (void)toShowTitle:(NSString *)title;
- (void)toGoback;

@property (nonatomic,assign)id <JSObjectProtocolDelegate,NSObject>delegate;

@end
