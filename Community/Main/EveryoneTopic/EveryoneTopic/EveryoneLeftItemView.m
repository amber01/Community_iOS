//
//  EveryoneLeftItemView.m
//  Community
//
//  Created by amber on 16/3/27.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "EveryoneLeftItemView.h"

@implementation EveryoneLeftItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = CGRectMake(10, 0, frame.size.width, frame.size.height);

        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _leftBtn.height/2-12.5 , 25, 25)];
        imageView.image = [UIImage imageNamed:@"home_current_city"];
        [self.leftBtn addSubview:imageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 5, _leftBtn.height/2 - 10, 100, 20)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"温州";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_leftBtn addSubview:_titleLabel];
        [self addSubview:_leftBtn];
    }
    return self;
}

- (void)setLeftItem:(NSString *)title
{
    
}

@end
