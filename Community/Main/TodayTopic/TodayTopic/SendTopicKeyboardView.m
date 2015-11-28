//
//  SendTopicKeyboardView.m
//  Community
//
//  Created by amber on 15/11/12.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "SendTopicKeyboardView.h"

@implementation SendTopicKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [CommonClass setBorderWithView:self top:YES left:NO bottom:NO right:NO borderColor:LINE_COLOR borderWidth:0.5];
        self.sendPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendPhotoBtn setImage:[UIImage imageNamed:@"topic_send_photo"] forState:UIControlStateNormal];
        _sendPhotoBtn.frame = CGRectMake(15, frame.size.height/2 - 12.5, 25, 25);
        [self addSubview:_sendPhotoBtn];
        
        self.sendEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendEmojiBtn setImage:[UIImage imageNamed:@"topic_send_emoji"] forState:UIControlStateNormal];
        _sendEmojiBtn.frame = CGRectMake(_sendPhotoBtn.right + 25, frame.size.height/2 - 12.5, 25, 25);
        [self addSubview:_sendEmojiBtn];
    }
    return self;
}

@end
