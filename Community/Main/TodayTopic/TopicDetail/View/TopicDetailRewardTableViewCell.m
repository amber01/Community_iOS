//
//  TopicDetailRewardTableViewCell.m
//  Community
//
//  Created by shlity on 15/12/22.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicDetailRewardTableViewCell.h"

@implementation TopicDetailRewardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.avatarBtn = [[PubliButton alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
        [UIUtils setupViewRadius:_avatarBtn cornerRadius:_avatarBtn.height/2];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarBtn.right + 10, 55/2-10, ScreenWidth - _avatarBtn.width - 20 - 50, 20)];
        _titleLabel.text = @"userName";
        
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 55/2-10, ScreenWidth - 40, 20)];
        _scoreLabel.text = @"20";
        _scoreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
        _scoreLabel.textAlignment = NSTextAlignmentRight;
        _scoreLabel.textColor = [UIColor orangeColor];
        [self.contentView addSubview:_scoreLabel];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_avatarBtn];
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
