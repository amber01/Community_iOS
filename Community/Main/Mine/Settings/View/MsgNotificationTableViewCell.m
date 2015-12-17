//
//  MsgNotificationTableViewCell.m
//  Community
//
//  Created by shlity on 15/12/17.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MsgNotificationTableViewCell.h"

@implementation MsgNotificationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.msgSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenWidth - 94/2 - 15, 44/2-14, 94, 28)];
        [self.contentView addSubview:_msgSwitch];
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
