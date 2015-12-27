//
//  TopicSendNavigationView.m
//  Community
//
//  Created by amber on 15/12/27.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicSendNavigationView.h"

@implementation TopicSendNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 80, 20)];
        self.titleLable.font = [UIFont systemFontOfSize:19];
        self.titleLable.textColor = [UIColor whiteColor];
        [self addSubview:_titleLable];
        self.downImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"send_topic_down"]];
        [self addSubview:_downImageView];
    }
    return self;
}

- (void)setNavigationTitle:(NSString *)title
{
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:19] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.titleLable.text = title;
    self.titleLable.frame = CGRectMake(0, 32, ScreenWidth - 200, 20);
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.downImageView.frame = CGRectMake(self.titleLable.frame.size.width/2+(titleSize.width/2)+10, 40, 12, 6);
}

@end
