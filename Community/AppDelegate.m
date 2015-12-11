//
//  AppDelegate.m
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "MainViewController.h"
#import "EaseMob.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//git
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    MainViewController *mainVC = [[MainViewController alloc]init];
    BaseNavigationController *baseNavi = [[BaseNavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController = baseNavi;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    /**
     *  环信
     */
    
    //registerSDKWithAppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"35172747#communtiy" apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 保存 Device 的现语言 (英语 法语)
    [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                              forKey:@"AppleLanguages"];
    [self getUserInfo];
    
    return YES;
}

- (void)getUserInfo
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    sharedInfo.user_id  = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    sharedInfo.nickname  = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
    sharedInfo.mobile  = [[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"];
    sharedInfo.username  = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    sharedInfo.area  = [[NSUserDefaults standardUserDefaults]objectForKey:@"area"];
    sharedInfo.address  = [[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    sharedInfo.createtime  = [[NSUserDefaults standardUserDefaults]objectForKey:@"createtime"];
    sharedInfo.picture = [[NSUserDefaults standardUserDefaults]objectForKey:@"picture"];
    sharedInfo.myfansnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"myfansnum"];
    sharedInfo.mytofansnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"mytofansnum"];
    sharedInfo.postnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"postnum"];
    sharedInfo.totalscore = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalscore"];
    sharedInfo.sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    sharedInfo.client = [[NSUserDefaults standardUserDefaults] objectForKey:@"client"];
    sharedInfo.cityarea = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityarea"];
    sharedInfo.provincearea =  [[NSUserDefaults standardUserDefaults] objectForKey:@"provincearea"];
    sharedInfo.picturedomain = [[NSUserDefaults standardUserDefaults] objectForKey:@"picturedomain"];
    
    EaseMob *easemob = [EaseMob sharedInstance];
    //登陆时记住HuanXin密码
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sharedInfo.username forKey:@"username"];
    [userDefaults setObject:@"123456" forKey:@"password"];
    [easemob.chatManager asyncLoginWithUsername:sharedInfo.username password:@"123456"];
    
    NSLog(@"username:%@",sharedInfo.username);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

@end
