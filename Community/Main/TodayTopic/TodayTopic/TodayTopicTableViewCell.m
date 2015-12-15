
//
//  TodayTopicTableViewCell.m
//  Community
//
//  Created by amber on 15/11/9.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TodayTopicTableViewCell.h"

@implementation TodayTopicTableViewCell
{
    UIImageView   *imageView;
    UILabel       *commentLabel;
    UILabel       *contentLabel;
    UIImageView   *likeImageView;
    UILabel       *likeNumLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*scaleToScreenHeight, 10*scaleToScreenHeight, 80*scaleToScreenHeight, 60*scaleToScreenHeight)];
        [imageView setImage:[UIImage imageNamed:@"001"]];
        [self.contentView addSubview:imageView];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 10, ScreenWidth - imageView.width - 40, 40)];
        [contentLabel verticalUpAlignmentWithText:@"是现代作家朱自清于1925年所写的一篇回忆性散文这篇散文叙述的是作者离开南京到北京大学，父亲送他到浦口车站，照料他上车，并替他买橘子的情形。" maxHeight:50];
        contentLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:contentLabel];
        
        likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.right + 10, imageView.bottom - 14, 17, 13)];
        likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
        [self.contentView addSubview:likeImageView];
        likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(likeImageView.right+3, imageView.bottom - 17, ScreenWidth - likeImageView.width - imageView.width - 40, 20)];
        likeNumLabel.textColor = TEXT_COLOR;
        likeNumLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:likeNumLabel];
        
        commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, imageView.bottom - 17, ScreenWidth - 115, 20)];
        commentLabel.textColor = TEXT_COLOR;
        commentLabel.font = [UIFont systemFontOfSize:12];
        commentLabel.text = @"232评论";
        commentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:commentLabel];
    }
    return self;
}

- (void)configureCellWithInfo:(TodayTopicModel *)model
{
    contentLabel.text = model.name;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.picturedomain],BASE_IMAGE_URL,postinfo,model.picture]]placeholderImage:[UIImage imageNamed:@"default_background"]];
    likeNumLabel.text = model.praisenum;
    commentLabel.text = [NSString stringWithFormat:@"%@评论",model.commentnum];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
