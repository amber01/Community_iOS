//
//  DiscoverViewController.m
//  Community
//
//  Created by shlity on 16/4/6.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTopicViewController.h"
#import "DiscoverFriendSquareViewController.h"
#import "DiscoverFindFriendViewController.h"
#import "DiscoverFindTopicViewController.h"

@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"发现";
    
    self.tabedSlideView = [[DLTabedSlideView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabItemNormalColor = TEXT_COLOR1;
    self.tabedSlideView.tabItemSelectedColor = BASE_COLOR;
    self.tabedSlideView.tabbarTrackColor = BASE_COLOR;
    self.tabedSlideView.tabbarHeight = 55;
    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    self.tabedSlideView.tabbarBottomSpacing = 3.0;
    self.tabedSlideView.delegate = self;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"话题圈" image:[UIImage imageNamed:@"discover_topic_normal"] selectedImage:[UIImage imageNamed:@"discover_topic_high.png"]];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"朋友圈" image:[UIImage imageNamed:@"discover_friend_square_normal.png"] selectedImage:[UIImage imageNamed:@"discover_friend_square_high"]];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"找朋友" image:[UIImage imageNamed:@"discover_find_friend_normal.png"] selectedImage:[UIImage imageNamed:@"discover_find_friend_high"]];
    DLTabedbarItem *item4 = [DLTabedbarItem itemWithTitle:@"找话题" image:[UIImage imageNamed:@"discover_find_topic_normal.png"] selectedImage:[UIImage imageNamed:@"discover_find_topic_high"]];
    self.tabedSlideView.tabbarItems = @[item1, item2, item3, item4];
    [self.view addSubview:_tabedSlideView];
    [self.tabedSlideView buildTabbar:DLSlideTabbarImageTop];
    
    self.tabedSlideView.selectedIndex = 0;
}

#pragma mark -- UI


#pragma makr -- DLTabedSlideViewDelegate

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 4;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            DiscoverTopicViewController *discoverTopicVC = [[DiscoverTopicViewController  alloc] init];
            return discoverTopicVC;
        }
        case 1:
        {
            DiscoverFriendSquareViewController *DiscoverFriendSquareVC = [[DiscoverFriendSquareViewController alloc] init];
            return DiscoverFriendSquareVC;
        }
        case 2:
        {
            DiscoverFindFriendViewController *DiscoverFindFriendVC = [[DiscoverFindFriendViewController alloc] init];
            return DiscoverFindFriendVC;
        }
        case 3:
        {
            DiscoverFindTopicViewController *DiscoverFindTopic = [[DiscoverFindTopicViewController alloc]init];
            return DiscoverFindTopic;
        }
        default:
            return nil;
    }
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
