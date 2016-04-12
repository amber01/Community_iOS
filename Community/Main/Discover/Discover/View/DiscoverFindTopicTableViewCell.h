//
//  DiscoverFindTopicTableViewCell.h
//  Community
//
//  Created by shlity on 16/4/11.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverFindTopicTableViewCell : UITableViewCell

@property (nonatomic,retain)PubliButton *addFollowBtn;

- (void)configureCellWithInfo:(NSMutableArray *)dataArray WithIndexPath:(NSIndexPath *)indexPath;

@end
