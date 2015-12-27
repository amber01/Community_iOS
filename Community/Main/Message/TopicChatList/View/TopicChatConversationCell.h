//
//  TopicChatConversationCell.h
//  Community
//
//  Created by shlity on 15/12/23.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicChatConversationCell : UITableViewCell

@property (retain, nonatomic) UILabel *labName;
@property (retain, nonatomic) UILabel *labMsg;
@property (retain, nonatomic) UILabel *labTime;
@property (retain, nonatomic) UIImageView *imgHeader;

@property (nonatomic,retain)UILabel     *tipsLabel;
@property (nonatomic,retain)UIView      *tipsView;


@end
