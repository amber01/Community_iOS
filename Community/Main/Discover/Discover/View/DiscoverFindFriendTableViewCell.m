//
//  DiscoverFindFriendTableViewCell.m
//  Community
//
//  Created by shlity on 16/4/11.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverFindFriendTableViewCell.h"
#import "MineInfoViewController.h"

@implementation DiscoverFindFriendTableViewCell
{
    UILabel             *prestigeLabel;  //声望
    UILabel             *nickNameLabel;
    UILabel             *postsNumLabel;
    UILabel             *fansNumLabel;
    PubliButton         *avatarBtn;
    UILabel             *nearbyLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        avatarBtn = [[PubliButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
        [avatarBtn addTarget:self action:@selector(checkAvatarAction:) forControlEvents:UIControlEventTouchUpInside];
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
        
        self.addFollowBtn = [[PubliButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70 - 20, 80/2 - 20, 70, 30)];
        [_addFollowBtn setBackgroundImage:[UIImage imageNamed:@"discover_add_follow.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_addFollowBtn];
        
        nearbyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _addFollowBtn.bottom + 8, ScreenWidth - 40, 20)];
        nearbyLabel.textColor = TEXT_COLOR;
        nearbyLabel.font = kFont(12);
        nearbyLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:nearbyLabel];
    }
    return self;
}

- (void)configureCellWithInfo:(DiscoverFindFriendModel *)model
{
    [avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.picturedomain],BASE_IMAGE_URL,face,model.picture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    nickNameLabel.text = model.nickname;
    CGSize textSize = [nickNameLabel.text sizeWithFont:kFont(16) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    avatarBtn.user_id = model.id;
    avatarBtn.nickname = model.nickname;
    avatarBtn.userName = model.username;
    avatarBtn.avatarUrl = model.picture;
    nearbyLabel.text = model.createtime;
    CGRect nicknameFrame = nickNameLabel.frame;
    nicknameFrame.size.width = textSize.width;
    nickNameLabel.frame = nicknameFrame;
    postsNumLabel.text = [NSString stringWithFormat:@"帖子 %@",model.postnum];
    fansNumLabel.text = [NSString stringWithFormat:@"粉丝 %@",model.myfansnum];
    prestigeLabel.frame = CGRectMake(nickNameLabel.right + 10, nickNameLabel.top + 2, 32, 16);
    prestigeLabel.text = [NSString stringWithFormat:@"v%@",model.prestige];
}

- (void)configureCellWithNearbyInfo:(DiscoverNearbyFriendModel *)model
{
    [avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.picturedomain],BASE_IMAGE_URL,face,model.picture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    nickNameLabel.text = model.nickname;
    CGSize textSize = [nickNameLabel.text sizeWithFont:kFont(16) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    avatarBtn.user_id = model.id;
    avatarBtn.nickname = model.nickname;
    avatarBtn.userName = model.username;
    avatarBtn.avatarUrl = model.picture;
    nearbyLabel.text = [NSString stringWithFormat:@"%@ | %@",model.km,model.lasttime];
    CGRect nicknameFrame = nickNameLabel.frame;
    nicknameFrame.size.width = textSize.width;
    nickNameLabel.frame = nicknameFrame;
    postsNumLabel.text = [NSString stringWithFormat:@"帖子 %@",model.postnum];
    fansNumLabel.text = [NSString stringWithFormat:@"粉丝 %@",model.myfansnum];
    prestigeLabel.frame = CGRectMake(nickNameLabel.right + 10, nickNameLabel.top + 2, 32, 16);
    prestigeLabel.text = [NSString stringWithFormat:@"v%@",model.prestige];
}

- (void)checkAvatarAction:(PubliButton *)button
{
    MineInfoViewController *mineInfoVC = [[MineInfoViewController alloc]init];
    [mineInfoVC setHidesBottomBarWhenPushed:YES];
    mineInfoVC.user_id = button.user_id;
    mineInfoVC.nickname = button.nickname;
    mineInfoVC.userName = button.userName;
    mineInfoVC.avatarUrl = button.avatarUrl;
    NSLog(@"button user id:%@",button.user_id);
    [self.viewController.navigationController pushViewController:mineInfoVC animated:YES];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
