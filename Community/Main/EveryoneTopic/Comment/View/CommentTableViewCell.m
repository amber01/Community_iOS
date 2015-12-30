//
//  CommentTableViewCell.m
//  Community
//
//  Created by amber on 15/11/26.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "MineInfoViewController.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

@implementation CommentTableViewCell
{
    PubliButton         *avatarImageView;
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    
    UILabel             *contentLabel;
    UIButton            *photoImageBtn1;
    UIButton            *photoImageBtn2;
    UIButton            *photoImageBtn3;
    
    UILabel             *commentLabel;
    UILabel             *fromLabel;
    UILabel             *replayNicknameLabel;
    
    PubliButton         *commentBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        avatarImageView = [[PubliButton alloc]initWithFrame:CGRectMake(15, 10, 45, 45)];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:45/2];
        
        nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, 12, ScreenWidth - avatarImageView.width - 40, 20)];
        nicknameLabel.font = [UIFont systemFontOfSize:14];
        nicknameLabel.text = @"盛夏光年";
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, nicknameLabel.bottom+2, ScreenWidth - avatarImageView.width - 40, 20)];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.text = @"今天 12:23 iPhone6";
        
        replayNicknameLabel = [[UILabel   alloc]initWithFrame:CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, 20)];
        replayNicknameLabel.textColor = TEXT_COLOR;
        replayNicknameLabel.font = [UIFont systemFontOfSize:14];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, 20)];
        [contentLabel verticalUpAlignmentWithText: @"说的方法第三方水电费水电费水电费说的方法第三方第三方第三方的说法是法师打发" maxHeight:10];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        [contentLabel setFont:[UIFont systemFontOfSize:15]];

        self.likeBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.frame = CGRectMake(ScreenWidth - 13 - 15,15, 13 + 15, 26);
        _likeBtn.backgroundColor = [UIColor whiteColor];
        self.likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 26/2 - 14, 36/2, 28/2)];
        _likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
        _likeImageView.userInteractionEnabled = YES;
        [_likeBtn addSubview:_likeImageView];
        
        self.likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - _likeBtn.width - 10 - 55,12, 60, 20)];
        _likeLabel.textColor = [UIColor grayColor];
        _likeLabel.textAlignment = NSTextAlignmentRight;
        _likeLabel.font = [UIFont systemFontOfSize:10];
        _likeLabel.text = @"顶 232";
        
        [self addSubview:avatarImageView];
        [self addSubview:nicknameLabel];
        [self addSubview:dateLabel];
        [self addSubview:contentLabel];
        [self addSubview:_likeBtn];
        [self addSubview:_likeLabel];
        [self addSubview:replayNicknameLabel];
    }
    return self;
}

- (void)configureCellWithInfo:(CommentModel *)model  withRow:(NSInteger )row andPraiseData:(NSArray *)praiseArray withMasterID:(NSString *)masterID
{
    
    [avatarImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.logopicturedomain],BASE_IMAGE_URL,face,model.logopicture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@%@",model.logopicturedomain,BASE_IMAGE_URL,face,model.logopicture]);
    NSLog(@"images:%@",[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.logopicturedomain],BASE_IMAGE_URL,face,model.logopicture]);
    
    dateLabel.text = [NSString stringWithFormat:@"%@",[UIUtils format:model.createtime]];
    if ([model.isreplay intValue] == 0) { //未回复的
        // 表情映射。
        NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                    convertToSystemEmoticons:model.detail];
        contentLabel.text = didReceiveText;
        nicknameLabel.text = model.nickname;
        replayNicknameLabel.hidden = YES;
        nicknameLabel.textColor = [UIColor blackColor];
    }else{ //已回复的
        replayNicknameLabel.hidden = NO;
        //replaycontent
        replayNicknameLabel.frame = CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, 20);
        replayNicknameLabel.text = [NSString stringWithFormat:@"@%@:",model.tonickname];
        if ([model.userid isEqualToString:masterID]) {
            nicknameLabel.text = [NSString stringWithFormat:@"%@(楼主)",model.nickname];
            // 表情映射。
            NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                        convertToSystemEmoticons:model.replaycontent];
            contentLabel.text = didReceiveText;
            nicknameLabel.textColor = [UIColor orangeColor];
        }else{
            nicknameLabel.text = [NSString stringWithFormat:@"%@",model.nickname];
            NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                        convertToSystemEmoticons:model.replaycontent];
            contentLabel.text = didReceiveText;
            nicknameLabel.textColor = [UIColor blackColor];
        }
    }
    
    avatarImageView.user_id = model.userid;
    avatarImageView.nickname = model.nickname;
    avatarImageView.userName = model.username;
    avatarImageView.avatarUrl = model.logopicture;
    [avatarImageView addTarget:self action:@selector(checkUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     *  获取是否点赞过的数据状态
     */
    if (!isArrEmpty(praiseArray)) {
        NSDictionary *dic = praiseArray[row];
        NSString *post_id = [dic objectForKey:@"commentid"];
        NSString *isPraise = [dic objectForKey:@"value"];
        
        if ([post_id intValue] == [model.id intValue]) {
            if ([isPraise intValue] == 1) {
                _likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
            }else{
                _likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
            }
        }
    }
    
    /**
     *  动态计算内容高度
     */

    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize contentHeight = [contentLabel.text boundingRectWithSize:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
     if (contentLabel.text.length == 0) {
        contentHeight.height = 0;
    }
    
    
    
    [avatarImageView addTarget:self action:@selector(checkUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([model.isreplay intValue] == 0) {
        
        contentLabel.frame = CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, contentHeight.height);
        self.frame = CGRectMake(0, 0, ScreenWidth,avatarImageView.height + 10 + contentHeight.height + 10 + 10);
    }else{
        contentLabel.frame = CGRectMake(15, avatarImageView.bottom + 10 + 20, ScreenWidth - 30, contentHeight.height);
        self.frame = CGRectMake(0, 0, ScreenWidth,avatarImageView.height + 10 + contentHeight.height + 10 + 10 + 20);
    }
}

- (void)checkUserInfo:(PubliButton *)button
{
    MineInfoViewController *userInfoVC = [[MineInfoViewController alloc]init];
    userInfoVC.user_id = button.user_id;
    userInfoVC.nickname = button.nickname;
    userInfoVC.userName = button.userName;
    userInfoVC.avatarUrl = button.avatarUrl;
    [userInfoVC setHidesBottomBarWhenPushed:YES];
    [self.viewController.navigationController pushViewController:userInfoVC animated:YES];
    NSLog(@"user_id:%@",button.user_id);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
