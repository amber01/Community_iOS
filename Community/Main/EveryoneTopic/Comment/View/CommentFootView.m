//
//  CommentFootView.m
//  Community
//
//  Created by amber on 15/11/26.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "CommentFootView.h"

@implementation CommentFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        [CommonClass setBorderWithView:self top:YES left:NO bottom:NO right:NO borderColor:LINE_COLOR borderWidth:0.5];
        self.writeCommentBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        self.writeCommentBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        UIImageView *writeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-40,frame.size.height/2-12.5, 25, 25)];
        writeImageView.image = [UIImage imageNamed:@"comment_write"];
        UILabel *writeLabel = [[UILabel alloc]initWithFrame:CGRectMake(writeImageView.right + 10, frame.size.height/2-10, 100, 20)];
        writeLabel.textColor = [UIColor grayColor];
        writeLabel.text = @"写评论";
        writeLabel.font = [UIFont systemFontOfSize:15];
        [_writeCommentBtn addSubview:writeImageView];
        [_writeCommentBtn addSubview:writeLabel];
        [self addSubview:_writeCommentBtn];
    }
    return self;
}

@end
