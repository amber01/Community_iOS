//
//  CommentTableViewCell.h
//  Community
//
//  Created by amber on 15/11/26.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic,retain) NSMutableArray *photoUrlArray;

@property (nonatomic,retain) PubliButton         *likeBtn;
@property (nonatomic,retain) UILabel             *likeLabel;

@property (nonatomic,retain) UIImageView         *likeImageView;


- (void)configureCellWithInfo:(CommentModel *)model  withRow:(NSInteger )row andPraiseData:(NSArray *)praiseArray withMasterID:(NSString *)masterID;

@end
