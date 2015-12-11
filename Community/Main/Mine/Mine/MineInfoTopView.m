//
//  MineInfoTopView.m
//  Community
//
//  Created by amber on 15/11/30.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MineInfoTopView.h"
#import "ModifyUserInfoViewController.h"
#import "EaseMessageViewController.h"
#import "PubliButton.h"
#import "FansListViewController.h"

@implementation MineInfoTopView
{
    UILabel         *prestigeLabel;
    UILabel         *scoreLabel;
    UIButton        *editUserInfoBtn;
    
    PubliButton     *addFollowBtn;
    PubliButton     *chatBtn;
    
    UILabel         *addFollowLabel;
    BOOL            isToFans;
}

- (instancetype)initWithFrame:(CGRect)frame withUserID:(NSString *)user_id andNickname:(NSString *)nickname andUserName:(NSString *)userName andAvararUrl:(NSString *)avatarUrl;
{
    self = [super initWithFrame:frame];
    if (self) {
        SharedInfo *share = [SharedInfo sharedDataInfo];
        
        self.avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, -15, 60, 60)];
        [UIUtils setupViewRadius:_avatarImageView cornerRadius:_avatarImageView.width/2];
        
        
        self.nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImageView.right + 10, 5, ScreenWidth - _avatarImageView.width + 20 + 10, 20)];
        _nicknameLabel.font = [UIFont systemFontOfSize:15];
        
        _sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_avatarImageView.right + 2, _avatarImageView.bottom - 16,25/2, 28/2)];

        prestigeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_sexImageView.right + 10, _avatarImageView.bottom - 19, 60, 20)];
        prestigeLabel.textColor = TEXT_COLOR;
        prestigeLabel.font = [UIFont systemFontOfSize:12];
        
        
        scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(prestigeLabel.right, prestigeLabel.top, 150, 20)];
        scoreLabel.textColor = TEXT_COLOR;
        scoreLabel.font = [UIFont systemFontOfSize:12];
        
        
        
        _topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicBtn.frame = CGRectMake(0, prestigeLabel.bottom + 15, ScreenWidth/3, 20);
        [CommonClass setBorderWithView:_topicBtn top:NO left:NO bottom:NO right:YES borderColor:LINE_COLOR borderWidth:0.5];
        _topicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_topicBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        
        
        _myFansBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        [_myFansBtn addTarget:self action:@selector(checkMyFansAction:) forControlEvents:UIControlEventTouchUpInside];
        _myFansBtn.user_id = user_id;
        _myFansBtn.frame = CGRectMake(_topicBtn.right, prestigeLabel.bottom + 15, ScreenWidth/3, 20);
        [CommonClass setBorderWithView:_myFansBtn top:NO left:NO bottom:NO right:YES borderColor:LINE_COLOR borderWidth:0.5];
        _myFansBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_myFansBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        
        _followBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        [_followBtn addTarget:self action:@selector(checkFollowAction:) forControlEvents:UIControlEventTouchUpInside];
        _followBtn.user_id = user_id;
        _followBtn.frame = CGRectMake(_myFansBtn.right, prestigeLabel.bottom + 15, ScreenWidth/3, 20);
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_followBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        /**
         *  查看自己的
         */
        if ([share.user_id isEqualToString:user_id]) {
            editUserInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            editUserInfoBtn.frame = CGRectMake(ScreenWidth/2 - (236/2)/2, _followBtn.bottom + 18, 236/2, 75/2);
            [editUserInfoBtn addTarget:self action:@selector(editUserInfoAction) forControlEvents:UIControlEventTouchUpInside];
            [editUserInfoBtn setImage:[UIImage imageNamed:@"mine_user_edit"] forState:UIControlStateNormal];
            UILabel *btnTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, editUserInfoBtn.height/2-10, editUserInfoBtn.width - 20, 20)];
            btnTitleLabel.textColor = [UIColor colorWithHexString:@"#62b312"];
            btnTitleLabel.font = [UIFont systemFontOfSize:14];
            btnTitleLabel.textAlignment = NSTextAlignmentRight;
            btnTitleLabel.text = @"编辑资料";
            [editUserInfoBtn addSubview:btnTitleLabel];
            
            _nicknameLabel.text = share.nickname;
            
            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",share.picturedomain],BASE_IMAGE_URL,face,share.picture]]placeholderImage:[UIImage imageNamed:@"mine_login"]];
            
            if ([share.sex isEqualToString:@"女"]) {
                _sexImageView.image = [UIImage imageNamed:@"user_women"];
            }else{
                _sexImageView.image = [UIImage imageNamed:@"user_man.png"];
            }
            
            prestigeLabel.text = @"威望:V2";
            
            scoreLabel.text = [NSString stringWithFormat:@"积分:%@",share.totalscore];
            
            [_topicBtn setTitle:[NSString stringWithFormat:@"%@帖子",share.postnum] forState:UIControlStateNormal];
            
            [_myFansBtn setTitle:[NSString stringWithFormat:@"%@粉丝",share.myfansnum] forState:UIControlStateNormal];
            
            [_followBtn setTitle:[NSString stringWithFormat:@"%@关注",share.mytofansnum] forState:UIControlStateNormal];
            
        }else{ //查看他人
            addFollowBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
            addFollowBtn.frame = CGRectMake(30, _followBtn.bottom + 18,236/2, 75/2);
            addFollowBtn.user_id = user_id;
            [addFollowBtn addTarget:self action:@selector(addFollowAction:) forControlEvents:UIControlEventTouchUpInside];
            [addFollowBtn setImage:[UIImage imageNamed:@"user_info_addfollow.png"] forState:UIControlStateNormal];
            
            addFollowLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, addFollowBtn.height/2-10, addFollowBtn.width - 50, 20)];
            addFollowLabel.textColor = [UIColor colorWithHexString:@"#62b312"];
            addFollowLabel.font = [UIFont systemFontOfSize:14];
            addFollowLabel.textAlignment = NSTextAlignmentRight;
            addFollowLabel.text = @"关注";
            [addFollowBtn addSubview:addFollowLabel];
            
            //
            chatBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
            chatBtn.frame = CGRectMake((ScreenWidth - 236/2) - 30, _followBtn.bottom + 18,236/2, 75/2);
            chatBtn.user_id = user_id;
            chatBtn.userName = userName;
            chatBtn.nickname = nickname;
            chatBtn.avatarUrl = avatarUrl;
            [chatBtn setImage:[UIImage imageNamed:@"user_info_chat.png"] forState:UIControlStateNormal];
            UILabel *chatLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, chatBtn.height/2-10, chatBtn.width - 50, 20)];
            [chatBtn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
            chatLabel.textColor = [UIColor colorWithHexString:@"#62b312"];
            chatLabel.font = [UIFont systemFontOfSize:14];
            chatLabel.textAlignment = NSTextAlignmentRight;
            chatLabel.text = @"私信";
            [chatBtn addSubview:chatLabel];
            
            [self getUserInfoData:user_id];
            
            [self addSubview:chatBtn];
            [self addSubview:addFollowBtn];
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 136 + 10, ScreenWidth, 10)];
        [CommonClass setBorderWithView:lineView top:YES left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        lineView.backgroundColor = CELL_COLOR;
        
        [self getIsFollowStatusData:user_id];
        
        [self addSubview:lineView];
        [self addSubview:_avatarImageView];
        [self addSubview:_nicknameLabel];
        [self addSubview:prestigeLabel];
        [self addSubview:scoreLabel];
        [self addSubview:_topicBtn];
        [self addSubview:_myFansBtn];
        [self addSubview:_followBtn];
        [self addSubview:editUserInfoBtn];
        [self addSubview:_sexImageView];
    }
    return self;
}

#pragma mark -- action

- (void)editUserInfoAction
{
    ModifyUserInfoViewController *modifyUserVC = [[ModifyUserInfoViewController alloc]init];
    [self.viewController.navigationController pushViewController:modifyUserVC animated:YES];
}

- (void)getIsFollowStatusData:(NSString *)toFansID
{
    /**
     *  需要先调用接口判断一下是否关注过对方
     */
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ReMyFansInfo",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"ToUserID":toFansID,@"IsShow":@"888"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"is resutl:%@",result);
        
        if (result) {
            NSArray *detailArray = [result objectForKey:@"Detail"];
            for (int i = 0; i < detailArray.count; i ++) {
                NSDictionary *dic = [detailArray objectAtIndex:i];
                if ([sharedInfo.user_id intValue] == [[dic objectForKey:@"userid"]intValue]) {
                    isToFans = YES; //已经关注过了
                    [addFollowBtn setImage:[UIImage imageNamed:@"user_info_follow"] forState:UIControlStateNormal];
                    addFollowLabel.text = @"已关注";
                }else{
                    isToFans = NO;  //未关注过
                    [addFollowBtn setImage:[UIImage imageNamed:@"user_info_addfollow.png"] forState:UIControlStateNormal];
                    addFollowLabel.text = @"关注";
                }
            }
        }
    } failure:^(NSError *erro) {
        
    }];
}

- (void)addFollowAction:(PubliButton *)button
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.viewController.navigationController pushViewController:loginVC animated:YES];
    }else{
        [self initMBProgress:@""];
        //关注
        if (isToFans == NO) {
            NSDictionary *params = @{@"Method":@"AddMyFansInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"ToUserID":button.user_id}]};
            [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:params withMethod:@"POST" success:^(id result) {
                if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                    [addFollowBtn setImage:[UIImage imageNamed:@"user_info_follow"] forState:UIControlStateNormal];
                    addFollowLabel.text = @"已关注";
                    [self setMBProgreeHiden:YES];
                    isToFans = YES;
                }
            } failure:^(NSError *erro) {
                
            }];
        }else{ //取消关注
            NSDictionary *params = @{@"Method":@"CancelMyFansInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"ToUserID":button.user_id}]};
            [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:params withMethod:@"POST" success:^(id result) {
                if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                    [addFollowBtn setImage:[UIImage imageNamed:@"user_info_addfollow.png"] forState:UIControlStateNormal];
                    addFollowLabel.text = @"关注";
                    [self setMBProgreeHiden:YES];
                    isToFans = NO;
                }
            } failure:^(NSError *erro) {
                
            }];
        }
    }
}

- (void)chatAction:(PubliButton *)button
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (!isStrEmpty(sharedInfo.user_id)) {
        EaseMessageViewController *easeMessageVC = [[EaseMessageViewController alloc]initWithConversationChatter:button.userName conversationType:eConversationTypeChat];
        easeMessageVC.avatarUrl = button.avatarUrl;
        easeMessageVC.title = button.nickname;
        [self.viewController.navigationController pushViewController:easeMessageVC animated:YES];
    }else{
        LoginViewController *loginVC = [[LoginViewController  alloc]init];
        [self.viewController.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)getUserInfoData:(NSString *)user_id;
{
    NSDictionary *params = @{@"Method":@"ReUserInfo",@"Detail":@[@{@"ID":user_id}]};
    
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
        if (result) {
            NSLog(@"result:%@",result);
            NSArray *dataArray = [result objectForKey:@"Detail"];
            for (int i = 0; i < dataArray.count; i ++) {
                NSDictionary *dic = [dataArray objectAtIndex:i];
                
                [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",[dic objectForKey:@"picturedomain"]],BASE_IMAGE_URL,face,[dic objectForKey:@"picture"]]]placeholderImage:[UIImage imageNamed:@"mine_login"]];
                
                if ([[dic objectForKey:@"sex"] isEqualToString:@"女"]) {
                    _sexImageView.image = [UIImage imageNamed:@"user_women"];
                }else{
                    _sexImageView.image = [UIImage imageNamed:@"user_man.png"];
                }
                
                _nicknameLabel.text = [dic objectForKey:@"nickname"];
                
                _sexImageView.image = [UIImage imageNamed:@"user_women"];
                
                prestigeLabel.text = @"威望:V2";
                
                scoreLabel.text = [NSString stringWithFormat:@"积分:%@",[dic objectForKey:@"totalscore"]];
                
                [_topicBtn setTitle:[NSString stringWithFormat:@"%@帖子",[dic objectForKey:@"postnum"]] forState:UIControlStateNormal];
                
                [_myFansBtn setTitle:[NSString stringWithFormat:@"%@粉丝",[dic objectForKey:@"myfansnum"]] forState:UIControlStateNormal];
                
                [_followBtn setTitle:[NSString stringWithFormat:@"%@关注",[dic objectForKey:@"mytofansnum"]] forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError *erro) {
        
    }];
}

- (void)checkMyFansAction:(PubliButton *)button
{
    FansListViewController *fansVC = [[FansListViewController alloc]init];
    fansVC.title = @"粉丝";
    fansVC.status = @"0";
    fansVC.user_id = button.user_id;
    [self.viewController.navigationController pushViewController:fansVC animated:YES];
}

- (void)checkFollowAction:(PubliButton *)button
{
    FansListViewController *fansVC = [[FansListViewController alloc]init];
    fansVC.title = @"关注";
    fansVC.status = @"1";
    fansVC.user_id = button.user_id;
    [self.viewController.navigationController pushViewController:fansVC animated:YES];
}

- (void)initMBProgress:(NSString *)title
{
    progress = [[MBProgressHUD alloc]initWithView:self];
    progress.labelText = title;
    [self addSubview:progress];
    [progress setMode:MBProgressHUDModeIndeterminate];
    progress.taskInProgress = YES;
    [progress show:YES];
}
- (void)setMBProgreeHiden:(BOOL)isHiden
{
    [progress hide:isHiden];
    if (progress != nil) {
        [progress removeFromSuperview];
    }
}

@end
