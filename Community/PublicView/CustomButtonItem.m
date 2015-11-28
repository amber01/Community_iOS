//
//  CustomButtonItem.m
//  Community
//
//  Created by shlity on 15/11/10.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "CustomButtonItem.h"

@implementation CustomButtonItem

- (instancetype)initButtonItem:(UIImage *)image{
    self = [super init];
    if (self) {
        self.itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemBtn.frame = CGRectMake(0, 0, 30, 40);
        [_itemBtn setImage:image forState:UIControlStateNormal];
        self.customView = _itemBtn;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action andTtintColor:(UIColor*)tinColor
{
    self = [super init];
    if (self) {
        self.title = title;
        self.style = style;
        self.target = target;
        self.action = action;
        self.tintColor = tinColor;
    }
    return self;
}

@end
