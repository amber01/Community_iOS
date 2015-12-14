//
//  ScorellButtonView.h
//  WSScrollButtonSimple
//
//  Created by shlity on 15/10/28.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewController.h"

@interface ScorellButtonView : UIView<UIScrollViewDelegate>

@property (nonatomic,retain)UISegmentedControl *segmentedView;

- (instancetype)initWithFrame:(CGRect)frame withPostID:(NSString *)postId;

@end
