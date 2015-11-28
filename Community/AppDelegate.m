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

@interface AppDelegate ()

@end

@implementation AppDelegate

//git update test test
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    MainViewController *mainVC = [[MainViewController alloc]init];
    BaseNavigationController *baseNavi = [[BaseNavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController = baseNavi;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
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
    NSLog(@"userid:%@",sharedInfo.user_id);
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

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
