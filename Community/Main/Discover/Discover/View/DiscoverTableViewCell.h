//
//  DiscoverTableViewCell.h
//  Community
//
//  Created by shlity on 16/4/7.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZPhotoBrowser.h"


@interface DiscoverTableViewCell : UITableViewCell<HZPhotoBrowserDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,retain) NSMutableArray *photoUrlArray;  //大图
@property (nonatomic,retain) NSMutableArray *thumbnailArray; //缩略图

@property (nonatomic,retain) PubliButton         *likeBtn;
@property (nonatomic,retain) UILabel             *likeLabel;

@property (nonatomic,retain) UIImageView         *likeImageView;

- (void)configureCellWithInfo:(FriendSquareModel*)model;

@end
