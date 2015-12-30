//
//  CKHttpRequest.m
//  Community
//
//  Created by amber on 15/11/15.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "CKHttpRequest.h"
#import "NSString+MyCategory.h"

#define TIME_NETOUT     2.0f
#define  kNotificationToLogin               @"loginNotification"


@implementation CKHttpRequest
{
    AFHTTPRequestOperationManager  * _HTTPManager;
    NSOperationQueue               * _downloadQueue;
}


+ (id)sharedInstance
{
    static CKHttpRequest * HTTPCommunicate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTTPCommunicate = [[CKHttpRequest alloc] init];
    });
    return HTTPCommunicate;
}
- (id)init
{
    if (self = [super init])
    {
        _HTTPManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URL_BASE]];
        _HTTPManager.requestSerializer.HTTPShouldHandleCookies = YES;
        _HTTPManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _HTTPManager.requestSerializer  = [AFJSONRequestSerializer serializer];
        
        [_HTTPManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
        [_HTTPManager.requestSerializer setValue:@"application/json; charset=gb2312" forHTTPHeaderField:@"Content-Type" ];
        _HTTPManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
        
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.maxConcurrentOperationCount = 10;
    }
    return self;
}

+ (void)createRequest:(HTTP_COMMAND_LIST)requestID WithParam:(NSDictionary *)param withMethod:(NSString*)method success:(void(^)(id result))success failure:(void(^)(NSError *erro))failure
{
    [[CKHttpRequest sharedInstance] createUnloginedRequest:requestID WithParam:param withMethod:method success:success failure:failure];
}

- (void)createUnloginedRequest:(HTTP_COMMAND_LIST)taskID WithParam:(NSDictionary *)param withMethod:(NSString*)method success:(void(^)(id result))success failure:(void(^)(NSError *erro))failure
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    
    /**
     字典参数转换成json
     */
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:param];
    [tempDic setObject:[NSString stringWithUTF8String:cHttpMethod[taskID]] forKey:@"Class"];
    [tempDic setObject:@"community" forKey:@"WebSite"]; //和服务器约定好的，值不变
    
    NSDictionary *paramDic       = @{@"ios":tempDic};
    
    NSURL * url = [NSURL URLWithString:URL_BASE relativeToURL:_HTTPManager.baseURL];
    NSMutableURLRequest *request = [_HTTPManager.requestSerializer requestWithMethod:method URLString:[url absoluteString] parameters:paramDic error:nil];
    
    NSData *cookiesData = nil;
    if (self.cooikeSuffer) {
        cookiesData = self.cooikeSuffer;
    }else{
        cookiesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"];
    }
    if([cookiesData length]) {
        
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData];
        
        for (NSHTTPCookie *cookie in cookies) {
            if ([cookie.name isEqualToString:@"skey"]) {
                NSString *cooikeString = [NSString stringWithFormat:@"%@=%@",cookie.name,cookie.value];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                [request setValue:cooikeString forHTTPHeaderField:@"Cookie"];
            }
        }
    }
    
    [request setTimeoutInterval:TIME_NETOUT];
    
    AFHTTPRequestOperation *operation = [_HTTPManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *headerDic = operation.response.allHeaderFields;
        
        if ([headerDic objectForKey:@"Set-Cookie"]) {
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
            self.cooikeSuffer = data;
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Cookie"];
            
        }
        //NSLog(@"%@..",operation.responseString);
        id result = [operation.responseString JSONValue];
        if (success != nil)
        {
            //网络加载完成的时候
            success(result);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             if (operation.response.statusCode == 401) { //没有权限，提示登录
                                                 //权限失效或者没权限，通知登录
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToLogin object:nil];
                                                 //[MBProgressHUD showError:@"登录过期" toView:window];
                                             }
                                             else if (operation.response.statusCode == 426)//客户端app版本过低，提示升级
                                             {
                                                 //[MBProgressHUD showError:@"版本过低" toView:window];
                                             }
                                             NSLog(@"error:%@",error.description);
                                             if (failure != nil)
                                             {
                                                 failure(error);
                                             }
                                         }];
    
    [_HTTPManager.operationQueue addOperation:operation];
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
