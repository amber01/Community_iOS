//
//  TopicDetailHeadView.m
//  Community
//
//  Created by amber on 15/12/12.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicDetailHeadView.h"
#import "MineInfoViewController.h"

@implementation TopicDetailHeadView
{
    PubliButton  *avatarImageView;
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    UIImageView         *showVImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        avatarImageView = [[PubliButton alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:45/2];
        [avatarImageView addTarget:self action:@selector(checkUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, 18, ScreenWidth - avatarImageView.width - 40, 20)];
        nicknameLabel.font = [UIFont systemFontOfSize:14];
        nicknameLabel.text = @"盛夏光年";
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, nicknameLabel.bottom+2, ScreenWidth - avatarImageView.width - 40, 20)];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.text = @"今天 12:23 iPhone6";
        
        [self addSubview:avatarImageView];
        [self addSubview:nicknameLabel];
        [self addSubview:dateLabel];
        
        showVImageView = [[UIImageView alloc]initWithFrame:CGRectMake(avatarImageView.width - 2, avatarImageView.bottom - 15, 15, 15)];
        showVImageView.image = [UIImage imageNamed:@"topic_isv_icon"];
        [self addSubview:showVImageView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, avatarImageView.bottom + 10, ScreenWidth, 0.5)];
        lineView.backgroundColor = CELL_COLOR;
        [self addSubview:lineView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom + 15, ScreenWidth - 20, 30)];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        _titleLabel.text = @"什么情况？一大波残疾车包围了龙感加油站！";
        _titleLabel.textAlignment = NSTextAlignmentCenter; //居中
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)getUserInfoData:(NSDictionary*)data
{
    NSString *date = [data objectForKey:@"date"];
    NSString *avataURL = [data objectForKey:@"avataURL"];
    NSString *nickname = [data objectForKey:@"nickname"];
    [avatarImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:avataURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login"]];
    avatarImageView.user_id = [data objectForKey:@"user_id"];
    avatarImageView.avatarUrl = [data objectForKey:@"avatarImage"];
    avatarImageView.userName = [data objectForKey:@"username"];
    avatarImageView.nickname = nickname;
    
    NSString *isvString = [data objectForKey:@"isv"];
    if ([isvString intValue] == 1) {
        showVImageView.hidden = NO;
    }else{
        showVImageView.hidden = YES;
    }
    
    
    nicknameLabel.text = nickname;
    dateLabel.text = date;
}

- (void)checkUserInfo:(PubliButton *)button
{
    MineInfoViewController *userInfoVC = [[MineInfoViewController alloc]init];
    userInfoVC.user_id = button.user_id;
    userInfoVC.avatarUrl = button.avatarUrl;
    userInfoVC.nickname = button.nickname;
    userInfoVC.userName = button.userName;
    [self.viewController.navigationController pushViewController:userInfoVC animated:YES];
}

@end
