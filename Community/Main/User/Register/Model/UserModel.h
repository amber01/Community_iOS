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
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *picture;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *totalscore;
@property (nonatomic,copy)NSString *postnum;
@property (nonatomic,copy)NSString *myfansnum;
@property (nonatomic,copy)NSString *mytofansnum;
@property (nonatomic,copy)NSString *picturedomain;
@property (nonatomic,copy)NSString *prestige; //威望

@end
