//
//  FansListViewController.h
//  Community
//
//  Created by amber on 15/12/5.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    FansListCategory = 0, //查看我的粉丝
    FollwListCategory,  //查看我的关注
} FansListType;

@interface FansListViewController : BaseViewController

@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *status;

@end
