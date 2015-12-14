//
//  MySendCommentTableViewCell.m
//  Community
//
//  Created by shlity on 15/12/11.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MySendCommentTableViewCell.h"

@implementation MySendCommentTableViewCell
{
    PubliButton         *avatarImageView;
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    
    UILabel             *contentLabel;
    UILabel             *commentLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        avatarImageView = [[PubliButton alloc]initWithFrame:CGRectMake(15, 15, 45, 45)];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:45/2];
        
        nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, 18, ScreenWidth - avatarImageView.width - 40, 20)];
        nicknameLabel.font = [UIFont systemFontOfSize:14];
        nicknameLabel.text = @"盛夏光年";
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, nicknameLabel.bottom+2, ScreenWidth - avatarImageView.width - 40, 20)];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.text = @"今天 12:23 iPhone6";
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, 30)];
        [contentLabel verticalUpAlignmentWithText: @"说的方法第三方水电费水电费水电费说的方法第三方第三方第三方的说法是法师打发" maxHeight:10];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 2;
        contentLabel.textColor = TEXT_COLOR;
        [contentLabel setFont:[UIFont systemFontOfSize:14]];
        
        commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, contentLabel.bottom + 10, ScreenHeight - 30, 20)];
        commentLabel.textColor = [UIColor blackColor];
        commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        commentLabel.numberOfLines = 0;
        commentLabel.font = [UIFont systemFontOfSize:15];
        //commentLabel.text = @"师傅的说法第三方";
        
        [self.contentView addSubview:avatarImageView];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:contentLabel];
        [self.contentView addSubview:nicknameLabel];
        [self.contentView addSubview:commentLabel];
    }
    return self;
}

//我收到的
- (void)configureWithCellInfo:(MyCommentModel *)model
{
    [avatarImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.logopicturedomain],BASE_IMAGE_URL,face,model.logopicture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    nicknameLabel.text = model.nickname;
    dateLabel.text = model.createtime;
    /**
     *  评论帖子
     */
    if ([model.isreplay intValue] == 0) {
        //原内容
        contentLabel.text = [NSString stringWithFormat:@"@%@:%@",model.tonickname,model.postdetail];
        //获取UILabel高度
        CGFloat labelHeight = [contentLabel sizeThatFits:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT)].height;
        contentLabel.frame = CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, labelHeight);
        
        //评论的内容
        commentLabel.text = model.detail;
        NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        CGSize commentHeight = [commentLabel.text boundingRectWithSize:CGSizeMake(commentLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
        commentLabel.frame = CGRectMake(15, contentLabel.bottom + 2, ScreenWidth - 30, commentHeight.height);
    }else{ //回复评论
        //原内容
        contentLabel.text = [NSString stringWithFormat:@"@%@:%@",model.tonickname,model.detail];
        //获取UILabel高度
        CGFloat labelHeight = [contentLabel sizeThatFits:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT)].height;
        contentLabel.frame = CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, labelHeight);
        
        //评论的内容
        commentLabel.text = model.replaycontent;
        
        NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        CGSize commentHeight = [commentLabel.text boundingRectWithSize:CGSizeMake(commentLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
        commentLabel.frame = CGRectMake(15, contentLabel.bottom + 2, ScreenWidth - 30, commentHeight.height);
    }
    
    
    self.frame = CGRectMake(0, 0, ScreenWidth, avatarImageView.height + 10 + 10 + contentLabel.height + 10 + commentLabel.height + 5);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
