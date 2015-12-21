//
//  TopicCommentDetailView.m
//  Community
//
//  Created by amber on 15/12/20.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicCommentDetailView.h"
#import "CommentTableViewCell.h"

@implementation TopicCommentDetailView
{
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    UILabel             *replayNicknameLabel;
    UILabel             *contentLabel;
    float               viewHeight;
}

- (instancetype)initWithFrame:(CGRect)frame withPostID:(NSString *)post_id isReawrd:(NSString *)isReawrd
{
    self = [super initWithFrame:frame];
    if (self) {
        self.post_id = post_id;
        self.backgroundColor = [UIColor whiteColor];
        self.sortStr = @"1"; //默认按照最新时间排序
        self.backgroundColor = CELL_COLOR;
        //打赏
        if ([isReawrd intValue] == 2) {
            self.rewardView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 80)];
            _rewardView.backgroundColor = [UIColor whiteColor];
            [CommonClass setBorderWithView:_rewardView top:YES left:NO bottom:YES right:NO borderColor:LINE_COLOR borderWidth:0.5];
            self.rewardBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
            _rewardBtn.frame = CGRectMake(_rewardView.width - 60, 15, 50, 50);
            [_rewardBtn setImage:[UIImage imageNamed:@"topic_detail_reward"] forState:UIControlStateNormal];
            [_rewardView addSubview:_rewardBtn];
            [self addSubview:_rewardView];
        }
        viewHeight = 0;
        [self getCommentListData];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataList) name:kReloadCommentNotification object:nil];
    }
    return self;
}

#pragma makr -- NSNotification
- (void)reloadDataList
{
    [self getCommentListData];
}

#pragma mark -- HTTP
- (void)getCommentListData
{
    NSLog(@"self.post_id:%@",self.post_id);
    
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ReCommentInfobyPostID",@"LoginUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"UserID":isStrEmpty(self.tempUserID) ? @"" : self.tempUserID,@"PageSize":@"5",@"IsShow":@"888",@"PageIndex":@"1",@"Sort":self.sortStr,@"FldSortType":@"1",@"PostID":self.post_id}]};
    
    [CKHttpRequest createRequest:HTTP_METHOD_COMMENT WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        NSArray *items = [CommentModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *praiseItems = [result objectForKey:@"IsPraise"];
        
        for (int i = 0; i < items.count; i ++) {
            CommentModel *model = [items objectAtIndex:i];
            
            self.checkUserInfoBtn = [[PubliButton alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
            [_checkUserInfoBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.logopicturedomain],BASE_IMAGE_URL,face,model.logopicture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];

            [UIUtils setupViewRadius:_checkUserInfoBtn cornerRadius:_checkUserInfoBtn.height/2];
            
            self.commentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.rewardView.bottom + 10, ScreenWidth, 10)];
            
            self.commentView.backgroundColor = [UIColor whiteColor];
            [CommonClass setBorderWithView:_commentView top:YES left:NO bottom:NO right:NO borderColor:LINE_COLOR borderWidth:0.5];
            
            nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_checkUserInfoBtn.right+10, 18, ScreenWidth - _checkUserInfoBtn.width - 40, 20)];
            nicknameLabel.font = [UIFont systemFontOfSize:14];
            nicknameLabel.text = @"盛夏光年";
            
            replayNicknameLabel = [[UILabel   alloc]initWithFrame:CGRectMake(15, _checkUserInfoBtn.bottom + 10, ScreenWidth - 30, 20)];
            replayNicknameLabel.textColor = TEXT_COLOR;
            replayNicknameLabel.font = [UIFont systemFontOfSize:14];
            
            
            dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(_checkUserInfoBtn.right+10, nicknameLabel.bottom+2, ScreenWidth - _checkUserInfoBtn.width - 40, 20)];
            dateLabel.textColor = [UIColor grayColor];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.text = @"今天 12:23 iPhone6";
            
            
            contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _checkUserInfoBtn.bottom + 10, ScreenWidth - 30, 20)];
            [contentLabel verticalUpAlignmentWithText: @"说的方法第三方水电费水电费水电费说的方法第三方第三方第三方的说法是法师打发" maxHeight:10];
            contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            contentLabel.numberOfLines = 0;
            [contentLabel setFont:[UIFont systemFontOfSize:15]];
            
            if ([model.isreplay intValue] == 0) { //未回复的
                contentLabel.text = model.detail;
                nicknameLabel.text = model.nickname;
                replayNicknameLabel.hidden = YES;
                nicknameLabel.textColor = [UIColor blackColor];
            }else{ //已回复的
                replayNicknameLabel.hidden = NO;
                //replaycontent
                replayNicknameLabel.frame = CGRectMake(10, _checkUserInfoBtn.bottom + 10, ScreenWidth - 30, 20);
                replayNicknameLabel.text = [NSString stringWithFormat:@"@%@:",model.tonickname];;
                nicknameLabel.text = [NSString stringWithFormat:@"%@(楼主)",model.nickname];
                contentLabel.text = model.replaycontent;
                nicknameLabel.textColor = [UIColor orangeColor];
            }
            
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
            CGSize contentHeight = [contentLabel.text boundingRectWithSize:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            NSLog(@"contentHeight:%f",contentHeight.height);
            
            float height = 45 + 10 + contentHeight.height + 20;
            if (i == 0) {
                viewHeight = 0;
            }else{
                viewHeight = height + viewHeight ;
            }
            
            
            
            self.commentView.frame = CGRectMake(0, (self.rewardView.bottom + 10)+viewHeight, ScreenWidth, 45 + 10 + contentHeight.height + 20);
            
            if (contentLabel.text.length == 0) {
                contentHeight.height = 0;
            }
            
            
            
            if ([model.isreplay intValue] == 0) {
                //NSLog(@"contentHeight1:%f",contentHeight.height);
                contentLabel.frame = CGRectMake(15, _checkUserInfoBtn.bottom + 10, ScreenWidth - 30, contentHeight.height);
//                
//                self.commentView.frame = CGRectMake(0, (self.rewardView.bottom + 10) + i * (45 + 10 + contentHeight.height + 20), ScreenWidth, (45 + 10 + contentHeight.height + 20));
//                if (i == items.count - 1) {
//                    self.commentView.frame = CGRectMake(0, (self.rewardView.bottom + 10) + i * (45 + 10 + contentHeight.height + 20), ScreenWidth, (45 + 10 + contentHeight.height + 20));
//                }
//                
                NSLog(@"commetv y %f",self.commentView.origin.y);
                NSLog(@"comment height:%f",self.commentView.height);
                
            }else{
                contentLabel.frame = CGRectMake(15, _checkUserInfoBtn.bottom + 10 + 20, ScreenWidth - 30, contentLabel.height);
                
                self.commentView.frame = CGRectMake(0, (self.rewardView.bottom + 10) + (i*(_checkUserInfoBtn.height + 10 + contentLabel.height + 10 + 10 + 20 + 10)), ScreenWidth, _checkUserInfoBtn.height + 10 + contentLabel.height + 10 + 10 + 20 + 10 + 10 );
            }
            
            
            
            [_commentView addSubview:replayNicknameLabel];
            [_commentView addSubview:nicknameLabel];
            [_commentView addSubview:dateLabel];
            [_commentView addSubview:contentLabel];
            [_commentView addSubview:_checkUserInfoBtn];
            [self addSubview:_commentView];
        }
        
        
        for (int i = 0; i < praiseItems.count; i ++) {
            if (!self.praiseDataArray) {
                self.praiseDataArray = [[NSMutableArray alloc]init];
            }
            [self.praiseDataArray addObject:[praiseItems objectAtIndex:i]];
        }
        
    } failure:^(NSError *erro) {
        
    }];
}
#pragma mark -- action
- (void)likeAction:(PubliButton *)button
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        LoginViewController *loginVC = [[LoginViewController  alloc]init];
        [loginVC setHidesBottomBarWhenPushed:YES];
        [self.viewController.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    
    //点赞
    if ([button.isPraise intValue] == 0) {
        NSDictionary *parameters = @{@"Method":@"AddCommentToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"CommentID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_COMMENT_LIKE WithParam:parameters withMethod:@"POST" success:^(id result) {
            
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self initMBProgress:@"点赞+1" withModeType:MBProgressHUDModeText afterDelay:1.5];
                int praisenum = [button.praisenum intValue];
                praisenum = praisenum + 1;
                
                //cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
                
            }else{
                [self initMBProgress:@"你已经赞过了" withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }else{  //取消点赞
        NSDictionary *parameters = @{@"Method":@"DelCommentToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"CommentID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_COMMENT_LIKE WithParam:parameters withMethod:@"POST" success:^(id result) {
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self initMBProgress:@"取消点赞" withModeType:MBProgressHUDModeText afterDelay:1.5];
                int praisenum = [button.praisenum intValue];
                praisenum = praisenum - 1;
                
                /**
                 *  先删除原来的点赞数，然后再重新加上
                 */
                [self.likeDataArray removeObjectAtIndex:button.row];
                [self.likeDataArray insertObject:[NSString stringWithFormat:@"%d",praisenum] atIndex:button.row];
                
                /**
                 *  记录点赞状态
                 */
                [self.praiseDataArray removeObjectAtIndex:button.row];
                [self.praiseDataArray insertObject:@{@"commentid":button.post_id,@"value":@"0"} atIndex:button.row];
                
                //点赞之后改变点赞的状态
                
                //cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
                
            }else{
                [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }
}


- (void)initMBProgress:(NSString *)title withModeType:(MBProgressHUDMode)type afterDelay:(NSTimeInterval)delay
{
    progress = [[MBProgressHUD alloc]initWithView:self];
    progress.labelText = title;
    [self addSubview:progress];
    [progress setMode:type];   //MBProgressHUDModeIndeterminate
    progress.taskInProgress = YES;
    [progress show:YES];
    
    progress.yOffset = - 49.0f;
    [progress hide:YES afterDelay:delay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
