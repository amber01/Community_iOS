//
//  WebDetailViewController.m
//  Community
//
//  Created by amber on 15/12/12.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "WebDetailViewController.h"
#import "WSJSObject.h"

@interface WebDetailViewController ()<UIWebViewDelegate,JSObjectProtocolDelegate>
{
    UIWebView  *_webView;
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

#pragma mark -- UI
- (void)createWebView:(NSString *)event_url
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_webView];
    
    NSString *urlString = [event_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL    *url    = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [_webView setDelegate:self];
    [_webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *titleStr = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title  = isStrEmpty(titleStr) ? @"详情" : titleStr;
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

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
