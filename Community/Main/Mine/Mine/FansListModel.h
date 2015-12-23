//
//  FansListModel.h
//  Community
//
//  Created by amber on 15/12/6.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FansListModel : JSONModel

@property (nonatomic,copy)NSString *logopicture;
@property (nonatomic,copy)NSString *tologopicture;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *tousername;
@property (nonatomic,copy)NSString *touserid;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *tonickname;
@property (nonatomic,copy)NSString *logopicturedomain;
@property (nonatomic,copy)NSString *nickname;

@end
