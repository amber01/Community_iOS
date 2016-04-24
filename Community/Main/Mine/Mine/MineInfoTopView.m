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
    PubliButton     *addFollowBtn;
    PubliButton     *chatBtn;
    BOOL            isToFans;
}

- (instancetype)initWithFrame:(CGRect)frame withUserID:(NSString *)user_id andNickname:(NSString *)nickname andUserName:(NSString *)userName andAvararUrl:(NSString *)avatarUrl;
{
    self = [super initWithFrame:frame];
    if (self) {
        SharedInfo *share = [SharedInfo sharedDataInfo];
        
        
        /**
         *  查看自己的
         */
        if ([share.user_id isEqualToString:user_id]) {

        }else{ //查看他人
            addFollowBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
            addFollowBtn.frame = CGRectMake(50, 0 ,70, 30);
            addFollowBtn.user_id = user_id;
            [addFollowBtn setBackgroundColor:[UIColor clearColor]];
            [addFollowBtn addTarget:self action:@selector(addFollowAction:) forControlEvents:UIControlEventTouchUpInside];
            [addFollowBtn setImage:[UIImage imageNamed:@"discover_add_follow"] forState:UIControlStateNormal];
            

            chatBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
            chatBtn.frame = CGRectMake(ScreenWidth - 50 - 70, 0 ,70, 30);
            chatBtn.user_id = user_id;
            chatBtn.userName = userName;
            chatBtn.nickname = nickname;
            chatBtn.avatarUrl = avatarUrl;
            [chatBtn setImage:[UIImage imageNamed:@"user_info_chat.png"] forState:UIControlStateNormal];
            [chatBtn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:chatBtn];
            [self addSubview:addFollowBtn];
            
        }
        
        [self getIsFollowStatusData:user_id];
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
    NSDictionary *parameters = @{@"Method":@"ReMyFansInfo",@"Detail":@[@{@"UserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"ToUserID":toFansID,@"IsShow":@"888"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"is resutl:%@",result);
        
        if (result) {
            NSArray *detailArray = [result objectForKey:@"Detail"];
            for (int i = 0; i < detailArray.count; i ++) {
                NSDictionary *dic = [detailArray objectAtIndex:i];
                if ([sharedInfo.user_id intValue] == [[dic objectForKey:@"userid"]intValue]) {
                    isToFans = YES; //已经关注过了
                    [addFollowBtn setImage:[UIImage imageNamed:@"user_info_addfollow"] forState:UIControlStateNormal];
                }else{
                    isToFans = NO;  //未关注过
                    [addFollowBtn setImage:[UIImage imageNamed:@"discover_add_follow"] forState:UIControlStateNormal];
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
                    [addFollowBtn setImage:[UIImage imageNamed:@"user_info_addfollow"] forState:UIControlStateNormal];
                    [self setMBProgreeHiden:YES];
                    isToFans = YES;
                }
            } failure:^(NSError *erro) {
                
            }];
        }else{ //取消关注
            NSDictionary *params = @{@"Method":@"CancelMyFansInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"",@"Detail":@[@{@"UserID":sharedInfo.user_id,@"ToUserID":button.user_id}]};
            [CKHttpRequest createRequest:HTTP_METHOD_FANS WithParam:params withMethod:@"POST" success:^(id result) {
                if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                    [addFollowBtn setImage:[UIImage imageNamed:@"discover_add_follow"] forState:UIControlStateNormal];
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
        easeMessageVC.nickname = button.nickname;
        easeMessageVC.avatarUrl = button.avatarUrl;
        easeMessageVC.title = button.nickname;
        
        NSLog(@"%@,%@,%@",button.userName,button.nickname,button.avatarUrl);
        
        [self.viewController.navigationController pushViewController:easeMessageVC animated:YES];
    }else{
        LoginViewController *loginVC = [[LoginViewController  alloc]init];
        [self.viewController.navigationController pushViewController:loginVC animated:YES];
    }
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
