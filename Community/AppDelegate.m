//
//  AppDelegate.m
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "EaseMob.h"
#import "UMSocial.h"
#import "MobClick.h"

@interface AppDelegate ()

@property (nonatomic,retain)  UIImageView   *adImageView;
@property (nonatomic,retain)  UIImageView   *launchImage;
@property (nonatomic,retain)  BaseNavigationController *baseNavi;
@property (nonatomic,assign)  BOOL isLaunchedByNotification;

@end

@implementation AppDelegate

//git
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    self.mainVC = [[MainViewController alloc]init];
    self.baseNavi = [[BaseNavigationController alloc]initWithRootViewController:_mainVC];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self startLocation];
    
    [self loadADimageView];

    /**
     *  友盟分享
     */
    [UMSocialData setAppKey:Umeng_key];
    //加上这段代码，避免审核被拒掉
    [UMSocialConfig hiddenNotInstallPlatforms:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,nil]];
    
    //YouMeng统计平台
    [MobClick startWithAppkey:Umeng_key reportPolicy:BATCH channelId:@"appStore"];
    
    /**
     *  环信
     */
    
    //registerSDKWithAppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"35172747#communtiy" apnsCertName:@"microwenzhou"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    //环信聊天通知
    //注册通知
    [self registerRemoteNotification];
    //EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    
    //判断是否有收到推送
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        self.isLaunchedByNotification = YES;
    }else{
        self.isLaunchedByNotification = NO;
    }
    NSLog(@"remoteNotification:%@",remoteNotification);
    
    // 保存 Device 的现语言 (英语 法语)
    [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                              forKey:@"AppleLanguages"];
    [self getUserInfo];

    
    return YES;
}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    //ios8  注册本地通知
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *noteSetting =[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:noteSetting];
    }
    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
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
    
    /**
     *  启动app的时候发一个通知，调用接口判断用户是否有未读消息
     */
    if (!isStrEmpty(sharedInfo.user_id)) {
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        if (isStrEmpty(sharedInfo.user_id)) {
            return;
        }
        NSDictionary *parameters = @{@"Method":@"ReCommentInfoRead",@"Detail":@[@{@"UserID":sharedInfo.user_id}]};
        [CKHttpRequest createRequest:HTTP_METHOD_COMMENT WithParam:parameters withMethod:@"POST" success:^(id result) {
            if (result) {
                NSArray *item = [result objectForKey:@"Detail"];
                for (int i = 0; i < item.count; i ++ ) {
                    NSDictionary *dic = [item objectAtIndex:i];
                    NSString  *commentNum = [dic objectForKey:@"commentnum"];
                    NSString  *commentpraisenum = [dic objectForKey:@"commentpraisenum"];
                    NSString  *postpraisenum = [dic objectForKey:@"postpraisenum"];
                    NSString  *sysmsgnum = [dic objectForKey:@"sysmsgnum"];
                    if (([commentNum intValue] + [commentpraisenum intValue] + [postpraisenum intValue] + [sysmsgnum intValue] > 0)) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationShowAlertDot object:nil];
                    }
                }
            }
            NSLog(@"result:%@",result);
        } failure:^(NSError *erro) {
            
        }];
    }
    
    NSLog(@"username:%@",sharedInfo.username);
}

- (void)loadADimageView{
    
    self.launchImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.launchImage.backgroundColor = [UIColor clearColor];
    if (ScreenWidth == 320 && ScreenHeight == 480) { //iPhone4
        [_launchImage setImage:[UIImage imageNamed:@"launchimage_iphone4"]];
    }else if (ScreenWidth == 320 && ScreenHeight == 568){ //iPhone5
        [_launchImage setImage:[UIImage imageNamed:@"launchimage_iphone5"]];
    }else if (ScreenWidth == 375){ //iPhone6
        [_launchImage setImage:[UIImage imageNamed:@"launchimage_iphone6"]];
    }else if (ScreenWidth == 414){ //iPhone6 Plus
        [_launchImage setImage:[UIImage imageNamed:@"launchimage_iphone6p@3x"]];
    }else{
        [_launchImage setImage:[UIImage imageNamed:@"launchimage_iphone5"]];
    }
    
    //启动页面加一个广告宣传
    self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 120 * scaleToScreenHeight)];
    _adImageView.backgroundColor = [UIColor clearColor];
    NSDictionary *params = @{@"Method":@"ReAdvertis",@"Detail":@[@{@"PageSize":@"1",@"PageIndex":@"1",@"IsShow":@"888",@"TypeID":@"3",@"STypeID":@"14"}]};
    [CKHttpRequest createRequest:HTTP_COMMAND_ADVERTIS WithParam:params withMethod:@"POST" success:^(id result) {
        NSLog(@"resultsss:%@",result);
        if (result) {
            NSArray  *items = [result objectForKey:@"Detail"];
            for (int i = 0; i < items.count; i++) {
                NSDictionary  *dic = [items objectAtIndex:i];
                if (i == 0) {
                    NSString *filedomain = [dic objectForKey:@"filedomain"];
                    NSString *filename   = [dic objectForKey:@"filename"];
                    NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",filedomain],BASE_IMAGE_URL,guanggao,filename];
                    [_adImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
                    
                    NSLog(@"imageURL:%@",imageURL);
                }
            }
        }
    } failure:^(NSError *erro) {
        
    }];
    
    [self.launchImage addSubview:_adImageView];
    [self.window addSubview:self.launchImage];
    [self.window bringSubviewToFront:self.launchImage];
    [self performSelector:@selector(removeAdImageView) withObject:nil afterDelay:3];
}

/**
 *  启动页面3s后移除
 */
- (void)removeAdImageView
{
    [self.adImageView removeFromSuperview];
    [self.launchImage removeFromSuperview];
    /**
     *  收到通知的情况下就跳转到消息页面
     */
    if (self.isLaunchedByNotification) {
        [self.mainVC setSelectedIndex:2];
        self.window.rootViewController = self.baseNavi;
    }else{
        self.window.rootViewController = self.baseNavi;
        
    }
    
    self.window.backgroundColor = [UIColor clearColor];
}

#pragma mark -- LocationManange
-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"change");
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            
            NSString *country = placemark.name;
            NSString *city = placemark.locality; //当前城市
            
            SharedInfo *shared = [SharedInfo sharedDataInfo];
            shared.cityarea = city;
            shared.locationAddress = country;
            shared.provincearea =  [test objectForKey:@"State"]; //省份
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"error -- %@",error);
}

- (void)dealloc
{
    [self.locationManager stopUpdatingLocation];
}

@end
