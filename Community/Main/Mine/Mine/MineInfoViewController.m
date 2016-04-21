//
//  MineInfoViewController.m
//  Community
//
//  Created by amber on 15/11/28.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MineInfoViewController.h"
#import "WSHeaderView.h"
#import "MineInfoTopView.h"
#import "EveryoneTopicTableViewCell.h"
#import "TopicDetailViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface MineInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    WSHeaderView *_header;
    int          page;
    MineInfoTopView *mineInfoTopView;
    UILabel         *nameLabe;
    UILabel             *prestigeLabel;  //声望
}

@property (nonatomic,retain) UITableView *tableView;

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,retain) NSMutableArray *praiseDataArray;

@property (nonatomic,copy)   NSString       *fldSort;
@property (nonatomic,copy)   NSString       *isEssence;

@property (nonatomic,retain) NSMutableArray *likeDataArray;  //记录本地点赞的状态
@property (nonatomic,retain) NSMutableArray *isLikeDataArray;  //是否已经点赞

@property (nonatomic,copy)   NSString       *sharePicturedomain;
@property (nonatomic,copy)   NSString       *shareImageURL;
@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人主页";
    [self createdTabelView];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"mine_share"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 25, 25);
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadUserInfoData) name:@"kReloadUserDataNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadUserInfoData) name:kReloadDataNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadUserInfoData) name:@"kReloadAvatarImageNotification" object:nil];
    
    page = 1;
    self.fldSort = @"0";
    self.isEssence = @"0";
    [self getEveryoneTopicData:1 withFldSort:@"0" andIsEssence:@"0"];
    [self setupUploadMore];
}

- (void)createdTabelView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //init headview
    _header = [[WSHeaderView alloc]init];
    
    //set header view
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    NSString *imageURL;
    if (self.avatarUrl.length == 0) { //自己的
        SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
        imageURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",shareInfo.picturedomain],BASE_IMAGE_URL,face,shareInfo.picture];
    }else{ //他人的
        SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
        imageURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",shareInfo.picturedomain],BASE_IMAGE_URL,face,self.avatarUrl];
    }
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]placeholderImage:[UIImage imageWithColor:VIEW_COLOR]];
    
    NSLog(@"avatar url:%@",imageURL);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180*scaleToScreenHeight)];
    imageView.image = [UIUtils applyBlurRadius:7 toImage:avatarImageView.image];
    
    /**
     *  创建头像
     */
    UIImageView *avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 35, 15, 70, 70)];
    [avatarView sd_setImageWithURL:[NSURL URLWithString:imageURL]placeholderImage:[UIImage imageWithColor:VIEW_COLOR]];
    [UIUtils setupViewBorder:avatarView cornerRadius:avatarView.height/2 borderWidth:2 borderColor:[UIColor whiteColor]];
    [imageView addSubview:avatarView];
    
    /**
     *  昵称
     */
    nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(0, avatarView.bottom + 10 , ScreenWidth, 20)];
    nameLabe.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    nameLabe.text = @"";
    nameLabe.textColor = [UIColor whiteColor];
    nameLabe.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:nameLabe];
    
    /**
     *  声望
     */
    prestigeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabe.right + 10, nameLabe.top + 2, 32, 16)];
    prestigeLabel.textAlignment = NSTextAlignmentCenter;
    prestigeLabel.textColor = [UIColor whiteColor];
    prestigeLabel.backgroundColor = [UIColor colorWithHexString:@"#f5a623"];
    [UIUtils setupViewRadius:prestigeLabel cornerRadius:3];
    prestigeLabel.font = kFont(12);
    prestigeLabel.text = @"v1";
    [imageView addSubview:prestigeLabel];
    
    _header = [WSHeaderView expandWithScrollView:_tableView expandView:imageView];
    
    SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
    mineInfoTopView = [[MineInfoTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 155) withUserID:isStrEmpty(self.user_id) ? shareInfo.user_id : self.user_id andNickname:isStrEmpty(self.nickname) ? @"" : self.nickname andUserName:isStrEmpty(self.userName)? @"" : self.userName andAvararUrl:isStrEmpty(self.avatarUrl) ? @"" : self.avatarUrl];
    [mineInfoTopView.topicBtn addTarget:self action:@selector(checkTopicListAction) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableHeaderView = mineInfoTopView;
    
    [self getUserInfoData:isStrEmpty(self.user_id) ? shareInfo.user_id : self.user_id];
}

- (void)setupUploadMore{
    __unsafe_unretained __typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)loadMoreData{
    page = page + 1;
    [self getEveryoneTopicData:page withFldSort:self.fldSort andIsEssence:self.isEssence];
    self.status = @"1";
    [_tableView.mj_footer endRefreshing];
}

#pragma mark -- Notification
- (void)reloadUserInfoData
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    mineInfoTopView.nicknameLabel.text = sharedInfo.nickname;
    [mineInfoTopView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",sharedInfo.picturedomain],BASE_IMAGE_URL,face,sharedInfo.picture]]placeholderImage:[UIImage imageNamed:@"mine_login"]];
    if ([sharedInfo.sex isEqualToString:@"女"]) {
        mineInfoTopView.sexImageView.image = [UIImage imageNamed:@"user_women"];
    }else{
        mineInfoTopView.sexImageView.image = [UIImage imageNamed:@"user_man.png"];
    }
}

#pragma mark -- HTTP
- (void)getUserInfoData:(NSString *)user_id;
{
    NSDictionary *params = @{@"Method":@"ReUserInfo",@"Detail":@[@{@"ID":user_id}]};
    
    [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
        if (result) {
            NSLog(@"result:%@",result);
            NSArray *dataArray = [result objectForKey:@"Detail"];
            for (int i = 0; i < dataArray.count; i ++) {
                NSDictionary *dic = [dataArray objectAtIndex:i];
                self.shareImageURL = [dic objectForKey:@"picture"];
                self.sharePicturedomain = [dic objectForKey:@"picturedomain"];
                nameLabe.text = [dic objectForKey:@"nickname"];
                
                CGSize nickNameWidth = [nameLabe.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGRect nameFrame = nameLabe.frame;
                nameFrame.origin.x = (ScreenWidth/2 - nickNameWidth.width/2) - 13;
                nameFrame.size.width = nickNameWidth.width;
                nameLabe.frame = nameFrame;
                
                CGRect prestigeFrame = prestigeLabel.frame;
                prestigeFrame.origin.x = nameLabe.right + 10;
                prestigeLabel.frame = prestigeFrame;

                prestigeLabel.text = [NSString stringWithFormat:@"v%@",[dic objectForKey:@"prestige"]];
            }
        }
    } failure:^(NSError *erro) {
        
    }];
}


- (void)getEveryoneTopicData:(int)pageIndex withFldSort:(NSString *)fldSort andIsEssence:(NSString *)isEssence
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *parameters = @{@"Method":@"RePostInfo",@"LoginUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":@[@{@"PageSize":@"20",@"IsShow":@"888",@"PageIndex":pageStr,@"FldSort":fldSort,@"FldSortType":@"1",@"CityID":@"0",@"ProvinceID":@"0",@"IsEssence":isEssence,@"ClassID":@"",@"UserID":isStrEmpty(self.user_id) ? sharedInfo.user_id : self.user_id}]};
    
    [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSArray *items = [EveryoneTopicModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *imageItems = [TodayTopicImagesModel arrayOfModelsFromDictionaries:[result objectForKey:@"Images"]];
        NSArray *praiseItems = [result objectForKey:@"IsPraise"];
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
            [self.imagesArray removeAllObjects];
            [self.praiseDataArray removeAllObjects];
        }
        
        for (int i = 0; i < items.count; i ++) {
            if (!self.dataArray) {
                self.dataArray = [[NSMutableArray alloc]init];
            }
            [self.dataArray addObject:[items objectAtIndex:i]];
        }
        
        for (int i = 0; i < imageItems.count; i ++) {
            if (!self.imagesArray) {
                self.imagesArray = [[NSMutableArray alloc]init];
            }
            [self.imagesArray addObject:[imageItems objectAtIndex:i]];
        }
        
        for (int i = 0; i < praiseItems.count; i ++) {
            if (!self.praiseDataArray) {
                self.praiseDataArray = [[NSMutableArray alloc]init];
            }
            [self.praiseDataArray addObject:[praiseItems objectAtIndex:i]];
        }

        [_tableView reloadData];
        
        if ([self.status isEqualToString:@"0"]) {
            [_tableView setContentOffset:CGPointMake(0, 155)];
        }
        
    } failure:^(NSError *erro) {
        [self setMBProgreeHiden:YES];
    }];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    EveryoneTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[EveryoneTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        [cell.likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    EveryoneTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.likeBtn.post_id = model.id;
    cell.likeBtn.row = indexPath.row;
    
    if (!_likeDataArray) {
        self.likeDataArray = [[NSMutableArray alloc]init];
    }
    [_likeDataArray addObject:model.praisenum];
    
    [cell configureCellWithInfo:model withImages:self.imagesArray andPraiseData:self.praiseDataArray andRow:indexPath.row];
    
    if (!isArrEmpty(self.praiseDataArray)) {
        NSDictionary *dic = [self.praiseDataArray objectAtIndex:indexPath.row];
        cell.likeBtn.post_id = [dic objectForKey:@"postid"];
        cell.likeBtn.isPraise = [dic objectForKey:@"value"];
    }
    
    cell.likeLabel.text = _likeDataArray[indexPath.row];
    cell.likeBtn.praisenum = _likeDataArray[indexPath.row];
    
    return cell;
}

//cell动态计算高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    EveryoneTopicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    TopicDetailViewController *topicDetaiVC = [[TopicDetailViewController alloc]init];
    topicDetaiVC.post_id = model.id;
    topicDetaiVC.user_id = model.userid;
    [topicDetaiVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:topicDetaiVC animated:YES];

}

#pragma mark -- action
- (void)likeAction:(PubliButton *)button
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        LoginViewController *loginVC = [[LoginViewController  alloc]init];
        [loginVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    //点赞
    if ([button.isPraise intValue] == 0) {
        NSDictionary *parameters = @{@"Method":@"AddPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIp":@"1",@"Detail":@[@{@"PostID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
            
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
                [self.praiseDataArray insertObject:@{@"postid":button.post_id,@"value":@"1"} atIndex:button.row];
                
                //点赞之后改变点赞的状态
                NSIndexPath *index =  [NSIndexPath indexPathForItem:button.row inSection:0];
                EveryoneTopicTableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
                cell.likeLabel.text = _likeDataArray[button.row];
                
                cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
                [_tableView reloadData];
            }else{
                [self initMBProgress:@"你已经赞过了" withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }else{  //取消点赞
        NSDictionary *parameters = @{@"Method":@"DelPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIp":@"1",@"Detail":@[@{@"PostID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
            
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
                [self.praiseDataArray insertObject:@{@"postid":button.post_id,@"value":@"0"} atIndex:button.row];
                
                //点赞之后改变点赞的状态
                NSIndexPath *index =  [NSIndexPath indexPathForItem:button.row inSection:0];
                EveryoneTopicTableViewCell *cell =  [_tableView cellForRowAtIndexPath:index];
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

#pragma mark -- action
- (void)shareAction
{
    [UMSocialWechatHandler setWXAppId:@"wxc1830ea42532921e" appSecret:@"73ce199faec839454273de0ac5606858" url:[NSString stringWithFormat:@"%@user/t%@",ROOT_URL,self.user_id]];
    [UMSocialQQHandler setQQWithAppId:@"1105030412" appKey:@"iGDileMaPq45D3Mf" url:[NSString stringWithFormat:@"%@user%@",ROOT_URL,self.user_id]];
    
    UIImageView *shareImageView = [[UIImageView alloc]init];
    [shareImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",self.sharePicturedomain],BASE_IMAGE_URL,face,self.shareImageURL]]placeholderImage:[UIImage imageNamed:@"app_default_icon"]];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = shareImageView.image;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = shareImageView.image;        [UMSocialData defaultData].extConfig.sinaData.shareImage = shareImageView.image;
    [UMSocialData defaultData].extConfig.qqData.shareImage = shareImageView.image;
    [UMSocialData defaultData].extConfig.qzoneData.shareImage = shareImageView.image;
    
    
    [UMSocialData defaultData].extConfig.smsData.shareText =  [NSString stringWithFormat:@"%@的微温州社区主页快来看看",self.nickname];
    [UMSocialData defaultData].extConfig.sinaData.shareText =  [NSString stringWithFormat:@"%@的微温州社区主页快来看看",self.nickname];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"%@的微温州社区主页快来看看",self.nickname];
    [UMSocialData defaultData].extConfig.qqData.title = @"来自微温州的分享";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"来自微温州的分享";
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:Umeng_key
                                      shareText:@"看了微温州,才知道温州每天发生这么多事情！"
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSms,nil]
                                       delegate:self];
}

- (void)checkTopicListAction
{
    [_tableView setContentOffset:CGPointMake(0, 155)];
}

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.status = @"1";
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
