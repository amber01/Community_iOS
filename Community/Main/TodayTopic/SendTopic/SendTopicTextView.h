//
//  SendTopicTextView.h
//  Community
//
//  Created by amber on 15/11/10.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendTopicTextView : UIView<UITextViewDelegate>

@property (nonatomic,retain)UITextField *titleTextField;
@property (nonatomic,retain)UITextView  *contentTextView;

@property (nonatomic,retain) UILabel     *defaultLabel;
@end
