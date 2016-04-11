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
#import "SendPhotoTopicViewController.h"
#import "SendTopicViewController.h"
#import "DiscoverViewController.h"

@interface MainViewController ()

@property (nonatomic,retain)UIView      *imageView;
@property (nonatomic,retain)UIButton    *selectSendTopicBtn;

@end

@implementation MainViewController

//test update
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMsgCount) name:kNotificationShowAlertDot object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideMsgCount) name:kNotificationHideAlertDot object:nil];
    [self createdTabBarView];
    [self selectSendTopicBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}


- (void)createdTabBarView
{
    TodayTopicViewController     *todayTopicVC    = [[TodayTopicViewController alloc]init];
    DiscoverViewController       *everyoneTopicVC = [[DiscoverViewController alloc]init];
    SendPhotoTopicViewController *sendTopicVC     = [[SendPhotoTopicViewController alloc]init];
    MessageViewController        *messageVC       = [[MessageViewController alloc]init];
    MineViewController           *mineVC          = [[MineViewController alloc]init];

    //TodayTopic
    UITabBarItem *todayTopicItem =[[UITabBarItem alloc]initWithTitle:@"热点" image:nil tag:1];
    todayTopicItem.image = [UIImage imageNamed:@"todayTopic_tabbar_normal"];
    todayTopicItem.selectedImage = [UIImage imageNamed:@"todayTopic_tabbar_high"];
    BaseNavigationController *todayTopicNav = [[BaseNavigationController alloc]initWithRootViewController:todayTopicVC];
    self.tabBar.tintColor = [UIColor colorWithHexString:@"#ef5755"];  //改变tabBar上的按钮文字颜色
    todayTopicVC.tabBarItem = todayTopicItem;
    
    //EveryoneTopic
    UITabBarItem *everyoneTopicItem =[[UITabBarItem alloc]initWithTitle:@"发现" image:nil tag:2];
    everyoneTopicItem.image = [UIImage imageNamed:@"everyoneTopic_tabbar_normal"];
    everyoneTopicItem.selectedImage = [UIImage imageNamed:@"everyoneTopic_tabbar_high"];
    BaseNavigationController *everyoneTopicNav = [[BaseNavigationController alloc]initWithRootViewController:everyoneTopicVC];
    everyoneTopicVC.tabBarItem = everyoneTopicItem;
    
    //sendTopic
    UITabBarItem *sendTopicItem =[[UITabBarItem alloc]initWithTitle:@"发布" image:nil tag:3];
    sendTopicItem.image = [UIImage imageNamed:@"sendTopic_tabbar_normal"];
    sendTopicItem.selectedImage = [UIImage imageNamed:@"sendTopic_tabbar_normal"];
    BaseNavigationController *sendTopicNav = [[BaseNavigationController alloc]initWithRootViewController:sendTopicVC];
    sendTopicVC.tabBarItem = sendTopicItem;

    
    //Message
    UITabBarItem *messageItem =[[UITabBarItem alloc]initWithTitle:@"消息" image:nil tag:4];
    messageItem.image = [UIImage imageNamed:@"message_tabbar_normal"];
    messageItem.selectedImage = [UIImage imageNamed:@"message_tabbar_high"];
    BaseNavigationController *messageNav = [[BaseNavigationController alloc]initWithRootViewController:messageVC];
    messageVC.tabBarItem = messageItem;
    
    //Mine
    UITabBarItem *mineItem =[[UITabBarItem alloc]initWithTitle:@"我的" image:nil tag:5];
    mineItem.image = [UIImage imageNamed:@"mine_tabbar_normal"];
    mineItem.selectedImage = [UIImage imageNamed:@"mine_tabbar_high"];
    BaseNavigationController *mineNav = [[BaseNavigationController alloc]initWithRootViewController:mineVC];
    mineVC.tabBarItem = mineItem;
    
    NSArray *array = @[todayTopicNav,everyoneTopicNav,sendTopicNav,messageNav,mineNav];
    [self setViewControllers:array animated:YES];
    
    [self loadMoreView];
}

/**
 *  添加一个类似微信的小红点
 */
- (void)loadMoreView{
    //[super loadView];
    for (int i = 0; i< 5; i++) {
        if (i == 3) {
            self.imageView = [[UIView alloc] init];
            _imageView.backgroundColor = [UIColor redColor];
            float width = ScreenWidth / 5;
            self.imageView.frame = CGRectMake(width * 4 - 28*scaleToScreenHeight, 9, 9, 9);
            _imageView.hidden = YES;
            _imageView.layer.cornerRadius = _imageView.height/2;
            _imageView.clipsToBounds = YES;

            [self.tabBar addSubview:_imageView];
        }
    }
}

- (UIButton *)selectSendTopicBtn
{
    if (!_selectSendTopicBtn) {
        _selectSendTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectSendTopicBtn.frame = CGRectMake(ScreenWidth/2 - ((ScreenWidth/5)/2), 0, ScreenWidth/5, 64);
        [_selectSendTopicBtn addTarget:self action:@selector(selectSendTopicAction) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:_selectSendTopicBtn];
    }
    return _selectSendTopicBtn;
}

#pragma mark -- UITabBarControllerDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"selectedIndex:%ld",item.tag);
    if (item.tag == 4) {
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        if (isStrEmpty(sharedInfo.user_id)) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.status = @"1";
            BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:loginVC];
            [self.navigationController presentViewController:baseNav animated:YES completion:^{
                
            }];
        }
    }
}

- (void)selectSendTopicAction
{
    SendTopicViewController *sendTopicInfoVC = [[SendTopicViewController alloc]init];
    sendTopicInfoVC.cate_id = @"0";
    BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:sendTopicInfoVC];
    [self.navigationController presentViewController:baseNav animated:YES completion:^{
        
    }];
}

#pragma Notification
- (void)getMsgCount
{
    _imageView.hidden = NO;
}

- (void)hideMsgCount
{
    _imageView.hidden = YES;
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
