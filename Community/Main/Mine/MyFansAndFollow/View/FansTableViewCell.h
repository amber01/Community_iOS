//
//  FansTableViewCell.h
//  Community
//
//  Created by amber on 15/12/5.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MyFansListCategory = 0, //查看我的粉丝
    MyFollwListCategory,  //查看我的关注
} MyFansListType;


@interface FansTableViewCell : UITableViewCell

@property (nonatomic,retain)PubliButton  *followBtn;

- (void)configureCellWithInfo:(FansListModel *)model withFollowData:(NSArray *)followArray andRow:(NSInteger)row withStatus:(MyFansListType )status;

@end
