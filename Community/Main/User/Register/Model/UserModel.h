//
//  UserModel.h
//  Community
//
//  Created by amber on 15/11/19.
//  Copyright © 2015年 shlity. All rights reserved.
//


#import <JSONModel/JSONModel.h>

@interface UserModel : JSONModel

@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *isshow;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *lasttime;
@property (nonatomic,copy)NSString *user_id;

@end
