//
//  TopicDetailFootView.h
//  Community
//
//  Created by amber on 15/11/27.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicDetailFootView : UIView

@property (nonatomic,retain)UIButton *writeCommentBtn;
@property (nonatomic,retain)UIButton *checkCommentBtn;
@property (nonatomic,retain)UIButton *likeBtn;
@property (nonatomic,retain)UIButton *shareBtn;

@property (nonatomic,retain)UILabel  *commentNumLabel;
@property (nonatomic,retain)UILabel  *likeNumLabel;

@end
