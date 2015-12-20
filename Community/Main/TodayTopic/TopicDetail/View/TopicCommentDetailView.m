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
            if (!self.dataArray) {
                self.dataArray = [[NSMutableArray alloc]init];
            }
            [self.dataArray addObject:[items objectAtIndex:i]];
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
