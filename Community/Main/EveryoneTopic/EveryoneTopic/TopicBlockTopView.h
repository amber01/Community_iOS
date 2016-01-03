//
//  TopicBlockTopView.h
//  Community
//
//  Created by amber on 15/11/28.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryoneTopicHeadView.h"
#import "DWTagList.h"

@interface TopicBlockTopView : UIView <DWTagListDelegate>

- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName wihtIsShowSubView:(BOOL)isSubView;

@property (nonatomic,retain) UILabel               *blockNameLabel;
@property (nonatomic,retain) UILabel               *topicNumberLabel;
@property (nonatomic,retain) UILabel               *todayNumberLabel;
@property (nonatomic,retain) EveryoneTopicHeadView *topicHeadView;

@property (nonatomic,retain) DWTagList             *tagList;
@property (nonatomic,retain) NSMutableArray        *titleArray;
@property (nonatomic,retain) NSMutableArray        *dataArray;

- (void)setTopImageIcon:(NSString *)imageName withIsShowSubView:(BOOL)isSubView;

@end
