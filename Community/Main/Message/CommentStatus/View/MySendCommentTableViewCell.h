//
//  MySendCommentTableViewCell.h
//  Community
//
//  Created by shlity on 15/12/11.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySendCommentTableViewCell : UITableViewCell

@property (nonatomic,retain)UIButton  *commentBtn;

- (void)configureWithCellInfo:(MyCommentModel *)model;


@end
