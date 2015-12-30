//
//  CommentLikeTableViewCell.m
//  Community
//
//  Created by amber on 15/12/12.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "CommentLikeTableViewCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

@implementation CommentLikeTableViewCell
{
    PubliButton         *avatarImageView;
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    
    UILabel             *contentLabel;
    UILabel             *commentLabel;
    
    UILabel             *likeLabel;
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
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, 20)];
        [contentLabel verticalUpAlignmentWithText: @"说的方法第三方水电费水电费水电费说的方法第三方第三方第三方的说法是法师打发" maxHeight:10];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = TEXT_COLOR;
        [contentLabel setFont:[UIFont systemFontOfSize:14]];
        
        commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, contentLabel.bottom + 10, ScreenHeight - 30, 20)];
        commentLabel.textColor = [UIColor grayColor];
        commentLabel.font = [UIFont systemFontOfSize:10];
        //commentLabel.text = @"师傅的说法第三方";
        
        likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, contentLabel.bottom + 5,100,20)];
        likeLabel.text = @"顶了你";
        likeLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:likeLabel];
        [self.contentView addSubview:avatarImageView];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:contentLabel];
        [self.contentView addSubview:nicknameLabel];
        [self.contentView addSubview:commentLabel];
    }
    return self;
}

- (void)configureWithCellInfo:(CommentLikeModel *)model
{
    [avatarImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.logopicturedomain],BASE_IMAGE_URL,face,model.logopicture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    nicknameLabel.text = model.nickname;
    
    dateLabel.text = [NSString stringWithFormat:@"%@",[UIUtils format:model.createtime]];
    /**
     *  动态计算内容高度
     */
    
    // 表情映射。
    NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                convertToSystemEmoticons:model.detail];

    contentLabel.text = [NSString stringWithFormat:@"@我:%@",didReceiveText];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize contentHeight = [contentLabel.text boundingRectWithSize:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    contentLabel.frame = CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, contentHeight.height);
    likeLabel.frame = CGRectMake(15, contentLabel.bottom + 5,100,20);
    self.frame = CGRectMake(0, 0, ScreenWidth, avatarImageView.height + 10 + 10 + contentLabel.height + likeLabel.height + 10 + 5);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end