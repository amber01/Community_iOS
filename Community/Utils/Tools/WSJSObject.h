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
 *  点击签到有礼js返回对应数据
 *
 *  @param btnIndex js返回的按钮index
 *  @param title    js返回的按钮title
 */
- (void)showRight:(int)btnIndex TextBtn:(NSString *)title;

/**
 *  关闭当前打开的web页面
 */
- (void)exitNowPage;

/**
 *  到商品页面
 *
 *  @param goodsId 传goods_id
 */
- (void)toGoodsPage:(NSString *)goodsId;

/**
 *  到店铺页面
 *
 *  @param storeId 传store_id
 */
- (void)toStorePage:(NSString *)storeId;

/**
 *  显示/关闭 一个dialog, 在做异步交互时, 可以挡住主界面, 阻止用户的所有操作
 *
 *  @param isShow   int类型; 是否显示, 显示1, 关闭0
 */
- (void)makeLoading:(int)isShow;

/**
 *   告诉客户端用户点击了［同意/不同意］按钮
 *
 *  @param isAgree int类型; 是否同意, 同意1, 不同意0
 */
- (void)sendAgree:(int)isAgree;

/**
 *  妈妈精选/妈妈海淘, 跳转子分类
 *
 *  @param cateId 子分类id
 */
- (void)toCatePage:(NSString *)cateId;

/**
 *   新页面打开普通的url
 *
 *  @param url url地址, url错误时不会响应
 */
- (void)toCommonUrl:(NSString *)url;

@end

//为创建的类实现上边的协议
@interface WSJSObject : NSObject<JSObjectProtocolDelegate>

- (void)exitNowPage;
- (void)toGoodsPage:(NSString *)goodsId;
- (void)toStorePage:(NSString *)storeId;
- (void)showRight:(int)btnIndex TextBtn:(NSString *)title;
- (void)makeLoading:(int)isShow;
- (void)sendAgree:(int)isAgree;
- (void)toCatePage:(NSString *)cateId;
- (void)toCommonUrl:(NSString *)url;

@property (nonatomic,assign)id <JSObjectProtocolDelegate,NSObject>delegate;

@end
