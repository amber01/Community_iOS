//
//  TopicLikeTableViewCell.m
//  Community
//
//  Created by amber on 15/12/11.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicLikeTableViewCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

@implementation TopicLikeTableViewCell
{
    PubliButton         *avatarImageView;
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    
    UILabel             *contentLabel;
    UILabel             *commentLabel;
    UIView              *contentView;
    
    UILabel             *likeLabel;
    UIImageView         *topicImageView;
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
        
        likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right + 10, avatarImageView.bottom + 10,100,20)];
        likeLabel.text = @"给你点了赞！";
        likeLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:likeLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(likeLabel.left, likeLabel.bottom + 5, ScreenWidth - avatarImageView.width + 15 + 10, 0.5)];
        lineView.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:lineView];
        
        topicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(likeLabel.left, lineView.bottom + 10, 78, 50)];
        topicImageView.contentMode = UIViewContentModeScaleAspectFill;
        topicImageView.clipsToBounds = YES;
        [self.contentView addSubview:topicImageView];
        
        contentView = [[UIView alloc]initWithFrame:CGRectMake(topicImageView.right, topicImageView.top, ScreenWidth - 20 - topicImageView.width - 10 - avatarImageView.width - 15, 50)];
        contentView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, contentView.width - 10, 50)];
        contentLabel.textColor = TEXT_COLOR2;
        [contentLabel setFont:[UIFont systemFontOfSize:14]];
        contentLabel.numberOfLines = 2;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
        
        [contentView addSubview:contentLabel];
        
        [self.contentView addSubview:avatarImageView];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:contentView];
        [self.contentView addSubview:nicknameLabel];
    }
    return self;
}

- (void)configureWithCellInfo:(TopicLikeModel *)model
{
    [avatarImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.logopicturedomain],BASE_IMAGE_URL,face,model.logopicture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    nicknameLabel.text = model.nickname;
    dateLabel.text = [NSString stringWithFormat:@"%@",[UIUtils format:model.createtime]];
    [topicImageView sd_setImageWithURL:[NSURL URLWithString:model.postpicture]];

    if (model.postpicture.length > 0) {
        contentView.frame = CGRectMake(topicImageView.right, topicImageView.top, ScreenWidth - 20 - topicImageView.width - 10 - avatarImageView.width - 15, 50);
        contentLabel.frame = CGRectMake(10, 0, contentView.width - 10, 50);
    }else{
        contentView.frame = CGRectMake(topicImageView.left, topicImageView.top, ScreenWidth - 20 - topicImageView.width - 10 - avatarImageView.width - 15 + 78, 50);
        contentLabel.frame = CGRectMake(10, 0, contentView.width - 10, 50);
    }
    /**
     *  动态计算内容高度
     */
    // 表情映射。
//    NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
//                                convertToSystemEmoticons:model.detail];
//    
//    contentLabel.text = [NSString stringWithFormat:@"@我:%@",didReceiveText];
//    
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
//    CGSize contentHeight = [contentLabel.text boundingRectWithSize:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    contentLabel.frame = CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, contentHeight.height);
    contentLabel.text = model.detail;
    self.frame = CGRectMake(0, 0, ScreenWidth, avatarImageView.height + 10 + 10 + contentLabel.height + likeLabel.height + 10 + 5 + 30);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
