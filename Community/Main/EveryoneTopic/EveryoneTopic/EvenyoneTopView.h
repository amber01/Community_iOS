//
//  EvenyoneTopView.h
//  Community
//
//  Created by amber on 15/11/21.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryoneTopicHeadView.h"

@interface EvenyoneTopView : UIView<UIScrollViewDelegate>

@property (nonatomic,retain) EveryoneTopicHeadView *topicHeadView;

- (void)setupTopButton:(int)page;

@end
