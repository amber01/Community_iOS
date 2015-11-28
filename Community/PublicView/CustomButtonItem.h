//
//  CustomButtonItem.h
//  Community
//
//  Created by shlity on 15/11/10.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButtonItem : UIBarButtonItem

- (instancetype)initButtonItem:(UIImage *)image;
- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action andTtintColor:(UIColor*)tinColor;
@property (nonatomic,retain)UIButton *itemBtn;
@property (nonatomic,retain)UIButton *rightBtn;

@end
