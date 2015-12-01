//
//  MineInfoTopView.m
//  Community
//
//  Created by amber on 15/11/30.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MineInfoTopView.h"
#import "ModifyUserInfoViewController.h"

@implementation MineInfoTopView
{
    UIImageView     *avatarImageView;
    UILabel         *nickname;
    UILabel         *prestigeLabel;
    UILabel         *scoreLabel;
    UIButton        *topicBtn;
    UIButton        *myFansBtn;
    UIButton        *followBtn;
    UIButton        *editUserInfoBtn;
    UIImageView     *sexImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        SharedInfo *share = [SharedInfo sharedDataInfo];
        
        avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, -15, 60, 60)];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:avatarImageView.width/2];
        [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",picturedomain,BASE_IMAGE_URL,face,share.picture]]placeholderImage:[UIImage imageNamed:@"mine_login"]];
        
        nickname = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right + 10, 5, ScreenWidth - avatarImageView.width + 20 + 10, 20)];
        nickname.font = [UIFont systemFontOfSize:15];
        nickname.text = share.nickname;
        
        sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(avatarImageView.right + 2, avatarImageView.bottom - 16,25/2, 28/2)];
        sexImageView.image = [UIImage imageNamed:@"user_women"];
        
        prestigeLabel = [[UILabel alloc]initWithFrame:CGRectMake(sexImageView.right + 10, avatarImageView.bottom - 19, 60, 20)];
        prestigeLabel.textColor = TEXT_COLOR;
        prestigeLabel.font = [UIFont systemFontOfSize:12];
        prestigeLabel.text = @"威望:V2";
        
        scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(prestigeLabel.right, prestigeLabel.top, 150, 20)];
        scoreLabel.textColor = TEXT_COLOR;
        scoreLabel.font = [UIFont systemFontOfSize:12];
        scoreLabel.text = [NSString stringWithFormat:@"积分:%@",share.totalscore];
        
        
        topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topicBtn.frame = CGRectMake(0, prestigeLabel.bottom + 15, ScreenWidth/3, 20);
        [CommonClass setBorderWithView:topicBtn top:NO left:NO bottom:NO right:YES borderColor:LINE_COLOR borderWidth:0.5];
        topicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [topicBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [topicBtn setTitle:[NSString stringWithFormat:@"%@帖子",share.postnum] forState:UIControlStateNormal];
        
        
        myFansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        myFansBtn.frame = CGRectMake(topicBtn.right, prestigeLabel.bottom + 15, ScreenWidth/3, 20);
        [CommonClass setBorderWithView:myFansBtn top:NO left:NO bottom:NO right:YES borderColor:LINE_COLOR borderWidth:0.5];
        myFansBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [myFansBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [myFansBtn setTitle:[NSString stringWithFormat:@"%@粉丝",share.myfansnum] forState:UIControlStateNormal];
        
        followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        followBtn.frame = CGRectMake(myFansBtn.right, prestigeLabel.bottom + 15, ScreenWidth/3, 20);
        followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [followBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [followBtn setTitle:[NSString stringWithFormat:@"%@关注",share.postnum] forState:UIControlStateNormal];
        
        editUserInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editUserInfoBtn.frame = CGRectMake(ScreenWidth/2 - (236/2)/2, followBtn.bottom + 18, 236/2, 75/2);
        [editUserInfoBtn addTarget:self action:@selector(editUserInfoAction) forControlEvents:UIControlEventTouchUpInside];
        [editUserInfoBtn setImage:[UIImage imageNamed:@"mine_user_edit"] forState:UIControlStateNormal];
        
        UILabel *btnTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, editUserInfoBtn.height/2-10, editUserInfoBtn.width - 20, 20)];
        btnTitleLabel.textColor = [UIColor colorWithHexString:@"#62b312"];
        btnTitleLabel.font = [UIFont systemFontOfSize:14];
        btnTitleLabel.text = @"编辑资料";
        btnTitleLabel.textAlignment = NSTextAlignmentRight;
        [editUserInfoBtn addSubview:btnTitleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, editUserInfoBtn.bottom + 10, ScreenWidth, 10)];
        [CommonClass setBorderWithView:lineView top:YES left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        lineView.backgroundColor = CELL_COLOR;
        
        [self addSubview:lineView];
        [self addSubview:avatarImageView];
        [self addSubview:nickname];
        [self addSubview:prestigeLabel];
        [self addSubview:scoreLabel];
        [self addSubview:topicBtn];
        [self addSubview:myFansBtn];
        [self addSubview:followBtn];
        [self addSubview:editUserInfoBtn];
        [self addSubview:sexImageView];
    }
    return self;
}

- (void)editUserInfoAction
{
    ModifyUserInfoViewController *modifyUserVC = [[ModifyUserInfoViewController alloc]init];
    [self.viewController.navigationController pushViewController:modifyUserVC animated:YES];
}

@end
