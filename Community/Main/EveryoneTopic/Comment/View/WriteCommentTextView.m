//
//  WriteCommentTextView.m
//  Community
//
//  Created by amber on 15/12/5.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "WriteCommentTextView.h"

@implementation WriteCommentTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(5,5, frame.size.width - 10, 110)];
        _contentTextView.returnKeyType = UIReturnKeyDefault;
        _contentTextView.keyboardType = UIKeyboardTypeDefault;
        _contentTextView.scrollEnabled = YES;
        _contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_contentTextView setFont:[UIFont systemFontOfSize:15.0f]];
        
        [self addSubview:_contentTextView];
    }
    return self;
}

@end
