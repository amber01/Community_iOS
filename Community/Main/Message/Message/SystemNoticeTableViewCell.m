//
//  SystemNoticeTableViewCell.m
//  Community
//
//  Created by amber on 15/12/22.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "SystemNoticeTableViewCell.h"

@implementation SystemNoticeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
        _avatarImageView.image = [UIImage imageNamed:@"system_notice_icon"];
        _avatarImageView.layer.cornerRadius = 45/2;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.borderWidth = 2;
        _avatarImageView.layer.borderColor = [UIColor colorWithHexString:@"#faf8f8"].CGColor;
        
        _systemNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _avatarImageView.bottom + 5, _avatarImageView.width + 40, 20)];
        _systemNameLabel.textColor = TEXT_COLOR;
        _systemNameLabel.font =  [UIFont fontWithName:@"Helvetica" size:15];
        _systemNameLabel.textAlignment = NSTextAlignmentCenter;
        //_systemNameLabel.text = @"系统消息";
        
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(_avatarImageView.right + 3, _avatarImageView.height/2+8,11, 11)];
        leftView.image = [UIImage imageNamed:@"msg_notifi_left_view"];
        
        _msgBgView = [[UIView alloc]initWithFrame:CGRectMake(leftView.right-0.7, 15, ScreenWidth - leftView.right - 15 - 30, 70)];
        _msgBgView.layer.borderWidth = 0.5;
        _msgBgView.clipsToBounds = YES;
        _msgBgView.layer.cornerRadius = 7;
        _msgBgView.backgroundColor = [UIColor whiteColor];
        _msgBgView.layer.borderColor = [UIColor colorWithHexString:@"#d9d9d9"].CGColor;
        
        _detailLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, 10, _msgBgView.width - 15, 38)];
        _detailLabel.font =  [UIFont fontWithName:@"Helvetica" size:16];
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.text = @"撒旦法神烦大叔是的范德萨发是的范德萨发";
                
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _msgBgView.bottom + 10, ScreenWidth, 20)];
        _dateLabel.textColor = [UIColor grayColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:12];

        [_msgBgView addSubview:_detailLabel];
        [self.contentView addSubview:_systemNameLabel];
        [self.contentView addSubview:_avatarImageView];
        [self.contentView addSubview:_msgBgView];
        [self.contentView addSubview:leftView];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

- (void)configureCellWithInfo:(SystemNoticeModel *)model
{
    self.detailLabel.text = model.detail;
    
    NSLog(@"content:%@",model.detail);
    
    //动态内容高度
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    CGSize textLabelSize = [model.detail boundingRectWithSize:CGSizeMake(self.detailLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    

    self.dateLabel.text = [NSString stringWithFormat:@"%@",[UIUtils format:model.createtime]];
        self.detailLabel.frame = CGRectMake(10, 10, self.msgBgView.width - 10, textLabelSize.height);
    self.msgBgView.frame = CGRectMake(self.avatarImageView.right + 4 - 0.7 + 10, 15, ScreenWidth - self.avatarImageView.right - 25 - 30, self.detailLabel.bottom + 10);
    self.dateLabel.frame = CGRectMake(0, _msgBgView.bottom + 10, ScreenWidth, 20);
    self.frame = CGRectMake(0, 10, ScreenWidth, self.msgBgView.height + 5 + _avatarImageView.height);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
