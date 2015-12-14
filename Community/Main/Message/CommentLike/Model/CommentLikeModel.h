//
//  CommentLikeModel.h
//  Community
//
//  Created by amber on 15/12/12.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CommentLikeModel : JSONModel

@property (nonatomic,copy)NSString *createtime;
@property (nonatomic,copy)NSString *commentid;
@property (nonatomic,copy)NSString *detail;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *logopicture;
@property (nonatomic,copy)NSString *logopicturedomain;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *tologopicture;
@property (nonatomic,copy)NSString *tologopicturedomain;
@property (nonatomic,copy)NSString *tonickname;
@property (nonatomic,copy)NSString *tousername;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *username;

@end
