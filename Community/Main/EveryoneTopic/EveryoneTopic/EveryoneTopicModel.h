//
//  EveryoneTopicModel.h
//  Community
//
//  Created by shlity on 15/11/24.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "JSONModel.h"

@interface EveryoneTopicModel : JSONModel

@property (nonatomic,copy)NSString  *address;
@property (nonatomic,copy)NSString  *classname;
@property (nonatomic,copy)NSString  *commentnum; //回复数
@property (nonatomic,copy)NSString  *praisenum;  //点赞数
@property (nonatomic,copy)NSString  *createtime; //发布时间
@property (nonatomic,copy)NSString  *detail;     //内容
@property (nonatomic,copy)NSString  *hitnumber;  //缩略图
@property (nonatomic,copy)NSString  *id;
@property (nonatomic,copy)NSString  *imagecount;
@property (nonatomic,copy)NSString  *isshow;
@property (nonatomic,copy)NSString  *logopicture;
@property (nonatomic,copy)NSString  *logopicturedomain;
@property (nonatomic,copy)NSString  *nickname;
@property (nonatomic,copy)NSString  *name;
@property (nonatomic,copy)NSString  *sort;
@property (nonatomic,copy)NSString  *username;
@property (nonatomic,copy)NSString  *userid;
@property (nonatomic,copy)NSString  *source;

@end
