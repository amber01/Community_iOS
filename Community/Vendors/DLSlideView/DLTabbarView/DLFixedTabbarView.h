//
//  DLFixedTabbarView.h
//  DLSlideController
//
//  Created by Dongle Su on 14-12-8.
//  Copyright (c) 2014年 dongle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLSlideTabbarProtocol.h"

@interface DLFixedTabbarViewTabItem : NSObject

@property(nonatomic, assign) BOOL     isImageTop;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *selectedImage;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *selectedTitleColor;


@end

@interface DLFixedTabbarView : UIView<DLSlideTabbarProtocol>
@property(nonatomic, strong) UIImageView *trackView_;
@property(nonatomic, strong) UIImage *backgroundImage;
@property(nonatomic, strong) UIColor *trackColor;
@property(nonatomic, strong) NSArray *tabbarItems;
@property(nonatomic, assign) float tabbarHeight;
@property(nonatomic, assign) float tabbarBottomSpacing; //下面滚动条的大小

//- (void)addBarItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, readonly) NSInteger tabbarCount;
@property(nonatomic, weak) id<DLSlideTabbarDelegate> delegate;
- (void)switchingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent;

@end
