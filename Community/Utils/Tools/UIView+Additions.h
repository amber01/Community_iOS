//
//  UIView+Additions.h
//  SinaWeiBo
//  该类别主要是扩展一个UIViewController控制器方法
//  该方法的目的是为了在WeiboView中选中某个链接时，能通过UIViewoController中的push方法跳转到某个控制器面板

//  Created by amber on 14-10-17.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

//让其他不能调用push的类，调用该方法就可以push到对应的面板
- (UIViewController *)viewController;

@end
