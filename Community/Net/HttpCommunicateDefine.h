//
//  HttpCommunicateDefine.h
//  GoddessClock
//
//  Created by Andy on 14-8-12.
//  Copyright (c) 2014年 iMac. All rights reserved.
//

#ifndef GoddessClock_HttpCommunicateDefine_h
#define GoddessClock_HttpCommunicateDefine_h


typedef NS_ENUM (NSInteger , HttpResponseCode)
{
    HttpResponseOk = 0,
    HttpResponseError,
    HttpResponseLoginError,
    HttpResponseCnout
};


#define URL_BASE            @"http://www.v0577.cn/sendjson/myapi.ashx"
#define SEND_TOPIC_IMAGE    @"http://www.v0577.cn/sendjson/uploadfile.ashx?type=1"
#define SEND_AVATAR_IMAGE   @"http://www.v0577.cn/sendjson/uploadfile.ashx?type=2"

#define ROOT_URL            @"http://www.v0577.cn/"

#define BASE_IMAGE_URL      @"v0577.cn"

#define postinfo @"/postinfo/small/" //帖子图片文件夹
#define face @"/face/"  //头像图片文件夹
#define guanggao @"/guanggao/" //广告图片文件夹
#define BigImage @"/postinfo/big/" //帖子选中时返回的大图

//http后缀
typedef NS_ENUM(NSInteger,HTTP_COMMAND_LIST){
    //登录方法1
    HTTP_METHOD_LOGIN,
    //注册方法2
    HTTP_METHOD_REGISTER,
    //注册时发送验证码3
    HTTP_COMMAND_SEND_CODE,
    //发布帖子4
    HTTP_COMMAND_SEND_TOPIC,
    //首页滚动广告5
    HTTP_COMMAND_ADVERTIS,
    //点赞6
    HTTP_METHOD_PRAISE,
    //获取评论列表7
    HTTP_METHOD_COMMENT,
    //评论点赞 8
    HTTP_METHOD_COMMENT_LIKE,
    //关注相关 9
    HTTP_METHOD_FANS,
    //获取城市列表 10
    HTTP_METHOD_CITY_LIST,
    //收藏帖子 11
    HTTP_METHOD_MY_COLLECTION,
    //帖子打赏 12
    HTTP_METHOD_SCORE_INFO,
    //系统通知 13
    HTTP_SYSTEM_NOTICE,
    //选择城市 14
    HTTP_SELECT_CITY,
    //供求信息下得子分类 15
    HTTP_SUB_CLASS_CATE,
    //关注话题相关 16
    HTTP_METHOD_CONCERN,
    //对用户名和UserID加密  17
    HTTP_METHOD_ENCRYPT,
    
    /*******************/
    HTTP_METHOD_RESERVE,
    HTTP_METHOD_COUNT
};


static char cHttpMethod[HTTP_METHOD_COUNT][64] = {
    
    "Login",//1
    "UserInfo",//2
    "VerCode", //3
    "PostInfo", //4
    "Advertis", //5
    "PostToPraise", //6
    "CommentInfo",//7
    "CommentToPraise", //8
    "MyFansInfo", //9
    "Area", //10
    "MyCollectionInfo", //11
    "UserScoreLogInfo", //12
    "Notice",           //13
    "Installed",       //14
    "ClassInfo",       //15
    "MyAttentionClass", //16
    "Encrypt",          //17
};

/*****************************************************************************/

typedef NS_ENUM(NSUInteger,ServiceStatusTypeDefine){
    
    ServiceStatusTypeWaitingDefine = 1,
    ServiceStatusTypeWorkingDefine,
    ServiceStatusTypeFinishedDefine,
    ServiceStatusTypeDefineCount,
};

#endif
