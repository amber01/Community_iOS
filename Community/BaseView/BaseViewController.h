//
//  MyViewController.h
//  蜗居生活
//
//  Created by amber on 15/4/22.
//  Copyright (c) 2015年 wojushenghuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate,
UINavigationControllerDelegate>
{
    MBProgressHUD         * progress;
}

@property (nonatomic, assign) BOOL shouldFixAnimation;
@property (nonatomic,assign)BOOL isBackButton;
@property (nonatomic,assign)int navBackNum;

- (void)initMBProgress:(NSString *)title;
- (void)setMBProgreeHiden:(BOOL)isHiden;

/**
 *  设置progress状态
 *
 *  @param title title
 *  @param type  类型
 *  @param delay 时间
 */
- (void)initMBProgress:(NSString *)title withModeType:(MBProgressHUDMode)type afterDelay:(NSTimeInterval)delay;


- (id)appDelegate;  //拿到AppDelegate中的所有方法。可以让子类来调用


@end
