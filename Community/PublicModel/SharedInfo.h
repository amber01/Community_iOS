//
//  SharedInfo.h
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedInfo : NSObject

@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *isshow;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *lasttime;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *createtime;
@property (nonatomic,copy)NSString *picture;  //用户头像
@property (nonatomic,copy)NSString *myfansnum; //我的粉丝
@property (nonatomic,copy)NSString *mytofansnum; //我的关注
@property (nonatomic,copy)NSString *postnum;  // 我的帖子数
@property (nonatomic,copy)NSString *totalscore; //我的积分

+(SharedInfo *)sharedDataInfo;

@end