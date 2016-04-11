//
//  DiscoverViewController.h
//  Community
//
//  Created by shlity on 16/4/6.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "BaseViewController.h"
#import "DLTabedSlideView.h"

typedef enum : NSUInteger {
    DiscoverTopic = 1,
    DiscoverFriendSquare,
    DiscoverFindFriend,
    DiscoverFindTopic
} DiscoverTabType;

@interface DiscoverViewController : BaseViewController <DLTabedSlideViewDelegate>

@property (nonatomic,retain)DLTabedSlideView *tabedSlideView;

@end
