//
//  CKHttpRequest.h
//  Community
//
//  Created by amber on 15/11/15.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "HttpCommunicateDefine.h"

@interface CKHttpRequest : NSObject

@property (nonatomic,copy) NSData *cooikeSuffer;

+ (id)sharedInstance;

+ (void)createRequest:(HTTP_COMMAND_LIST)requestID WithParam:(NSDictionary *)param withMethod:(NSString*)method success:(void(^)(id result))success failure:(void(^)(NSError *erro))failure;

@end
