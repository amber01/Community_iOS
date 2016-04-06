//
//  DiscoverViewController.m
//  Community
//
//  Created by shlity on 16/4/6.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverView.h"

@interface DiscoverViewController ()

@property (nonatomic,retain)DiscoverView    *discoverView;


@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_COLOR;
    self.title = @"发现";
    [self initViews];
}

- (void)initViews
{
    [self discoverView];
}

#pragma mark -- UI
- (DiscoverView *)discoverView
{
    if (!_discoverView) {
        _discoverView = [[DiscoverView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        [self.view addSubview:_discoverView];
    }return _discoverView;
}

#pragma mark -- other
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
