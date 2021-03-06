//
//  EveryoneTopicTableViewCell.h
//  Community
//
//  Created by amber on 15/11/21.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
#import <UIButton+WebCache.h>
#import "HZPhotoBrowser.h"

@interface EveryoneTopicTableViewCell : UITableViewCell<UIGestureRecognizerDelegate,MLEmojiLabelDelegate,HZPhotoBrowserDelegate>

- (void)configureCellWithInfo:(EveryoneTopicModel *)model withImages:(NSArray *)imageArray andPraiseData:(NSArray *)praiseArray andRow:(NSInteger )row;

@property (nonatomic,retain) NSMutableArray *photoUrlArray;  //大图
@property (nonatomic,retain) NSMutableArray *thumbnailArray; //缩略图

@property (nonatomic,retain) PubliButton         *likeBtn;
@property (nonatomic,retain) UILabel             *likeLabel;

@property (nonatomic,retain) UIImageView         *likeImageView;


@end