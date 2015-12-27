//
//  TopicSendNavigationView.h
//  Community
//
//  Created by amber on 15/12/27.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicSendNavigationView : UIView

@property (nonatomic,retain)UILabel     *titleLable;
@property (nonatomic,retain)UIImageView *downImageView;

- (void)setNavigationTitle:(NSString *)title;

@end