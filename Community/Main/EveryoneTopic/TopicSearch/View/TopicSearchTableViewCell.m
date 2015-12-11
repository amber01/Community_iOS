//
//  TopicSearchTableViewCell.m
//  Community
//
//  Created by amber on 15/12/10.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicSearchTableViewCell.h"

@implementation TopicSearchTableViewCell
{
    UIImageView *avatarImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:45/2];
        
        self.followBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        _followBtn.frame = CGRectMake(ScreenWidth - 45 - 10,65/2 - 33/2, 45, 33);
        [_followBtn setImage:[UIImage imageNamed:@"user_add_follow"] forState:UIControlStateNormal];
        [self.contentView addSubview:_followBtn];
        [self.contentView addSubview:avatarImageView];
    }
    return self;
}

- (void)configureCellWithInfo:(UserModel *)model
{
    NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.picturedomain],BASE_IMAGE_URL,face,model.picture];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"mine_login"]];
    self.textLabel.text = model.nickname;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.textLabel.frame;
    frame.origin.x = avatarImageView.right + 10;
    self.textLabel.frame = frame;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
