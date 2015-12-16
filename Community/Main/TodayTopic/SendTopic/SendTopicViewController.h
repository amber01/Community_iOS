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
    SendTopicTypePeople,  //百姓话题
    SendTopicTypeInformation,//看资讯
    SendTopicTypePhotosFood,//聊美食
    SendTopicTypePlay,//   去哪玩
    SendTopicTypeFeeling,// 谈感情
    SendTopicTypeFunny,//  搞笑吧
    SendTopicTypeEducation,//"育儿经
    SendTopicTypeHealth,//  爱健康
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
