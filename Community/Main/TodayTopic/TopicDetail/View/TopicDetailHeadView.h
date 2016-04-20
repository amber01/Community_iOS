//
//  TopicDetailHeadView.h
//  Community
//
//  Created by amber on 15/12/12.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicDetailHeadView : UIView

@property (nonatomic,retain)UILabel     *titleLabel;
@property (nonatomic,retain)UIButton    *likeBtn;
@property (nonatomic,retain)UIButton    *commentBtn;
@property (nonatomic,retain)UIButton    *shareBtn;

- (void)getUserInfoData:(NSDictionary*)data;

@end

