//
//  CheckTopicDetailModel.h
//  Community
//
//  Created by amber on 15/12/27.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CheckTopicDetailModel : JSONModel

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
@property (nonatomic,copy)NSString  *postid;

@end
