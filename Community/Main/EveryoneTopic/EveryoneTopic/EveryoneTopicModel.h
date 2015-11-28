//
//  EveryoneTopicModel.h
//  Community
//
//  Created by shlity on 15/11/24.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "JSONModel.h"

@interface EveryoneTopicModel : JSONModel

@property (nonatomic,retain)NSString  *address;
@property (nonatomic,retain)NSString  *classname;
@property (nonatomic,retain)NSString  *commentnum; //回复数
@property (nonatomic,retain)NSString  *praisenum;  //点赞数
@property (nonatomic,retain)NSString  *createtime; //发布时间
@property (nonatomic,retain)NSString  *detail;     //内容
@property (nonatomic,retain)NSString  *hitnumber;  //缩略图
@property (nonatomic,retain)NSString  *id;
@property (nonatomic,retain)NSString  *imagecount;
@property (nonatomic,retain)NSString  *isshow;
@property (nonatomic,retain)NSString  *logopicture;
@property (nonatomic,retain)NSString  *nickname;
@property (nonatomic,retain)NSString  *name; 
@property (nonatomic,retain)NSString  *sort;
@property (nonatomic,retain)NSString  *username;


@end
