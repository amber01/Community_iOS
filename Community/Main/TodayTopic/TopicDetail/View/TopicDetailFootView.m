
//
//  TopicDetailFootView.m
//  Community
//
//  Created by amber on 15/11/27.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicDetailFootView.h"

@implementation TopicDetailFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [CommonClass setBorderWithView:self top:YES left:NO bottom:NO right:NO borderColor:LINE_COLOR borderWidth:0.5];
        float btnWidth = ScreenWidth / 9;
        self.writeCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _writeCommentBtn.frame = CGRectMake(0, 0, btnWidth * 3, frame.size.height);
        UIImageView *writeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15*scaleToScreenHeight, _writeCommentBtn.height/2 - 12.5, 25, 25)];
        [writeImageView setImage:[UIImage imageNamed:@"comment_write"]];
        [_writeCommentBtn addSubview:writeImageView];
        UILabel *writeBtnLabel = [[UILabel alloc]initWithFrame:CGRectMake(writeImageView.right + 5*scaleToScreenHeight, _writeCommentBtn.height/2 - 10, _writeCommentBtn.width - writeImageView.width - 30, 20)];
        writeBtnLabel.textColor = [UIColor grayColor];
        writeBtnLabel.text = @"写评论";
        writeBtnLabel.font = [UIFont systemFontOfSize:15];
        [_writeCommentBtn addSubview:writeBtnLabel];
        
        self.checkCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkCommentBtn.frame = CGRectMake(_writeCommentBtn.right, 0, btnWidth * 2, frame.size.height);
        [_checkCommentBtn setImage:[UIImage imageNamed:@"topic_detail_comment"] forState:UIControlStateNormal];
        
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.frame = CGRectMake(_checkCommentBtn.right, 0, btnWidth * 2, frame.size.height);
        [_likeBtn setImage:[UIImage imageNamed:@"topic_detail_like"] forState:UIControlStateNormal];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(_likeBtn.right, 0, btnWidth * 2, frame.size.height);
        [_shareBtn setImage:[UIImage imageNamed:@"mine_share"] forState:UIControlStateNormal];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 0.5,frame.size.height - 20)];
        line1.backgroundColor = LINE_COLOR;
        [_checkCommentBtn addSubview:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 0.5,frame.size.height - 20)];
        line2.backgroundColor = LINE_COLOR;
        [_likeBtn addSubview:line2];

        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 0.5,frame.size.height - 20)];
        line3.backgroundColor = LINE_COLOR;
        [_shareBtn addSubview:line3];
        
        self.commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(_checkCommentBtn.width/2 + 12.5, 5,10, 12)];
        _commentNumLabel.backgroundColor = [UIColor colorWithHexString:@"#ff9900"];
        [_commentNumLabel setTextAlignment:NSTextAlignmentCenter];
        _commentNumLabel.text = @"0";
        [UIUtils setupViewRadius:_commentNumLabel cornerRadius:2];
        _commentNumLabel.font = [UIFont systemFontOfSize:10];
        _commentNumLabel.textColor = [UIColor whiteColor];
        [_checkCommentBtn addSubview:_commentNumLabel];
        
        self.likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(_likeBtn.width/2 + 12.5, 5,10, 12)];
        _likeNumLabel.backgroundColor = [UIColor colorWithHexString:@"#ff9900"];
        [_likeNumLabel setTextAlignment:NSTextAlignmentCenter];
        _likeNumLabel.text = @"0";
        _likeNumLabel.textColor = [UIColor whiteColor];
        [UIUtils setupViewRadius:_likeNumLabel cornerRadius:2];
        _likeNumLabel.font = [UIFont systemFontOfSize:10];
        [_likeBtn addSubview:_likeNumLabel];
        
        [self addSubview:_writeCommentBtn];
        [self addSubview:_checkCommentBtn];
        [self addSubview:_likeBtn];
        [self addSubview:_shareBtn];
    }
    return self;
}

@end
