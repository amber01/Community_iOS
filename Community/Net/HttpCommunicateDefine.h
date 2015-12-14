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


#define URL_BASE            @"http://wwww.jgysh.com/sendjson/myapi.ashx"
#define SEND_TOPIC_IMAGE    @"http://wwww.jgysh.com/sendjson/uploadfile.ashx?type=1"
#define SEND_AVATAR_IMAGE   @"http://wwww.jgysh.com/sendjson/uploadfile.ashx?type=2"

#define ROOT_URL            @"http://wwww.jgysh.com/"

#define BASE_IMAGE_URL      @"jgysh.com"

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
};

/*****************************************************************************/

typedef NS_ENUM(NSUInteger,ServiceStatusTypeDefine){
    
    ServiceStatusTypeWaitingDefine = 1,
    ServiceStatusTypeWorkingDefine,
    ServiceStatusTypeFinishedDefine,
    ServiceStatusTypeDefineCount,
};

#endif
