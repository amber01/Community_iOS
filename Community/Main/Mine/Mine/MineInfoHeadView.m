//
//  MineInfoHeadView.m
//  Community
//
//  Created by amber on 16/4/24.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "MineInfoHeadView.h"
#import "ModifyUserInfoViewController.h"
#import "EaseMessageViewController.h"
#import "PubliButton.h"
#import "FansListViewController.h"

@implementation MineInfoHeadView
{
    UILabel         *scoreLabel;
    UILabel         *addFollowLabel;
    
    UILabel         *postsNumLabel;
    UILabel         *postsTitleLabel;
    UILabel         *fansNumLabel;
    UILabel         *fansTitleLabel;
    UILabel         *followNumLabel;
    UILabel         *followTitleLabel;
    UILabel         *scoreNumLabel;
    UILabel         *scoreTitleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame withUserID:(NSString *)user_id andNickname:(NSString *)nickname andUserName:(NSString *)userName andAvararUrl:(NSString *)avatarUrl;
{
    self = [super initWithFrame:frame];
    if (self) {
        SharedInfo *share = [SharedInfo sharedDataInfo];

        _topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicBtn.frame = CGRectMake(0, 8, ScreenWidth/4, (frame.size.height - 10) - 16);
        [CommonClass setBorderWithView:_topicBtn top:NO left:NO bottom:NO right:YES borderColor:[UIColor grayColor] borderWidth:0.5];
        _topicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_topicBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        
        _myFansBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        [_myFansBtn addTarget:self action:@selector(checkMyFansAction:) forControlEvents:UIControlEventTouchUpInside];
        _myFansBtn.user_id = user_id;
        _myFansBtn.frame = CGRectMake(_topicBtn.right, _topicBtn.top, ScreenWidth/4, (frame.size.height - 10) - 16);
        _myFansBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [CommonClass setBorderWithView:_myFansBtn top:NO left:NO bottom:NO right:YES borderColor:[UIColor grayColor] borderWidth:0.5];
        [_myFansBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        
        _followBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        [_followBtn addTarget:self action:@selector(checkFollowAction:) forControlEvents:UIControlEventTouchUpInside];
        _followBtn.user_id = user_id;
        _followBtn.frame = CGRectMake(_myFansBtn.right, _myFansBtn.top, ScreenWidth/4, (frame.size.height - 10) - 16);
        [CommonClass setBorderWithView:_followBtn top:NO left:NO bottom:NO right:YES borderColor:[UIColor grayColor] borderWidth:0.5];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_followBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        self.scoreBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        _scoreBtn.frame = CGRectMake(_followBtn.right, _followBtn.top, ScreenWidth/4, (frame.size.height - 10) - 16);
        _scoreBtn.titleLabel.font = kFont(14);
        [_scoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        
        postsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, _myFansBtn.width, 16)];
        postsNumLabel.text = @"144";
        postsNumLabel.font = kFont(18);
        postsNumLabel.textAlignment = NSTextAlignmentCenter;
        [_topicBtn addSubview:postsNumLabel];
        
        postsTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, postsNumLabel.bottom + 7, _myFansBtn.width, 16)];
        postsTitleLabel.textColor = TEXT_COLOR1;
        postsTitleLabel.font = kFont(14);
        postsTitleLabel.text = @"帖子";
        postsTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_topicBtn addSubview:postsTitleLabel];
        
        fansNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, _myFansBtn.width, 16)];
        fansNumLabel.text = @"144";
        fansNumLabel.font = kFont(18);
        fansNumLabel.textAlignment = NSTextAlignmentCenter;
        [_myFansBtn addSubview:fansNumLabel];
        
        fansTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, postsNumLabel.bottom + 7, _myFansBtn.width, 16)];
        fansTitleLabel.textColor = TEXT_COLOR1;
        fansTitleLabel.font = kFont(14);
        fansTitleLabel.text = @"粉丝";
        fansTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_myFansBtn addSubview:fansTitleLabel];

        followNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, _myFansBtn.width, 16)];
        followNumLabel.text = @"144";
        followNumLabel.font = kFont(18);
        followNumLabel.textAlignment = NSTextAlignmentCenter;
        [_followBtn addSubview:followNumLabel];
        
        followTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, postsNumLabel.bottom + 7, _myFansBtn.width, 16)];
        followTitleLabel.textColor = TEXT_COLOR1;
        followTitleLabel.font = kFont(14);
        followTitleLabel.text = @"关注";
        followTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_followBtn addSubview:followTitleLabel];

        scoreNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, _myFansBtn.width, 16)];
        scoreNumLabel.text = @"144";
        scoreNumLabel.font = kFont(18);
        scoreNumLabel.textAlignment = NSTextAlignmentCenter;
        [_scoreBtn addSubview:scoreNumLabel];
        
        scoreTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, postsNumLabel.bottom + 7, _myFansBtn.width, 16)];
        scoreTitleLabel.textColor = TEXT_COLOR1;
        scoreTitleLabel.font = kFont(14);
        scoreTitleLabel.text = @"积分";
        scoreTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_scoreBtn addSubview:scoreTitleLabel];

        
        /**
         *  查看自己的
         */
        if ([share.user_id isEqualToString:user_id]) {
        
            postsNumLabel.text = share.postnum;
            fansNumLabel.text = share.myfansnum;
            followNumLabel.text = share.mytofansnum;
            scoreNumLabel.text = share.totalscore;
            
        }else{ //查看他人
            [self getUserInfoData:user_id];
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 10, ScreenWidth, 10)];
        [CommonClass setBorderWithView:lineView top:YES left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
        lineView.backgroundColor = CELL_COLOR;
        
        [self addSubview:lineView];
        [self addSubview:_scoreBtn];
        [self addSubview:_topicBtn];
        [self addSubview:_myFansBtn];
        [self addSubview:_followBtn];
    }
    return self;
}

#pragma mark -- action

/**
 *  编辑资料
 */
- (void)editUserInfoAction
{
    ModifyUserInfoViewController *modifyUserVC = [[ModifyUserInfoViewController alloc]init];
    [self.viewController.navigationController pushViewController:modifyUserVC animated:YES];
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

                
                postsNumLabel.text = [dic objectForKey:@"postnum"];
                fansNumLabel.text = [dic objectForKey:@"mytofansnum"];
                followNumLabel.text = [dic objectForKey:@"mytofansnum"];
                scoreNumLabel.text = [dic objectForKey:@"totalscore"];

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
