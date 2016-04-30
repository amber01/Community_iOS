
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
    UIImageView   *activityImageView;
    UILabel       *sendDateLabel;
    UILabel       *activityLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 85, 64)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView setImage:[UIImage imageNamed:@"001"]];
        [self.contentView addSubview:imageView];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 10, ScreenWidth - imageView.width - 40, 40)];
        [contentLabel verticalUpAlignmentWithText:@"是现代作家朱自清于1925年所写的一篇回忆性散文这篇散文叙述的是作者离开南京到北京大学，父亲送他到浦口车站，照料他上车，并替他买橘子的情形。" maxHeight:50];
        contentLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:contentLabel];
        
//        likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.right + 10, imageView.bottom - 14, 17, 13)];
//        likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
//        [self.contentView addSubview:likeImageView];
//        likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(likeImageView.right+3, imageView.bottom - 17, ScreenWidth - likeImageView.width - imageView.width - 40, 20)];
//        likeNumLabel.textColor = TEXT_COLOR;
//        likeNumLabel.font = [UIFont systemFontOfSize:12];
//        [self.contentView addSubview:likeNumLabel];
        
        sendDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right, imageView.bottom - 17, ScreenWidth - 110, 20)];
        sendDateLabel.textAlignment = NSTextAlignmentCenter;
        sendDateLabel.textColor = TEXT_COLOR;
        sendDateLabel.text = @"1小时前";
        sendDateLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:sendDateLabel];
        
        commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, imageView.bottom - 17, ScreenWidth - 110, 20)];
        commentLabel.textColor = TEXT_COLOR;
        commentLabel.font = [UIFont systemFontOfSize:12];
        commentLabel.text = @"232评论";
        commentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:commentLabel];
//        
//        activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(commentLabel.right, imageView.bottom - 13, 20*1.5, 9*1.5)];
//        activityImageView.image = [UIImage imageNamed:@"topic_is_activity.png"];
//        [self.contentView addSubview:activityImageView];
        
        activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 10,  imageView.bottom - 17, ScreenWidth - 110, 20)];
        activityLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:activityLabel];
    }
    return self;
}

- (void)configureCellWithInfo:(TodayTopicModel *)model
{
    contentLabel.text = model.name;
    sendDateLabel.text = [NSString stringWithFormat:@"%@",[UIUtils format:model.createtime]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.images]placeholderImage:[UIImage imageNamed:@"default_background_icon"]];
    likeNumLabel.text = model.praisenum;
    commentLabel.text = [NSString stringWithFormat:@"%@评论",model.commentnum];
    if ([model.isact intValue] == 1) {
        commentLabel.frame = CGRectMake(100 - 30 - 5,  imageView.bottom - 17, ScreenWidth - 110, 20);
    }else{
        commentLabel.frame = CGRectMake(100,  imageView.bottom - 17, ScreenWidth - 110, 20);
    }
    
    if ([model.isseo intValue] == 1) {
        activityLabel.text = @"推广";
        activityLabel.hidden = NO;
        activityLabel.textColor = TEXT_COLOR;
    }else{
        if ([model.isact intValue] == 1) {
            activityLabel.hidden = NO;
            activityLabel.text = @"活动";
            activityLabel.textColor = BASE_COLOR;
        }else{
            activityLabel.hidden = YES;
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
