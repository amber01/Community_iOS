//
//  TopicCommentDetailView.m
//  Community
//
//  Created by amber on 15/12/20.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicCommentDetailView.h"
#import "CommentTableViewCell.h"
#import "MineInfoViewController.h"
#import "TopicDetailRewardViewController.h"
#import "InputBuyNumberView.h"
#import "WriteCommentViewController.h"

@implementation TopicCommentDetailView
{
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    UILabel             *replayNicknameLabel;
    UILabel             *contentLabel;
    float               viewHeight;
    PubliButton         *avatarBtn;
    UIButton            *checkMoreBtn;
    UILabel             *tipsLabel;
    UILabel             *label;
    InputBuyNumberView  *inputBuyNumberView;
    UIImageView         *showVImageView;
}

- (instancetype)initWithFrame:(CGRect)frame withPostID:(NSString *)post_id isReawrd:(NSString *)isReawrd withUserID:(NSString *)to_user_id
{
    self = [super initWithFrame:frame];
    if (self) {
        self.post_id = post_id;
        self.userID = to_user_id;
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
            [_rewardBtn addTarget:self action:@selector(rewardAction) forControlEvents:UIControlEventTouchUpInside];
            [_rewardBtn setImage:[UIImage imageNamed:@"topic_detail_reward"] forState:UIControlStateNormal];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(_rewardBtn.left - 10, 20, 0.5, _rewardView.height - 40)];
            lineView.backgroundColor = LINE_COLOR;
            [_rewardView addSubview:lineView];
            [_rewardView addSubview:_rewardBtn];
            [self addSubview:_rewardView];
        }
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.rewardView.bottom + 10, ScreenWidth, frame.size.height - self.rewardView.height - 10) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        [UIUtils setExtraCellLineHidden:_tableView];
        _tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableView];
        
        [self getCommentListData];
        [self getRewardData];
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
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ReCommentInfobyPostID",@"LoginUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"UserID":isStrEmpty(self.tempUserID) ? @"" : self.tempUserID,@"PageSize":@"5",@"IsShow":@"888",@"PageIndex":@"1",@"Sort":self.sortStr,@"FldSortType":@"1",@"PostID":self.post_id}]};
    
    [CKHttpRequest createRequest:HTTP_METHOD_COMMENT WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        NSArray *items = [CommentModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *tempArr = [result objectForKey:@"Detail"];
        
        for (int i = 0; i < items.count; i ++) {
            if (!self.dataArray) {
                self.dataArray = [[NSMutableArray alloc]init];
            }
            [self.dataArray addObject:[items objectAtIndex:i]];
        }
        
        for (int i = 0; i < tempArr.count; i ++) {
            if (!self.praiseDataArray) {
                self.praiseDataArray = [[NSMutableArray alloc]init];
            }
            NSDictionary *dic = tempArr[i];
            [_praiseDataArray insertObject:[dic objectForKey:@"ispraise"] atIndex:i];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *erro) {
        
    }];
}

- (void)getRewardData
{
    if (avatarBtn) {
        [avatarBtn removeFromSuperview];
        [label removeFromSuperview];
        [checkMoreBtn removeFromSuperview];
    }
    
    NSDictionary *parameters = @{@"Method":@"ReUserScoreLogInfo",@"Detail":@[@{@"Descrip":@"打赏",@"PostID":self.post_id,@"IsShow":@"888"}]};
    [CKHttpRequest  createRequest:HTTP_METHOD_SCORE_INFO WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if (result) {
            if ([[result objectForKey:@"Number"]intValue] == 0) {
                tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, _rewardView.height/2-10, _rewardView.width - 40 - 40, 20)];
                tipsLabel.textColor = [UIColor grayColor];
                tipsLabel.font = [UIFont systemFontOfSize:19];
                tipsLabel.text = @"好贴就是要任性打赏~";
                [_rewardView addSubview:tipsLabel];
            }else{
                label = [[UILabel  alloc]initWithFrame:CGRectMake(10, 10, _rewardView.width - 10 - 16, 20)];
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = [UIColor grayColor];
                NSString *content = [NSString stringWithFormat:@"%@ 人共打赏 %@ 积分",[result objectForKey:@"Number"],[result objectForKey:@"ScoreCount"]];
                label.text = content;
                [UIUtils setRichNumberWithLabel:label Color:[UIColor orangeColor] FontSize:14];
                [_rewardView addSubview:label];
                
                NSArray  *rewardData = [result objectForKey:@"Detail"];
                int btnCount = ((ScreenWidth - 10 - 50 - 10 - 10 - 10)/(34 + 5) - 2);
                NSLog(@"btnCount:%d",btnCount);
                
                for (int i = 0; i < rewardData.count; i ++) {
                    if (i <= btnCount) {
                        NSDictionary *dic = [rewardData objectAtIndex:i];
                        NSLog(@"dicccc:%@",dic);
                        
                        NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",[dic objectForKey:@"logopicturedomain"]],BASE_IMAGE_URL,face,[dic objectForKey:@"logopicture"]];
                        avatarBtn = [[PubliButton alloc]initWithFrame:CGRectMake(10+(((34 + 5) * i)), 30, 34, 34)];
                        showVImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 19, 11, 11)];
                        showVImageView.image = [UIImage imageNamed:@"topic_isv_icon"];
                        
                        [avatarBtn setUser_id:[dic objectForKey:@"userid"]];
                        avatarBtn.nickname = [dic objectForKey:@"nickname"];
                        avatarBtn.userName = [dic objectForKey:@"username"];
                        avatarBtn.avatarUrl = [dic objectForKey:@"logopicture"];
                        NSString *isvString = [dic objectForKey:@"isv"];
                        [avatarBtn addTarget:self action:@selector(checkUserInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [UIUtils setupViewRadius:avatarBtn cornerRadius:avatarBtn.height/2];
                        [avatarBtn sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
                        [_rewardView addSubview:avatarBtn];
                        
                        if ([isvString intValue] == 1) {
                            [avatarBtn addSubview:showVImageView];
                        }
                    }
                }
                checkMoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(avatarBtn.right + 5, 30, 34, 34)];
                [checkMoreBtn addTarget:self action:@selector(checkMoreAction) forControlEvents:UIControlEventTouchUpInside];
                [checkMoreBtn setImage:[UIImage imageNamed:@"topic_reward_more.png"] forState:UIControlStateNormal];
                [_rewardView addSubview:checkMoreBtn];
            }
        }
    } failure:^(NSError *erro) {
        
    }];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        [cell.likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CommentModel *model = self.dataArray[indexPath.row];
    
    if (!_likeDataArray) {
        self.likeDataArray = [[NSMutableArray alloc]init];
    }
    
    [_likeDataArray addObject:model.praisenum];
    
    if (!isArrEmpty(self.dataArray)) {
        [cell configureCellWithInfo:model withRow:indexPath.row andPraiseData:self.praiseDataArray withMasterID:self.userID];
    }
    
    cell.likeBtn.post_id = model.id;
    cell.likeBtn.isPraise = _praiseDataArray[indexPath.row];
    
    cell.likeBtn.row = indexPath.row;
    cell.likeLabel.text = _likeDataArray[indexPath.row];
    cell.likeBtn.praisenum = _likeDataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIActionSheet  *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"帖子点赞",@"回复评论", nil];
    actionSheet.tag = indexPath.row;
    actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
    [actionSheet showInView:self];
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
        NSLog(@"post id:%@",button.post_id);
        
        NSDictionary *parameters = @{@"Method":@"AddCommentToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"CommentID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_COMMENT_LIKE WithParam:parameters withMethod:@"POST" success:^(id result) {
            
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self initMBProgress:@"点赞+1" withModeType:MBProgressHUDModeText afterDelay:1.5];
                int praisenum = [button.praisenum intValue];
                praisenum = praisenum + 1;
                
                /**
                 *  先删除原来的点赞数，然后再重新加上
                 */
                [self.likeDataArray removeObjectAtIndex:button.row];
                [self.likeDataArray insertObject:[NSString stringWithFormat:@"%d",praisenum] atIndex:button.row];
                /**
                 *  记录点赞状态
                 */
                [self.praiseDataArray removeObjectAtIndex:button.row];
                [self.praiseDataArray insertObject:@"1" atIndex:button.row];
                
                //点赞之后改变点赞的状态
                NSIndexPath *index =  [NSIndexPath indexPathForItem:button.row inSection:0];
                CommentTableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
                cell.likeLabel.text = _likeDataArray[button.row];
                
                cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
                [_tableView reloadData];
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
                [self.praiseDataArray insertObject:@"0" atIndex:button.row];
                
                
                //点赞之后改变点赞的状态
                NSIndexPath *index =  [NSIndexPath indexPathForItem:button.row inSection:0];
                CommentTableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
                cell.likeLabel.text = _likeDataArray[button.row];
                
                cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
                
                [_tableView reloadData];
            }else{
                [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }
}

/**
 *  打赏
 */
- (void)rewardAction
{
    UIActionSheet  *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择打赏金额" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"5积分",@"20积分",@"任意赏", nil];
    actionSheet.tag = 2000;
    actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
    [actionSheet showInView:self];
}

- (void)checkMoreAction
{
    TopicDetailRewardViewController *topicDetailReawrdVC = [[TopicDetailRewardViewController alloc]init];
    topicDetailReawrdVC.post_id = self.post_id;
    [self.viewController.navigationController pushViewController:topicDetailReawrdVC animated:YES];
}

- (void)checkUserInfoBtn:(PubliButton *)button
{
    MineInfoViewController *mineInfoVC = [[MineInfoViewController alloc]init];
    mineInfoVC.user_id = button.user_id;
    mineInfoVC.nickname = button.nickname;
    mineInfoVC.userName = button.userName;
    mineInfoVC.avatarUrl = button.avatarUrl;
    [self.viewController.navigationController pushViewController:mineInfoVC animated:YES];
}

- (void)cancelAction
{
    inputBuyNumberView.hidden = YES;
}

- (void)returnAction
{
    SharedInfo   *share = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"AddUserScoreLogInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":share.user_id,@"Detail":@[@{@"Descrip":@"打赏",@"UserID":share.user_id,@"ToUserID":isStrEmpty(self.userID) ? @"" : self.userID,@"Score":inputBuyNumberView.scoreNumLabel.text,@"PostID":self.post_id,@"IsShow":@"1"}]};
    [CKHttpRequest  createRequest:HTTP_METHOD_SCORE_INFO WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if ([[result objectForKey:@"Success"]intValue] > 0) {
            [self initMBProgress:@"打赏成功" withModeType:MBProgressHUDModeText afterDelay:1.0];
            inputBuyNumberView.hidden = YES;
            tipsLabel.hidden = YES;
            int currentScore = [share.totalscore intValue] - [inputBuyNumberView.scoreNumLabel.text intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",currentScore] forKey:@"totalscore"];
            
            share.totalscore = [NSString stringWithFormat:@"%d",currentScore];
            [self getRewardData];
        }else{
            [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.0];
        }
    } failure:^(NSError *erro) {
        
    }];

}

- (void)updateValue:(UISlider *)slider
{
    inputBuyNumberView.scoreNumLabel.text = [NSString stringWithFormat:@"%d",(int)slider.value];
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SharedInfo *share = [SharedInfo sharedDataInfo];
    if (actionSheet.tag == 2000) {
        
        NSString  *scoreStr;
        if (buttonIndex != 3) {
            if (isStrEmpty(share.user_id)) {
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [self.viewController.navigationController pushViewController:loginVC animated:YES];
                return;
            }else{
                if (buttonIndex == 0) {
                    scoreStr = @"5";
                }else if (buttonIndex == 1){
                    scoreStr = @"20";
                } if (buttonIndex == 2){
                    if (!inputBuyNumberView) {
                        inputBuyNumberView = [[InputBuyNumberView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                        [inputBuyNumberView.returnBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
                        [inputBuyNumberView.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
                        [inputBuyNumberView.mySlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
                        inputBuyNumberView.userInteractionEnabled = YES;
                        [self.window addSubview:inputBuyNumberView];
                    }
                    
                    inputBuyNumberView.rightLabel.text = share.totalscore;
                    inputBuyNumberView.myScoreNumLabel.text = [NSString stringWithFormat:@"我的积分：%@",share.totalscore];
                    inputBuyNumberView.mySlider.maximumValue = [share.totalscore intValue];
                    inputBuyNumberView.mySlider.value = [share.totalscore intValue]/2;
                    inputBuyNumberView.scoreNumLabel.text = [NSString stringWithFormat:@"%d",[share.totalscore intValue]/2];
                    inputBuyNumberView.hidden = NO;
                }
                
                if (!isStrEmpty(scoreStr)) {
                    NSDictionary *parameters = @{@"Method":@"AddUserScoreLogInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":share.user_id,@"Detail":@[@{@"Descrip":@"打赏",@"UserID":share.user_id,@"ToUserID":isStrEmpty(self.userID) ? @"" : self.userID,@"Score":scoreStr,@"PostID":self.post_id,@"IsShow":@"1"}]};
                    [CKHttpRequest  createRequest:HTTP_METHOD_SCORE_INFO WithParam:parameters withMethod:@"POST" success:^(id result) {
                        NSLog(@"result:%@",result);
                        if ([[result objectForKey:@"Success"]intValue] > 0) {
                            [self initMBProgress:@"打赏成功" withModeType:MBProgressHUDModeText afterDelay:1.0];
                            tipsLabel.hidden = YES;
                            
                            int currentScore = [share.totalscore intValue] - [scoreStr intValue];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",currentScore] forKey:@"totalscore"];
                            share.totalscore = [NSString stringWithFormat:@"%d",currentScore];
                            
                            [self getRewardData];
                        }else{
                            [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.0];
                        }
                    } failure:^(NSError *erro) {
                        
                    }];
                }
            }
        }
    }else{
        if (isStrEmpty(share.user_id)) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.viewController.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        if (buttonIndex == 0) {
            NSString *isPraise = [self.praiseDataArray objectAtIndex:actionSheet.tag];
            CommentModel *model = self.dataArray[actionSheet.tag];
            NSString     *post_id = model.id;
            
            SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
            if (isStrEmpty(sharedInfo.user_id)) {
                LoginViewController *loginVC = [[LoginViewController  alloc]init];
                [loginVC setHidesBottomBarWhenPushed:YES];
                [self.viewController.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            
            //点赞
            if ([isPraise intValue] == 0) {
                
                NSDictionary *parameters = @{@"Method":@"AddCommentToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"CommentID":post_id,@"UserID":sharedInfo.user_id}]};
                
                [CKHttpRequest createRequest:HTTP_METHOD_COMMENT_LIKE WithParam:parameters withMethod:@"POST" success:^(id result) {
                    
                    if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                        [self initMBProgress:@"点赞+1" withModeType:MBProgressHUDModeText afterDelay:1.5];
                        int praisenum = [_likeDataArray[actionSheet.tag]intValue];
                        praisenum = praisenum + 1;
                        
                        /**
                         *  先删除原来的点赞数，然后再重新加上
                         */
                        [self.likeDataArray removeObjectAtIndex:actionSheet.tag];
                        [self.likeDataArray insertObject:[NSString stringWithFormat:@"%d",praisenum] atIndex:actionSheet.tag];
                        /**
                         *  记录点赞状态
                         */
                        [self.praiseDataArray removeObjectAtIndex:actionSheet.tag];
                        [self.praiseDataArray insertObject:@"1" atIndex:actionSheet.tag];
                        
                        //点赞之后改变点赞的状态
                        NSIndexPath *index =  [NSIndexPath indexPathForItem:actionSheet.tag inSection:0];
                        CommentTableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
                        cell.likeLabel.text = _likeDataArray[actionSheet.tag];
                        
                        cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
                        [_tableView reloadData];
                    }else{
                        [self initMBProgress:@"你已经赞过了" withModeType:MBProgressHUDModeText afterDelay:1.5];
                    }
                    
                } failure:^(NSError *erro) {
                    
                }];
            }else{  //取消点赞
                NSDictionary *parameters = @{@"Method":@"DelCommentToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"CommentID":post_id,@"UserID":sharedInfo.user_id}]};
                
                [CKHttpRequest createRequest:HTTP_METHOD_COMMENT_LIKE WithParam:parameters withMethod:@"POST" success:^(id result) {
                    if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                        [self initMBProgress:@"取消点赞" withModeType:MBProgressHUDModeText afterDelay:1.5];
                        int praisenum = [_likeDataArray[actionSheet.tag]intValue];
                        praisenum = praisenum - 1;
                        
                        /**
                         *  先删除原来的点赞数，然后再重新加上
                         */
                        [self.likeDataArray removeObjectAtIndex:actionSheet.tag];
                        [self.likeDataArray insertObject:[NSString stringWithFormat:@"%d",praisenum] atIndex:actionSheet.tag];
                        
                        /**
                         *  记录点赞状态
                         */
                        [self.praiseDataArray removeObjectAtIndex:actionSheet.tag];
                        [self.praiseDataArray insertObject:@"0" atIndex:actionSheet.tag];
                        
                        
                        //点赞之后改变点赞的状态
                        NSIndexPath *index =  [NSIndexPath indexPathForItem:actionSheet.tag inSection:0];
                        CommentTableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
                        cell.likeLabel.text = _likeDataArray[actionSheet.tag];
                        
                        cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
                        
                        [_tableView reloadData];
                    }else{
                        [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
                    }
                    
                } failure:^(NSError *erro) {
                    
                }];
            }
        }else if (buttonIndex == 1){
            if (isStrEmpty(share.user_id)) {
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [self.viewController.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            CommentModel *model = self.dataArray[actionSheet.tag];
            WriteCommentViewController *writeCommentVC = [[WriteCommentViewController alloc]init];
            writeCommentVC.post_id = model.postid;
            writeCommentVC.toUserID = model.touserid;
            writeCommentVC.commentID = model.id;
            BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:writeCommentVC];
            [self.viewController.navigationController presentViewController:baseNav animated:YES completion:^{
                
            }];
        }
    }
}


#pragma mark -- other
- (void)initMBProgress:(NSString *)title withModeType:(MBProgressHUDMode)type afterDelay:(NSTimeInterval)delay
{
    progress = [[MBProgressHUD alloc]initWithView:self];
    progress.labelText = title;
    [self.window addSubview:progress];
    [progress setMode:type];   //MBProgressHUDModeIndeterminate
    progress.taskInProgress = YES;
    [progress show:YES];
    
    progress.yOffset = - 49.0f;
    [progress hide:YES afterDelay:delay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [inputBuyNumberView removeFromSuperview];
}

@end
