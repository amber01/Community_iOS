//
//  TopicSearchTableViewCell.h
//  Community
//
//  Created by amber on 15/12/10.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicSearchTableViewCell : UITableViewCell

@property (nonatomic,retain)PubliButton  *followBtn;

- (void)configureCellWithInfo:(UserModel *)model;

@end
