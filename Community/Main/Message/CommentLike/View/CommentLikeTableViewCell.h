//
//  CommentLikeTableViewCell.h
//  Community
//
//  Created by amber on 15/12/12.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentLikeTableViewCell : UITableViewCell

@property (nonatomic,retain)UIButton  *likeBtn;

- (void)configureWithCellInfo:(CommentLikeModel *)model;


@end
