//
//  DLTabedSlideView.h
//  DLSlideController
//
//  Created by Dongle Su on 14-12-8.
//  Copyright (c) 2014年 dongle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLSlideTabbarProtocol.h"

typedef enum : NSUInteger {
    DLSlideTabbarImageRitht, //图片右，文字在右
    DLSlideTabbarImageTop, //图片在上，文字在下
} DLSlideTabbarType;

@interface DLTabedbarItem : NSObject
@property (nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *selectedImage;


//横排显示（文字在左，图片在右）
+ (DLTabedbarItem *)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

+ (DLTabedbarItem *)setImageHorizontal:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end

@class DLTabedSlideView;

@protocol DLTabedSlideViewDelegate <NSObject>
- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender;
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index;
@optional
- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index;
@end

@interface DLTabedSlideView : UIView<DLSlideTabbarDelegate>
//@property(nonatomic, strong) NSArray *viewControllers;
@property(nonatomic, weak) UIViewController *baseViewController;
@property(nonatomic, assign) NSInteger selectedIndex;


//set tabbar properties.
@property (nonatomic, strong) UIColor *tabItemNormalColor; //未选中字体颜色
@property (nonatomic, strong) UIColor *tabItemSelectedColor; //选中时的字体颜色
@property(nonatomic, strong) UIImage *tabbarBackgroundImage;
@property(nonatomic, strong) UIColor *tabbarTrackColor; //下面滚动条的颜色
@property(nonatomic, strong) NSArray *tabbarItems;
@property(nonatomic, assign) float tabbarHeight;
@property(nonatomic, assign) float tabbarBottomSpacing; //下面滚动条的大小

// cache properties
@property(nonatomic, assign) NSInteger cacheCount;

- (void)buildTabbar:(DLSlideTabbarType)type;

//@property(nonatomic, strong) IBOutlet id<DLSlideTabbarProtocol> tabarView;


@property(nonatomic, weak)IBOutlet id<DLTabedSlideViewDelegate>delegate;

@end
