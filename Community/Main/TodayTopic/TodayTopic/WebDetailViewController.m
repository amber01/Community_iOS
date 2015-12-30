//
//  WebDetailViewController.m
//  Community
//
//  Created by amber on 15/12/12.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "WebDetailViewController.h"
#import "WSJSObject.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface WebDetailViewController ()<UIWebViewDelegate,JSObjectProtocolDelegate,UMSocialUIDelegate>
{
    UIWebView  *_webView;
    UIButton   *backButton;
    UIButton   *backDetailButton;
}

@end

@implementation WebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView:self.url];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)updateBackButton {
    if ([_webView canGoBack]) {
        if (self.navigationItem.leftBarButtonItem) {
            
            if (!backDetailButton) {
                backDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
                backDetailButton.frame = CGRectMake(0, 0, 30, 40);
                [backDetailButton setImage:[UIImage imageNamed:@"back_btn_image"] forState:UIControlStateNormal];
                [backDetailButton addTarget:self action:@selector(backWasClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            backButton.hidden = YES;
            backDetailButton.hidden = NO;
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backDetailButton];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpacer.width = -12;
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backItem,nil];
        }
    }else {
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        [self.navigationItem setHidesBackButton:NO animated:YES];
        
        if (!backButton) {
            backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake(0, 0, 30, 40);
            [backButton setImage:[UIImage imageNamed:@"back_btn_image"] forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -12;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backItem,nil];
        
        backButton.hidden = NO;
        backDetailButton.hidden = YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self updateBackButton];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateBackButton];
    NSString *titleStr = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title  = isStrEmpty(titleStr) ? @"详情" : titleStr;
    
    /**
     *  如果是签到刮奖的页面就不允许手势返回
     */
    if ([titleStr isEqualToString:@"签到刮奖"]) {
        BaseNavigationController *baseNav = (BaseNavigationController *)self.navigationController;
        baseNav.canDragBack = NO;
    }else{
        BaseNavigationController *baseNav = (BaseNavigationController *)self.navigationController;
        baseNav.canDragBack = YES;
    }
}

- (void)backWasClicked:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

#pragma mark -- UI
- (void)createWebView:(NSString *)event_url
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    NSString *urlString = [event_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL    *url    = [NSURL URLWithString:urlString];
    
    /**
     *  创建对象，让js来调用
     */
    JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    WSJSObject *jsObject =[ WSJSObject new];
    context[@"community"]=jsObject;
    jsObject.delegate = self;

    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [_webView setDelegate:self];
    [_webView loadRequest:request];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

/**
 *
 *  截取URL方式获取id来跳转到VC中
 *
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@...",request.mainDocumentURL);
    return YES;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- JSObjectProtocolDelegate

/**
 *  返回 分享 标题。内容 。Url链接
 *
 *  @param JsonObject
 */
- (void)toShareWeiXin:(NSString *)jsonObject
{
    /**
     *  NSString转NSDictionary
     */
    
     NSLog(@"jsonObject:%@",jsonObject);
    
    NSData *jsonData = [jsonObject dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSString *detail = [object objectForKey:@"detail"];
    NSString *url    = [object objectForKey:@"url"];
    
    [UMSocialWechatHandler setWXAppId:@"wxc1830ea42532921e" appSecret:@"73ce199faec839454273de0ac5606858" url:url];
    [UMSocialQQHandler setQQWithAppId:@"1105030412" appKey:@"iGDileMaPq45D3Mf" url:url];
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = [UIImage imageNamed:@""];
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = [UIImage imageNamed:@""];
    [UMSocialData defaultData].extConfig.qqData.shareImage = [UIImage imageNamed:@""];
    [UMSocialData defaultData].extConfig.qzoneData.shareImage = [UIImage imageNamed:@""];

    
    [UMSocialData defaultData].extConfig.smsData.shareText = detail;
    [UMSocialData defaultData].extConfig.sinaData.shareText = detail;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"";
    [UMSocialData defaultData].extConfig.qqData.title = @"";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"";
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:Umeng_key
                                      shareText:detail
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,nil]
                                       delegate:self];

}

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:YES];
    BaseNavigationController *baseNav = (BaseNavigationController *)self.navigationController;
    baseNav.canDragBack = YES;

}

@end
