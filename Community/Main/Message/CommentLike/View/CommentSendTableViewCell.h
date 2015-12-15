//
//  CommentSendTableViewCell.h
//  Community
//
//  Created by shlity on 15/12/15.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentSendTableViewCell : UITableViewCell

@property (nonatomic,retain)UIButton  *likeBtn;

- (void)configureWithCellInfo:(CommentLikeModel *)model;

@end
