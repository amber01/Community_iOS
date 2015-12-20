//
//  TopicCommentDetailView.h
//  Community
//
//  Created by amber on 15/12/20.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCommentDetailView : UIView
{
    MBProgressHUD  *progress;
}

- (instancetype)initWithFrame:(CGRect)frame withPostID:(NSString *)post_id isReawrd:(NSString *)isReawrd;

@property (nonatomic,retain  ) UIView         *rewardView;
@property (nonatomic,retain  ) UIView         *commentView;
@property (nonatomic,retain  ) PubliButton    *checkUserInfoBtn;
@property (nonatomic,retain  ) PubliButton    *rewardBtn;
@property (nonatomic,retain  ) UILabel        *rewardLNumberLabel;
@property (nonatomic,retain  ) UILabel        *rewardScoreLabel;

@property (nonatomic,copy    ) NSString       *post_id;

@property (nonatomic,copy    ) NSString       *sortStr;
@property (nonatomic,copy    ) NSString       *userID;
@property (nonatomic,copy    ) NSString       *tempUserID;

@property (nonatomic,retain  ) NSMutableArray *dataArray;
@property (nonatomic,retain  ) NSMutableArray *likeDataArray;//记录本地点赞的状态
@property (nonatomic,retain  ) NSMutableArray *praiseDataArray;//自己是否点赞的数据

@end
