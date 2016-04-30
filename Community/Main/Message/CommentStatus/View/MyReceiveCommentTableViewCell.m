//
//  MyReceiveCommentTableViewCell.m
//  Community
//
//  Created by shlity on 15/12/11.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MyReceiveCommentTableViewCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

@implementation MyReceiveCommentTableViewCell
{
    PubliButton         *avatarImageView;
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    
    UILabel             *contentLabel;
    UILabel             *commentLabel;
    UIImageView         *topicImageView;
    UIView              *contentView;
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
        
        commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, avatarImageView.bottom + 15, ScreenWidth - 20 - (avatarImageView.right+10), 30)];
        commentLabel.textColor = [UIColor blackColor];
        commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        commentLabel.numberOfLines = 0;
        commentLabel.font = [UIFont systemFontOfSize:15];
        
        topicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(commentLabel.left, commentLabel.bottom + 10, 78, 50)];
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
        [self.contentView addSubview:commentLabel];
        [self.contentView addSubview:contentView];
        [self.contentView addSubview:nicknameLabel];
    }
    return self;
}

//我收到的
- (void)configureWithCellInfo:(MyCommentModel *)model
{
    [avatarImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.logopicturedomain],BASE_IMAGE_URL,face,model.logopicture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    nicknameLabel.text = model.nickname;
    dateLabel.text = [NSString stringWithFormat:@"%@",[UIUtils format:model.createtime]];
    
    if ([model.isreplay intValue] == 0) {
        //评论帖子评论的内容
        commentLabel.text = model.detail;
    }else{
        //回复评论评论的内容
        commentLabel.text = model.replaycontent;
    }
    
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize commentHeight = [commentLabel.text boundingRectWithSize:CGSizeMake(commentLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    commentLabel.frame = CGRectMake(avatarImageView.right+10, avatarImageView.bottom + 7, ScreenWidth - 20 - (avatarImageView.right+10), commentHeight.height);
    
    topicImageView.frame = CGRectMake(commentLabel.left, commentLabel.bottom + 10 , 78, 50);
    [topicImageView sd_setImageWithURL:[NSURL URLWithString:model.postpicture]];
    
    if (model.postpicture.length > 0) {
        contentView.frame = CGRectMake(topicImageView.right, topicImageView.top, ScreenWidth - 20 - topicImageView.width - 10 - avatarImageView.width - 15, 50);
        contentLabel.frame = CGRectMake(10, 0, contentView.width - 10, 50);
    }else{
        contentView.frame = CGRectMake(topicImageView.left, topicImageView.top, ScreenWidth - 20 - topicImageView.width - 10 - avatarImageView.width - 15 + 78, 50);
        contentLabel.frame = CGRectMake(10, 0, contentView.width - 10, 50);
    }
    
    //原内容
    contentLabel.text = model.postdetail;
    //[contentLabel verticalUpAlignmentWithText: model.postdetail maxHeight:40];
    
    
    //contentLabel.text = model.postdetail; //[NSString stringWithFormat:@"@%@:%@",model.tonickname,model.postdetail];
    //获取UILabel高度
    //CGFloat labelHeight = [contentLabel sizeThatFits:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT)].height;
    
    self.frame = CGRectMake(0, 0, ScreenWidth, avatarImageView.height + 10 + 10 + contentLabel.height + 10 + commentLabel.height + 5 + 20);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
