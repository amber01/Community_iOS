//
//  DiscoverFindTopicTableViewCell.m
//  Community
//
//  Created by shlity on 16/4/11.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverFindTopicTableViewCell.h"

@implementation DiscoverFindTopicTableViewCell
{
    UIImageView *topicImageView;
    UILabel     *topicTitleLabel;
    UILabel     *careNumLabel;
    UILabel     *postsNumLabel;
    UILabel     *todayNumLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        topicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
        [UIUtils setupViewRadius:topicImageView cornerRadius:5];
        [self.contentView addSubview:topicImageView];
        
        topicTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(topicImageView.right + 10, 17, ScreenWidth - 100, 20)];
        topicTitleLabel.font = kFont(16);
        topicTitleLabel.text = @"民以食为天";
        [self.contentView addSubview:topicTitleLabel];
        
        careNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(topicTitleLabel.left, topicTitleLabel.bottom + 7, 60, 20)];
        careNumLabel.font = kFont(12);
        careNumLabel.text = @"关注 3";
        careNumLabel.textColor = TEXT_COLOR;
        [self.contentView addSubview:careNumLabel];
        
        postsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(careNumLabel.right, topicTitleLabel.bottom + 7, 60, 20)];
        postsNumLabel.font = kFont(12);
        postsNumLabel.text = @"帖子 3";
        postsNumLabel.textColor = TEXT_COLOR;
        [self.contentView addSubview:postsNumLabel];
        
        todayNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(postsNumLabel.right, topicTitleLabel.bottom + 7, 60, 20)];
        todayNumLabel.font = kFont(12);
        todayNumLabel.text = @"今日 3";
        todayNumLabel.textColor = TEXT_COLOR;
        [self.contentView addSubview:todayNumLabel];
        
        self.addFollowBtn = [[PubliButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70 - 20, 80/2 - 15.5, 70, 31)];
        [_addFollowBtn setBackgroundImage:[UIImage imageNamed:@"discover_add_topic.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_addFollowBtn];
    }
    return self;
}

- (void)configureCellWithInfo:(NSMutableArray *)dataArray WithIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *tempArr = [[dataArray objectAtIndex:indexPath.section] objectForKey:@"topicInfo"];
    NSMutableDictionary *dic = [tempArr objectAtIndex:indexPath.row];
    
    [topicImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pictureurl"]] placeholderImage:[UIImage imageWithColor:VIEW_COLOR]];
    topicTitleLabel.text = [dic objectForKey:@"name"];
    careNumLabel.text = [NSString stringWithFormat:@"关注 %@",[dic objectForKey:@"usernum"]];
    postsNumLabel.text = [NSString stringWithFormat:@"帖子 %@",[dic objectForKey:@"postnum"]];
    todayNumLabel.text = [NSString stringWithFormat:@"今日 %@",[dic objectForKey:@"todaynum"]];
    
    if ([[dic objectForKey:@"isfocus"]intValue] == 1) {
        [_addFollowBtn setBackgroundImage:[UIImage imageNamed:@"discover_cancel_topic.png"] forState:UIControlStateNormal];
    }else{
        [_addFollowBtn setBackgroundImage:[UIImage imageNamed:@"discover_add_topic.png"] forState:UIControlStateNormal];
    }
}

#pragma mark -- other
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
