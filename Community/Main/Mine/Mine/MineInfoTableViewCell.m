//
//  MineInfoTableViewCell.m
//  Community
//
//  Created by amber on 15/11/15.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MineInfoTableViewCell.h"

@implementation MineInfoTableViewCell
{
    UIImageView *avatarImageView;
    UIButton    *postsBtn;
    UIButton    *fansBtn;
    UIButton    *followBtn;
    UIButton    *scoreBtn;
    
    UILabel     *postsNumLabel;
    UILabel     *fansNumLabel;
    UILabel     *followNumLabel;
    UILabel     *scoreNumLabel;
    
    UILabel     *nicknameLabel;
    UILabel     *prestigeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 125)];
        avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:30];
        
        nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right + 10, 15, ScreenWidth - avatarImageView.right - 30, 20)];
        nicknameLabel.text = @"盛夏光年";
        [nicknameLabel setFont:[UIFont systemFontOfSize:16]];
        
        prestigeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nicknameLabel.left, nicknameLabel.bottom + 10, 230, 20)];
        prestigeLabel.textColor = TEXT_COLOR;
        [prestigeLabel setFont:[UIFont systemFontOfSize:14]];
        prestigeLabel.text = @"威望:V2";
        
        postsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        postsBtn.frame = CGRectMake(0, bgView.height - 53, ScreenWidth/4, 40);
        
        fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fansBtn.frame = CGRectMake(postsBtn.right, bgView.height - 53, ScreenWidth/4, 40);
        
        followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        followBtn.frame = CGRectMake(fansBtn.right, bgView.height - 53, ScreenWidth/4, 40);
        
        scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        scoreBtn.frame = CGRectMake(followBtn.right, bgView.height - 53, ScreenWidth/4, 40);
        
        [CommonClass setBorderWithView:postsBtn top:NO left:NO bottom:NO right:YES borderColor:LINE_COLOR borderWidth:0.5];
        [CommonClass setBorderWithView:fansBtn top:NO left:NO bottom:NO right:YES borderColor:LINE_COLOR borderWidth:0.5];
        [CommonClass setBorderWithView:followBtn top:NO left:NO bottom:NO right:YES borderColor:LINE_COLOR borderWidth:0.5];
        
        UILabel *postLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, ScreenWidth/4, 20)];
        [postLabel setFont:[UIFont systemFontOfSize:14]];
        postLabel.text = @"帖子";
        postLabel.textAlignment = NSTextAlignmentCenter;
        postLabel.textColor = TEXT_COLOR;
        
        UILabel *fansLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, ScreenWidth/4, 20)];
        [fansLabel setFont:[UIFont systemFontOfSize:14]];
        fansLabel.text = @"粉丝";
        fansLabel.textAlignment = NSTextAlignmentCenter;
        fansLabel.textColor = TEXT_COLOR;
        
        
        UILabel *followLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, ScreenWidth/4, 20)];
        [followLabel setFont:[UIFont systemFontOfSize:14]];
        followLabel.text = @"关注";
        followLabel.textAlignment = NSTextAlignmentCenter;
        followLabel.textColor = TEXT_COLOR;
        
        
        UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, ScreenWidth/4, 20)];
        [scoreLabel setFont:[UIFont systemFontOfSize:14]];
        scoreLabel.text = @"积分";
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.textColor = TEXT_COLOR;
        
        postsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, ScreenWidth/4, 20)];
        postsNumLabel.font = [UIFont systemFontOfSize:14];
        postsNumLabel.textAlignment = NSTextAlignmentCenter;
        postsNumLabel.text = @"23";
        
        fansNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, ScreenWidth/4, 20)];
        fansNumLabel.font = [UIFont systemFontOfSize:14];
        fansNumLabel.textAlignment = NSTextAlignmentCenter;
        fansNumLabel.text = @"23";
        
        followNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, ScreenWidth/4, 20)];
        followNumLabel.font = [UIFont systemFontOfSize:14];
        followNumLabel.textAlignment = NSTextAlignmentCenter;
        followNumLabel.text = @"23";
        
        scoreNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, ScreenWidth/4, 20)];
        scoreNumLabel.font = [UIFont systemFontOfSize:14];
        scoreNumLabel.textAlignment = NSTextAlignmentCenter;
        scoreNumLabel.text = @"23";
        
        [scoreBtn addSubview:scoreNumLabel];
        [followBtn addSubview:followNumLabel];
        [fansBtn addSubview:fansNumLabel];
        [postsBtn addSubview:postsNumLabel];
        
        [scoreBtn addSubview:scoreLabel];
        [followBtn addSubview:followLabel];
        [fansBtn addSubview:fansLabel];
        [postsBtn addSubview:postLabel];
        
        [bgView addSubview:prestigeLabel];
        [bgView addSubview:scoreBtn];
        [bgView addSubview:followBtn];
        [bgView addSubview:fansBtn];
        [bgView addSubview:postsBtn];
        [bgView addSubview:nicknameLabel];
        [bgView addSubview:avatarImageView];
        [self.contentView addSubview:bgView];
    }
    return self;
}

- (void)configureCellWithInfo:(SharedInfo *)shareInfo
{
    NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",picturedomain,BASE_IMAGE_URL,face,shareInfo.picture];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"mine_login"]];
    nicknameLabel.text = shareInfo.nickname;
    postsNumLabel.text = shareInfo.postnum;
    fansNumLabel.text = shareInfo.myfansnum;
    followNumLabel.text = shareInfo.mytofansnum;
    scoreNumLabel.text = shareInfo.totalscore;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end