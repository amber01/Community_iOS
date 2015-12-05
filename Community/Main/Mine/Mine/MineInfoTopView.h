//
//  MineInfoTopView.h
//  Community
//
//  Created by amber on 15/11/30.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineInfoTopView : UIView
{
    MBProgressHUD         * progress;
}

@property (nonatomic,retain) UIButton *topicBtn;
@property (nonatomic,retain) UIButton *myFansBtn;
@property (nonatomic,retain) UIButton *followBtn;

- (instancetype)initWithFrame:(CGRect)frame withUserID:(NSString *)user_id andNickname:(NSString *)nickname andUserName:(NSString *)userName andAvararUrl:(NSString *)avatarUrl;

@end
