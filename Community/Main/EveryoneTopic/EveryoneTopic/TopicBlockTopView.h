//
//  TopicBlockTopView.h
//  Community
//
//  Created by amber on 15/11/28.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryoneTopicHeadView.h"

@interface TopicBlockTopView : UIView

- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName;

@property (nonatomic,retain) UILabel               *blockNameLabel;
@property (nonatomic,retain) UILabel               *topicNumberLabel;
@property (nonatomic,retain) UILabel               *todayNumberLabel;
@property (nonatomic,retain) EveryoneTopicHeadView *topicHeadView;

- (void)setTopImageIcon:(NSString *)imageName;

@end
