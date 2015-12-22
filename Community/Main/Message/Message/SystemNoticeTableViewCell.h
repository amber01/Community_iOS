//
//  SystemNoticeTableViewCell.h
//  Community
//
//  Created by amber on 15/12/22.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemNoticeTableViewCell : UITableViewCell

@property (nonatomic,retain)UILabel *detailLabel;
@property (nonatomic,retain)UIImageView *avatarImageView;
@property (nonatomic,retain)UILabel *systemNameLabel;
@property (nonatomic,retain)UIView  *msgBgView;
@property (nonatomic,retain)UILabel *dateLabel;


- (void)configureCellWithInfo:(SystemNoticeModel *)model;

@end
