//
//  CommentTableViewCell.m
//  Community
//
//  Created by amber on 15/11/26.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell
{
    UIImageView         *avatarImageView;
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    
    UILabel             *contentLabel;
    UIButton            *likeBtn;
    UILabel             *likeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 45, 45)];
        avatarImageView.image = [UIImage imageNamed:@"001"];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:45/2];
        
        nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, 12, ScreenWidth - avatarImageView.width - 40, 20)];
        nicknameLabel.font = [UIFont systemFontOfSize:14];
        nicknameLabel.text = @"盛夏光年";
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, nicknameLabel.bottom+2, ScreenWidth - avatarImageView.width - 40, 20)];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.text = @"今天 12:23 iPhone6";
        
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, 20)];
        [contentLabel verticalUpAlignmentWithText: @"说的方法第三方水电费水电费水电费说的方法第三方第三方第三方的说法是法师打发" maxHeight:10];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        [contentLabel setFont:[UIFont systemFontOfSize:15]];
        likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        likeBtn.frame = CGRectMake(ScreenWidth - 13 - 15,15, 13 + 15, 26);
        likeBtn.backgroundColor = [UIColor whiteColor];
        [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 26/2 - 13, 34/2, 26/2)];
        likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
        likeImageView.userInteractionEnabled = YES;
        [likeBtn addSubview:likeImageView];
        
        likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - likeBtn.width - 10 - 55,12, 60, 20)];
        likeLabel.textColor = [UIColor grayColor];
        likeLabel.textAlignment = NSTextAlignmentRight;
        likeLabel.font = [UIFont systemFontOfSize:10];
        likeLabel.text = @"顶 232";
        
        [self addSubview:avatarImageView];
        [self addSubview:nicknameLabel];
        [self addSubview:dateLabel];
        [self addSubview:contentLabel];
        [self addSubview:likeBtn];
        [self addSubview:likeLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
