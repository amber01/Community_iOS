//
//  MainViewController.m
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "TodayTopicViewController.h"
#import "EveryoneTopicViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"

@interface MainViewController ()

@property (nonatomic,retain)UIImageView  *imageView;

@end

@implementation MainViewController

//test update
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMsgCount) name:kNotificationShowAlertDot object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideMsgCount) name:kNotificationHideAlertDot object:nil];
    [self createdTabBarView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}


- (void)createdTabBarView
{
    TodayTopicViewController     *todayTopicVC    = [[TodayTopicViewController alloc]init];
    EveryoneTopicViewController  *everyoneTopicVC = [[EveryoneTopicViewController alloc]init];
    MessageViewController        *messageVC       = [[MessageViewController alloc]init];
    MineViewController           *mineVC          = [[MineViewController alloc]init];

    //TodayTopic
    UITabBarItem *todayTopicItem =[[UITabBarItem alloc]initWithTitle:@"今日有料" image:nil tag:1];
    
    todayTopicItem.image = [UIImage imageNamed:@"todayTopic_tabbar_normal"];
    todayTopicItem.selectedImage = [UIImage imageNamed:@"todayTopic_tabbar_high"];
    BaseNavigationController *todayTopicNav = [[BaseNavigationController alloc]initWithRootViewController:todayTopicVC];
    self.tabBar.tintColor = [UIColor colorWithHexString:@"#d33234"];  //改变tabBar上的按钮文字颜色
    todayTopicVC.tabBarItem = todayTopicItem;
    
    //EveryoneTopic
    UITabBarItem *everyoneTopicItem =[[UITabBarItem alloc]initWithTitle:@"大家在聊" image:nil tag:2];
    everyoneTopicItem.image = [UIImage imageNamed:@"everyoneTopic_tabbar_normal"];
    everyoneTopicItem.selectedImage = [UIImage imageNamed:@"everyoneTopic_tabbar_high"];
    BaseNavigationController *everyoneTopicNav = [[BaseNavigationController alloc]initWithRootViewController:everyoneTopicVC];
    everyoneTopicVC.tabBarItem = everyoneTopicItem;
    
    //Message
    UITabBarItem *messageItem =[[UITabBarItem alloc]initWithTitle:@"消息" image:nil tag:3];
    messageItem.image = [UIImage imageNamed:@"message_tabbar_normal"];
    messageItem.selectedImage = [UIImage imageNamed:@"message_tabbar_high"];
    BaseNavigationController *messageNav = [[BaseNavigationController alloc]initWithRootViewController:messageVC];
    messageVC.tabBarItem = messageItem;
    
    //Mine
    UITabBarItem *mineItem =[[UITabBarItem alloc]initWithTitle:@"我的" image:nil tag:4];
    mineItem.image = [UIImage imageNamed:@"mine_tabbar_normal"];
    mineItem.selectedImage = [UIImage imageNamed:@"mine_tabbar_high"];
    BaseNavigationController *mineNav = [[BaseNavigationController alloc]initWithRootViewController:mineVC];
    mineVC.tabBarItem = mineItem;
    
    NSArray *array = @[todayTopicNav,everyoneTopicNav,messageNav,mineNav];
    [self setViewControllers:array animated:YES];
}

/**
 *  添加一个类似微信的小红点
 */
- (void)loadView{
    [super loadView];
    for (int i = 0; i< 4; i++) {
        UIImage  *badgeImg = [UIImage imageWithColor:[UIColor redColor]];
        if (i == 2) {
            self.imageView = [[UIImageView alloc] initWithImage:badgeImg];
            self.imageView.frame = CGRectMake(50 + i * 80, 7, 8, 8);
            [UIUtils setupViewRadius:_imageView cornerRadius:8/2];
        }
    }
}

#pragma Notification
- (void)getMsgCount
{
    _imageView.hidden = NO;
    [self.tabBar addSubview:_imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
