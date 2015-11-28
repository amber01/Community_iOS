//
//  MyViewController.h
//  蜗居生活
//
//  Created by amber on 15/4/22.
//  Copyright (c) 2015年 wojushenghuo. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNaviBack];
}

- (void)customNaviBack
{
    NSArray *viewController = self.navigationController.viewControllers;
    if (viewController.count > 1 && self.isBackButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 40);
        [button setImage:[UIImage imageNamed:@"back_btn_image"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -12;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backItem,nil];
    }
}

- (void)initMBProgress:(NSString *)title
{
    progress = [[MBProgressHUD alloc]initWithView:self.view];
    progress.labelText = title;
    [self.view addSubview:progress];
    [progress setMode:MBProgressHUDModeIndeterminate];
    progress.taskInProgress = YES;
    [progress show:YES]; 
     progress.yOffset = - 49.0f;
}

- (void)initMBProgress:(NSString *)title withModeType:(MBProgressHUDMode)type afterDelay:(NSTimeInterval)delay
{
    progress = [[MBProgressHUD alloc]initWithView:self.view];
    progress.labelText = title;
    [self.view addSubview:progress];
    [progress setMode:type];   //MBProgressHUDModeIndeterminate
    progress.taskInProgress = YES;
    [progress show:YES];

    progress.yOffset = - 49.0f;
    [progress hide:YES afterDelay:delay];
}


- (void)setMBProgreeHiden:(BOOL)isHiden
{
    [progress hide:isHiden];
    if (progress != nil) {
        [progress removeFromSuperview];
    }
}

#pragma mark -- action
- (void)backAction
{
    if (self.navBackNum) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-self.navBackNum-1]  animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark other
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    NSArray *viewController = self.navigationController.viewControllers;
    if (viewController.count == 1) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    [self setMBProgreeHiden:YES];
}

- (id)appDelegate
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

@end