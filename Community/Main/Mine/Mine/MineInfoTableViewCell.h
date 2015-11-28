//
//  MineInfoTableViewCell.h
//  Community
//
//  Created by amber on 15/11/15.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineInfoTableViewCell : UITableViewCell

@property (nonatomic,retain)NSArray *userDataInfo;

- (void)configureCellWithInfo:(SharedInfo *)shareInfo;

@end
