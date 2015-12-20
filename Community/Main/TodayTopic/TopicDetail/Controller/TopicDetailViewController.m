//
//  TopicDetailViewController.m
//  Community
//
//  Created by amber on 15/11/27.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "TopicDetailFootView.h"
#import "TopicDetailHeadView.h"
#import "ScorellButtonView.h"
#import "GoodsLoadMoreTopView.h"
#import "WriteCommentViewController.h"
#import "TWebView.h"
#import "CommentViewController.h"
#import "GoodsLoadMoreFootView.h"
#import "TopicCommentDetailView.h"

@interface TopicDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate,TWebScrollViewDelegate,CheckMoreDelegate,UIActionSheetDelegate>
{
    ScorellButtonView    *scorllBtnView;
    TopicDetailHeadView  *headView;
    TopicDetailFootView  *footView;
    GoodsLoadMoreTopView *loadMoreTopView;
    BOOL                 isLike;
    BOOL                 isLoadMore;
    BOOL                 isLoadTopMore;
    BOOL                 isTextZoom;
    TWebView             *detailWebView;
    
    UIView               *loadingView;
    UIView               *footBackgroundView;
}

@property (nonatomic,retain) UIScrollView      *myScrollView;
@property (nonatomic,retain) ScorellButtonView *scorllBtnView;
@property (nonatomic,copy  ) NSString          *likeNumber;

@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createScrollView];
    
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    loadingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loadingView];
    
    isLoadMore = NO;
    isLoadTopMore = YES;
    
    footView = [[TopicDetailFootView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 42, ScreenWidth, 42)];
    [footView.writeCommentBtn addTarget:self action:@selector(writeCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [footView.likeBtn addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    [footView.checkCommentBtn addTarget:self action:@selector(checkCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footView];
    [self getTopicDetail:self.post_id];
    
    CustomButtonItem *buttonItem = [[CustomButtonItem alloc]initButtonItem:[UIImage imageNamed:@"topic_detail_more"]];
    [buttonItem.itemBtn addTarget:self action:@selector(checkMoreAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    footBackgroundView = [[UIView alloc]init];
}

#pragma makr -- UI
- (void)createScrollView
{
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 42)];
    self.myScrollView.backgroundColor = [UIColor whiteColor];
    self.myScrollView.delegate = self;
    self.myScrollView.hidden = YES;
    [self.view addSubview:self.myScrollView];
    
    
    [self createWebView];
}

- (void)createWebView
{
    detailWebView = [[TWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 42 - 64) withPost:self.post_id];
    detailWebView.delegate = self;
    detailWebView.scorollDelegate = self;
    headView = [[TopicDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenHeight, 65)];
    [self.myScrollView addSubview:detailWebView];
    
    
    /**
     *  再UIWebView的头视图上添加一个自定义View
     */
    detailWebView.headerView = headView;
    
    [self createdFootMoreView];
}

- (void)createdFootMoreView
{
    scorllBtnView = [[ScorellButtonView alloc]initWithFrame:CGRectMake(0, detailWebView.bottom, ScreenWidth, ScreenHeight) withPostID:self.post_id];
    [scorllBtnView.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    loadMoreTopView = [[GoodsLoadMoreTopView alloc]initWithFrame:CGRectMake(0, -64, ScreenWidth, 64)];
    [scorllBtnView.tableView addSubview:loadMoreTopView];
    scorllBtnView.delegate = self;
    scorllBtnView.userID = self.user_id;
    [self.myScrollView addSubview:scorllBtnView];
    
}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    loadingView.hidden = YES;
    int isZoom = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isZoom"]intValue];
    if (isZoom == 1) {
        NSString *str1 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '%f%%'",120.0];
        [webView stringByEvaluatingJavaScriptFromString:str1];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
}

- (void)delayMethod
{
    self.myScrollView.hidden = NO;
}

#pragma mark -- TWebScrollViewDelegate
- (void)currentScorollDidEndDragging:(UIScrollView *)scrollView{
    
    float offset = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float sub = contentHeight-offset;
    
    if (isLoadTopMore == YES) {
        if (scrollView.height - sub > 40) {
            isLoadTopMore = NO;
            isLoadMore = NO;
            [self scrollViewByPageControlPage:1];
        }
    }
}

#pragma mark -- CheckMoreDelegate
- (void)checkMoreScorollDidEndDragging:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.y;
    if (isLoadMore == YES && isLoadTopMore == NO) {
        if (offset < -55) {
            isLoadTopMore = YES;
            [self scrollViewByPageControlPage:0];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (isLoadMore == YES && isLoadTopMore == NO) {
        CGFloat offset = scorllBtnView.tableView.contentOffset.y;
        if (offset <= -55) {
            loadMoreTopView.pullTextLabe.text = @"松开返回帖子";
            
            CGAffineTransform rotate = CGAffineTransformMakeRotation( 1.0 / 180.0 * 3.14 );
            [UIView animateWithDuration:0.2 animations:^{
                [loadMoreTopView.pulldownView setTransform:rotate];
            }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                loadMoreTopView.pulldownView.layer.transform = CATransform3DMakeRotation((M_PI * 180)/180,0,0,1);
            }];
            
            loadMoreTopView.pullTextLabe.text = @"下拉返回帖子";
        }
    }
}


#pragma mark -- 上拉加载图文详情页面
- (void)scrollViewByPageControlPage:(NSInteger)page
{
    [UIView animateWithDuration:0.2f animations:^{
        if (isLoadMore == NO) {
            [self.myScrollView setContentOffset:CGPointMake(0,detailWebView.bottom)];
        }else{
            [self.myScrollView setContentOffset:CGPointMake(0,0)];
        }
        
    } completion:^(BOOL finished) {
        isLoadMore = YES;
    }];
}


#pragma mark -- HTTP
- (void)getTopicDetail:(NSString *)post_id
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"RePostInfo",@"LoginUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"ID":post_id,@"IsShow":@"888"}]};
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if (result) {
            NSArray *items = [result objectForKey:@"Detail"];
            for (int i = 0; i < items.count; i++) {
                NSDictionary *dic = [items objectAtIndex:i];
                NSString *nickname = [dic objectForKey:@"nickname"];
                NSString *titleName = [dic objectForKey:@"name"];
                NSString *date = [dic objectForKey:@"lastcommentdate"];
                NSString *logopicture = [dic objectForKey:@"logopicture"];
                NSString *picturedomain = [dic objectForKey:@"logopicturedomain"];
                NSString *source = [dic objectForKey:@"source"];
                
                NSString *commentnum = [dic objectForKey:@"commentnum"];
                NSString *praisenum  = [dic objectForKey:@"praisenum"];
                self.likeNumber = praisenum;
                CGSize commentSize = [commentnum sizeWithFont:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize likeSize = [praisenum sizeWithFont:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                footView.likeNumLabel.text = praisenum;
                footView.commentNumLabel.text = commentnum;
                
                CGRect likeRect = footView.likeNumLabel.frame;
                likeRect.size.width =likeSize.width + 5;
                footView.likeNumLabel.frame = likeRect;
                
                CGRect commentRect = footView.commentNumLabel.frame;
                commentRect.size.width = commentSize.width + 5;
                footView.commentNumLabel.frame = commentRect;
                
                NSString *avataURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",picturedomain],BASE_IMAGE_URL,face,logopicture];
                NSDictionary *dataDic = @{@"date":[NSString stringWithFormat:@"%@ %@",date,source],@"avataURL":avataURL,@"nickname":nickname};
                [headView getUserInfoData:dataDic];
                
                //是否可以打赏
                NSString *isShow = [dic objectForKey:@"isshow"];
                if ([isShow intValue] == 2) {
                    TopicCommentDetailView *topicCommentDetailView = [[TopicCommentDetailView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90) withPostID:self.post_id isReawrd:@"2"];
                    [footBackgroundView addSubview:topicCommentDetailView];
                    GoodsLoadMoreFootView *goodsLoadMoreView = [[GoodsLoadMoreFootView alloc]initWithFrame:CGRectMake(0, topicCommentDetailView.bottom, ScreenWidth, 49)];
                    [footBackgroundView addSubview:goodsLoadMoreView];
                    footBackgroundView.frame = CGRectMake(0, 0, ScreenWidth, topicCommentDetailView.height + goodsLoadMoreView.height);
                    detailWebView.footerView = footBackgroundView;
                }else{
                    GoodsLoadMoreFootView *goodsLoadMoreView = [[GoodsLoadMoreFootView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
                    footBackgroundView.frame = CGRectMake(0, 0, ScreenWidth , goodsLoadMoreView.height);
                    [footBackgroundView addSubview:goodsLoadMoreView];
                    detailWebView.footerView = footBackgroundView;
                }
                
                //是否点赞
                NSArray  *praiseArray = [result objectForKey:@"IsPraise"];
                NSString *praiseStatus = [[praiseArray firstObject]objectForKey:@"value"];
                if ([praiseStatus intValue] == 1) {
                    isLike = YES; //已点赞
                    [footView.likeBtn setImage:[UIImage imageNamed:@"topic_detail_like_high"] forState:UIControlStateNormal];
                }else{
                    [footView.likeBtn setImage:[UIImage imageNamed:@"topic_detail_like"] forState:UIControlStateNormal];
                    isLike = NO;
                }
            }
        }
    } failure:^(NSError *erro) {
        
    }];
}

#pragma mark -- action
- (void)writeCommentAction
{
    WriteCommentViewController *writeCommentVC = [[WriteCommentViewController alloc]init];
    writeCommentVC.post_id = self.post_id;
    BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:writeCommentVC];
    [self.navigationController presentViewController:baseNav animated:YES completion:^{
        
    }];
}

- (void)checkCommentAction
{
    isLoadMore = YES;
    isLoadTopMore = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.myScrollView setContentOffset:CGPointMake(0,detailWebView.bottom)];
    }];
}

- (void)likeAction
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        LoginViewController     *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    //点赞
    if (isLike == NO) {
        NSDictionary *parameters = @{@"Method":@"AddPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIp":@"1",@"Detail":@[@{@"PostID":self.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
            
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self initMBProgress:@"点赞+1" withModeType:MBProgressHUDModeText afterDelay:1.5];
                int praisenum = [self.likeNumber intValue];
                praisenum = praisenum + 1;
                footView.likeNumLabel.text = [NSString stringWithFormat:@"%d",praisenum];
                self.likeNumber = [NSString stringWithFormat:@"%d",praisenum];
                isLike = YES;
                [footView.likeBtn setImage:[UIImage imageNamed:@"topic_detail_like_high"] forState:UIControlStateNormal];
            }else{
                [self initMBProgress:@"你已经赞过了" withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }else{  //取消点赞
        NSDictionary *parameters = @{@"Method":@"DelPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIp":@"1",@"Detail":@[@{@"PostID":self.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
            
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self initMBProgress:@"取消点赞" withModeType:MBProgressHUDModeText afterDelay:1.5];
                int praisenum = [self.likeNumber intValue];
                praisenum = praisenum - 1;
                footView.likeNumLabel.text = [NSString stringWithFormat:@"%d",praisenum];
                self.likeNumber = [NSString stringWithFormat:@"%d",praisenum];
                [footView.likeBtn setImage:[UIImage imageNamed:@"topic_detail_like"] forState:UIControlStateNormal];
                isLike = NO;
            }else{
                [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }
}

- (void)checkMoreAction
{
    NSString *textStr;
    int isZoom = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isZoom"]intValue];
    if (isZoom == 0) {
        textStr = @"正文大字号";
        isTextZoom = YES;
    }else{
        isTextZoom = NO;
        textStr = @"正常字号";
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",@"收藏",textStr, nil];
    sheet.actionSheetStyle =UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        SharedInfo *shared = [SharedInfo sharedDataInfo];
        if (isStrEmpty(shared.user_id)) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        
        NSDictionary *parameters = @{@"Method":@"AddMyCollectionInfo",@"RunnerUserID":shared.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"UserID":shared.user_id,@"PostID":self.post_id,@"IsShow":@"888"}]};
        [CKHttpRequest createRequest:HTTP_METHOD_MY_COLLECTION WithParam:parameters withMethod:@"POST" success:^(id result) {
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self initMBProgress:@"收藏成功" withModeType:MBProgressHUDModeText afterDelay:1.0];
            }else{
                [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.0];
            }
        } failure:^(NSError *erro) {
            
        }];
        
    }else if (buttonIndex == 2){
        if (isTextZoom) {
            NSString *str1 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '%f%%'",120.0];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isZoom"];
            [detailWebView stringByEvaluatingJavaScriptFromString:str1];
        }else{
            NSString *str1 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '%f%%'",100.0];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isZoom"];
            [detailWebView stringByEvaluatingJavaScriptFromString:str1];
        }
    }
}

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [scorllBtnView.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    isLoadTopMore = YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
