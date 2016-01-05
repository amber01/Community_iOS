//
//  TodayTopicModel.h
//  Community
//
//  Created by amber on 15/11/22.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TodayTopicModel : JSONModel

@property (nonatomic,copy)NSString *classid;
@property (nonatomic,copy)NSString *commentnum; //评论
@property (nonatomic,copy)NSString *detail; //内容
@property (nonatomic,copy)NSString *id; //帖子id
@property (nonatomic,copy)NSString *picture; //图片
@property (nonatomic,copy)NSString *imagecount;
@property (nonatomic,copy)NSString *picturedomain;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *praisenum;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *isact;  //isact=1  显示活动图标

@end
