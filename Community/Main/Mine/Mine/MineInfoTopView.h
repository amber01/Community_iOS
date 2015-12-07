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

@property (nonatomic,retain) UIButton     *topicBtn;
@property (nonatomic,retain) PubliButton  *myFansBtn;
@property (nonatomic,retain) PubliButton  *followBtn;

@property (nonatomic,retain) UIImageView     *sexImageView;
@property (nonatomic,retain) UILabel         *nicknameLabel;
@property (nonatomic,retain) UIImageView     *avatarImageView;

- (instancetype)initWithFrame:(CGRect)frame withUserID:(NSString *)user_id andNickname:(NSString *)nickname andUserName:(NSString *)userName andAvararUrl:(NSString *)avatarUrl;

@end