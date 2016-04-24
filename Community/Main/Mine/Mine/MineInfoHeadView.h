//
//  MineInfoHeadView.h
//  Community
//
//  Created by amber on 16/4/24.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineInfoHeadView : UIView
{
    MBProgressHUD         * progress;
}

@property (nonatomic,retain) UIButton     *topicBtn;
@property (nonatomic,retain) PubliButton  *myFansBtn;
@property (nonatomic,retain) PubliButton  *followBtn;
@property (nonatomic,retain) PubliButton  *scoreBtn;

- (instancetype)initWithFrame:(CGRect)frame withUserID:(NSString *)user_id andNickname:(NSString *)nickname andUserName:(NSString *)userName andAvararUrl:(NSString *)avatarUrl;

@end
