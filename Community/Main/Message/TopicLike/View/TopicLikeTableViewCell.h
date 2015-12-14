//
//  TopicLikeTableViewCell.h
//  Community
//
//  Created by amber on 15/12/11.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicLikeTableViewCell : UITableViewCell

@property (nonatomic,retain)UIButton  *likeBtn;

- (void)configureWithCellInfo:(TopicLikeModel *)model;

@end
