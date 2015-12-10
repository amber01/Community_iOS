//
//  FansTableViewCell.h
//  Community
//
//  Created by amber on 15/12/5.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansListViewController.h"

@interface FansTableViewCell : UITableViewCell

@property (nonatomic,retain)PubliButton  *followBtn;


- (void)configureCellWithInfo:(FansListModel *)model withStatus:(FansListType )status;

@end
