//
//  MessageTableViewCell.m
//  Community
//
//  Created by amber on 15/12/15.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tipsView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - 44, 60/2-7, 14, 14)];
        self.tipsView.backgroundColor = [UIColor redColor];
        [UIUtils setupViewRadius:_tipsView cornerRadius:_tipsView.height/2];
        
        self.tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _tipsView.height/2-10, _tipsView.width, 20)];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.font = [UIFont systemFontOfSize:9];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"0";
        [_tipsView addSubview:_tipsLabel];
        [self.contentView addSubview:_tipsView];
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
