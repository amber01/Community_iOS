//
//  ModifyUserInfoTableViewCell.m
//  Community
//
//  Created by amber on 15/11/30.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "ModifyUserInfoTableViewCell.h"

@implementation ModifyUserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 70, 10, 60, 60)];
        [UIUtils setupViewRadius:self.avatarImageView cornerRadius:60/2];
        [self.contentView addSubview:self.avatarImageView];
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
