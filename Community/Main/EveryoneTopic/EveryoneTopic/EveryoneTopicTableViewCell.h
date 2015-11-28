//
//  EveryoneTopicTableViewCell.h
//  Community
//
//  Created by amber on 15/11/21.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"

@interface EveryoneTopicTableViewCell : UITableViewCell<SDPhotoBrowserDelegate>

- (void)configureCellWithInfo:(EveryoneTopicModel *)model withImages:(NSArray *)imageArray;
@property (nonatomic,retain)NSMutableArray *photoUrlArray;

@end
