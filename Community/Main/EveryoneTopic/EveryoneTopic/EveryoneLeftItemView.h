//
//  EveryoneLeftItemView.h
//  Community
//
//  Created by amber on 16/3/27.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EveryoneLeftItemView : UIView

@property (nonatomic,retain)UIButton *leftBtn;
@property (nonatomic,retain)UILabel  *titleLabel;

- (void)setLeftItem:(NSString *)title;

@end
