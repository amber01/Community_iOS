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
    UIView              *bottomLine;
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
        lineView.backgroundColor = LINE_COLOR;
        [self addSubview:lineView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, lineView.bottom + 15, ScreenWidth - 40, 30)];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _titleLabel.text = @"什么情况？一大波残疾车包围了龙感加油站！";
        _titleLabel.textAlignment = NSTextAlignmentCenter; //居中
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + 20, 200, 50);
        UIImageView *likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        [likeImageView setImage:[UIImage imageNamed:@"topic_detail_like_high"]];
        [_likeBtn addSubview:likeImageView];
        self.likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(likeImageView.right+3, likeImageView.top, 180, 17)];
        _likeLabel.text = @"2332";
        _likeLabel.font = kFont(13);
        _likeLabel.textColor = TEXT_COLOR2;
        [_likeBtn addSubview:_likeLabel];
        [self addSubview:_likeBtn];
        
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake((ScreenWidth-40)/2, _titleLabel.bottom + 20, 200, 50);
        UIImageView *commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        [commentImageView setImage:[UIImage imageNamed:@"topic_detail_comment_high"]];
        [_commentBtn addSubview:commentImageView];
        self.commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentImageView.right+3, commentImageView.top, 180, 17)];
        _commentLabel.text = @"2332";
        _commentLabel.font = kFont(13);
        _commentLabel.textColor = TEXT_COLOR2;
        [_commentBtn addSubview:_commentLabel];
        [self addSubview:_commentBtn];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(ScreenWidth-50-20, _titleLabel.bottom + 20, 200, 50);
        UIImageView *shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        [shareImageView setImage:[UIImage imageNamed:@"discover_item_shared"]];
        [_shareBtn addSubview:shareImageView];
        self.shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(shareImageView.right+3, shareImageView.top, 180, 17)];
        _shareLabel.text = @"2332";
        _shareLabel.font = kFont(13);
        _shareLabel.textColor = TEXT_COLOR2;
        [_shareBtn addSubview:_shareLabel];
        [self addSubview:_shareBtn];
        
        bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, _shareBtn.bottom + 20+15, ScreenWidth, 0.5)];
        bottomLine.backgroundColor = LINE_COLOR;
        [self addSubview:bottomLine];
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
    _likeLabel.text = [data objectForKey:@"praisenum"];
    _commentLabel.text = [data objectForKey:@"commentnum"];
    _shareLabel.text = [data objectForKey:@"sharenum"];
    
    self.titleLabel.text = [data objectForKey:@"name"];
    CGSize  textSize = [self.titleLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:18] maxSize:CGSizeMake(self.titleLabel.width, 0)];
    self.titleLabel.frame = CGRectMake(20, avatarImageView.bottom + 10 + 15, ScreenWidth - 40, textSize.height);
    _likeBtn.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + 20, 200, 50);
    _commentBtn.frame = CGRectMake((ScreenWidth-40)/2, _titleLabel.bottom + 18, 200, 50);
    _shareBtn.frame = CGRectMake(ScreenWidth-50-20, _titleLabel.bottom + 18, 200, 50);
    bottomLine.frame = CGRectMake(0, _titleLabel.bottom + 20 + 20  + 15, ScreenWidth, 0.5);
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
