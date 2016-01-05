//
//  SendTopicViewController.h
//  Community
//
//  Created by shlity on 15/11/10.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    SendTopicTypeCity = 0, //同城互动
    SendTopicTypePhotosShow,//秀自拍
    SendTopicTypePeople,  //相亲交友
    SendTopicTypeInformation,//热点
    SendTopicTypePhotosFood,//吃货吧
    SendTopicTypePlay,//   去哪玩
    SendTopicTypeFeeling,// 男女情感
    SendTopicTypeFunny,//  轻松一刻
    SendTopicTypeEducation,//"汽车之家
    SendTopicTypeHealth,//  健康养生
    SendTopicTypeCommunity,//灌小区
    SendTopicTypeShareInfo,//供求信息
    SendTopicTypeSuggestion,//提建议
} SendTopicType;

@interface SendTopicViewController : BaseViewController
@property (nonatomic,copy)NSString *cate_id;

@property (nonatomic,copy)NSString          *topicTitle;
@property (nonatomic,copy)NSString          *topicContent;
@property (nonatomic,copy)NSMutableArray    *myDraftDataArray;
@property (nonatomic,copy)NSString          *listTag;

@end
