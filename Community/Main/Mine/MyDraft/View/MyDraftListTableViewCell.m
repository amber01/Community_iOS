//
//  MyDraftListTableViewCell.m
//  Community
//
//  Created by shlity on 15/12/16.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MyDraftListTableViewCell.h"

@implementation MyDraftListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.topicNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, ScreenWidth - 30, 20)];
        _topicNameLabel.text = @"新帖子";
        [self.contentView addSubview:_topicNameLabel];
        
        self.topicDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _topicNameLabel.bottom + 7, ScreenWidth - 30, 20)];
        _topicDetailLabel.textColor = TEXT_COLOR;
        _topicDetailLabel.font = [UIFont systemFontOfSize:13];
        _topicDetailLabel.text = @"是的范德萨发水电费";
        [self.contentView addSubview:_topicDetailLabel];
        
        self.topicDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-110, 20, 100, 20)];
        _topicDateLabel.textColor = TEXT_COLOR;
        _topicDateLabel.textAlignment = NSTextAlignmentRight;
        _topicDateLabel.text = @"今天 20:33";
        _topicDateLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_topicDateLabel];
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
