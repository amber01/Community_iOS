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
@property (nonatomic,copy)NSString *city;  //城市id
@property (nonatomic,copy)NSString *lasttime;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *createtime;
@property (nonatomic,copy)NSString *picture;  //用户头像
@property (nonatomic,copy)NSString *myfansnum; //我的粉丝
@property (nonatomic,copy)NSString *mytofansnum; //我的关注
@property (nonatomic,copy)NSString *postnum;  // 我的帖子数
@property (nonatomic,copy)NSString *totalscore; //我的积分
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *client;
@property (nonatomic,copy)NSString *cityarea;  //城市名(市)
@property (nonatomic,copy)NSString *provincearea; //省份
@property (nonatomic,copy)NSString *picturedomain;
@property (nonatomic,copy)NSString *locationAddress;  //当前地址
@property (nonatomic,copy)NSString *isv; //是否加v

@property (nonatomic,copy)NSString *latitude;//    当前的经度
@property (nonatomic,copy)NSString *longitude;  //当前纬度

@property (nonatomic,assign)float  iamgeHeight;

@property (nonatomic,copy)NSString *tempCityarea;  //城市名(市)
@property (nonatomic,copy)NSString *tempProvincearea; //省份

+(SharedInfo *)sharedDataInfo;

@end
