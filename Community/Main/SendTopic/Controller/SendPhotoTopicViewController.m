//
//  SendPhotoTopicViewController.m
//  Community
//
//  Created by amber on 16/4/5.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "SendPhotoTopicViewController.h"

@interface SendPhotoTopicViewController ()<UITabBarControllerDelegate>
{
    BOOL     isSelect;
}

@end

@implementation SendPhotoTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = VIEW_COLOR;
    self.title = @"大家在聊";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.delegate = self;
    isSelect = YES;
}

#pragma mark -- other

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    isSelect = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end