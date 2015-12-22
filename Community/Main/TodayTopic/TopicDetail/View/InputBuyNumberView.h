//
//  InputBuyNumberView.h
//  妈妈去哪儿
//
//  Created by shlity on 15/12/21.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputBuyNumberView : UIView

@property (nonatomic,retain)UISlider  *mySlider;
@property (nonatomic,retain)UIButton  *returnBtn;
@property (nonatomic,retain)UIButton  *cancelBtn;
@property (nonatomic,retain)UILabel    *scoreNumLabel;
@property (nonatomic,retain)UILabel    *myScoreNumLabel;

@property (nonatomic,retain)UILabel    *leftLabel;
@property (nonatomic,retain)UILabel    *rightLabel;

@property (nonatomic,retain)UIView *alertView;

@end
