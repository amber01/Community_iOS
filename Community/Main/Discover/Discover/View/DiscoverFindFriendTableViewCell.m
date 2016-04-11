//
//  DiscoverFindFriendTableViewCell.m
//  Community
//
//  Created by shlity on 16/4/11.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverFindFriendTableViewCell.h"

@implementation DiscoverFindFriendTableViewCell
{
    UILabel             *prestigeLabel;  //声望
    UILabel             *nickNameLabel;
    UILabel             *postsNumLabel;
    UILabel             *fansNumLabel;
    PubliButton         *addFollowBtn;
    PubliButton         *avatarBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        avatarBtn = [[PubliButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
        [avatarBtn addTarget:self action:@selector(checkAvatarAction) forControlEvents:UIControlEventTouchUpInside];
        [UIUtils setupViewRadius:avatarBtn cornerRadius:avatarBtn.height/2];
        [self.contentView addSubview:avatarBtn];
        
        nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarBtn.right + 10, avatarBtn.top, ScreenWidth - avatarBtn.width - 50, 20)];
        nickNameLabel.textColor = TEXT_COLOR;
        nickNameLabel.font = kFont(16);
        nickNameLabel.text = @"盛夏光年";
        [self.contentView addSubview:nickNameLabel];
        
        prestigeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nickNameLabel.right + 10, nickNameLabel.top + 2, 32, 16)];
        prestigeLabel.textAlignment = NSTextAlignmentCenter;
        prestigeLabel.textColor = [UIColor whiteColor];
        prestigeLabel.backgroundColor = [UIColor colorWithHexString:@"#f5a623"];
        [UIUtils setupViewRadius:prestigeLabel cornerRadius:3];
        prestigeLabel.font = kFont(12);
        prestigeLabel.text = @"v1";
        [self.contentView addSubview:prestigeLabel];
        
        postsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(nickNameLabel.left, nickNameLabel.bottom, 60, 20)];
        postsNumLabel.textColor = TEXT_COLOR;
        postsNumLabel.font = kFont(12);
        postsNumLabel.text = @"帖子 20";
        [self.contentView addSubview:postsNumLabel];
        
        fansNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(postsNumLabel.right, nickNameLabel.bottom, 200, 20)];
        fansNumLabel.textColor = TEXT_COLOR;
        fansNumLabel.font = kFont(12);
        fansNumLabel.text = @"粉丝 120";
        [self.contentView addSubview:fansNumLabel];
        
        addFollowBtn = [[PubliButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70 - 20, 80/2 - 15, 70, 30)];
        [addFollowBtn setBackgroundImage:[UIImage imageNamed:@"discover_add_follow.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:addFollowBtn];
    }
    return self;
}

- (void)configureCellWithInfo:(DiscoverFindFriendModel *)model
{
    [avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.picturedomain],BASE_IMAGE_URL,face,model.picture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    nickNameLabel.text = model.nickname;
    CGSize textSize = [nickNameLabel.text sizeWithFont:kFont(16) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGRect nicknameFrame = nickNameLabel.frame;
    nicknameFrame.size.width = textSize.width;
    nickNameLabel.frame = nicknameFrame;
    
    prestigeLabel.frame = CGRectMake(nickNameLabel.right + 10, nickNameLabel.top + 2, 32, 16);
    prestigeLabel.text = [NSString stringWithFormat:@"v%@",model.prestige];
    
    if ([model.isfocus intValue] == 1) { //已关注
        [addFollowBtn setBackgroundImage:[UIImage imageNamed:@"discover_cancel_follow.png"] forState:UIControlStateNormal];
    }else{
        [addFollowBtn setBackgroundImage:[UIImage imageNamed:@"discover_add_follow.png"] forState:UIControlStateNormal];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
