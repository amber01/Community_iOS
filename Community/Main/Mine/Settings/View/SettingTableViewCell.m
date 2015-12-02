//
//  SettingTableViewCell.m
//  Community
//
//  Created by shlity on 15/12/2.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.logoutTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 44/2-10, ScreenWidth, 20)];
        _logoutTitle.textColor = BASE_COLOR;
        _logoutTitle.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_logoutTitle];
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
