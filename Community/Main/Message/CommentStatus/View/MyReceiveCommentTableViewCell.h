//
//  MyReceiveCommentTableViewCell.h
//  Community
//
//  Created by shlity on 15/12/11.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReceiveCommentTableViewCell : UITableViewCell

@property (nonatomic,retain)UIButton        *commentBtn;
@property (nonatomic,retain)PubliButton     *addFollowBtn;


- (void)configureWithCellInfo:(MyCommentModel *)model;

@end
