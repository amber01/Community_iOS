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
#import "MineInfoHeadView.h"
#import "DiscoverTableViewCell.h"

@interface MineInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    WSHeaderView *_header;
    int          page;
    MineInfoTopView *mineInfoView;
    MineInfoHeadView *mineInfoTopView;
    UILabel         *nameLabe;
    UILabel             *prestigeLabel;  //声望
    UIImageView *avatarImageView;
    float   height;
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
    avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
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
    imageView.userInteractionEnabled = YES;
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
    mineInfoView = [[MineInfoTopView alloc]initWithFrame:CGRectMake(0, prestigeLabel.bottom + 15*scaleToScreenHeight, ScreenWidth, 80) withUserID:isStrEmpty(self.user_id) ? shareInfo.user_id : self.user_id andNickname:isStrEmpty(self.nickname) ? @"" : self.nickname andUserName:isStrEmpty(self.userName)? @"" : self.userName andAvararUrl:isStrEmpty(self.avatarUrl) ? @"" : self.avatarUrl];
    
    mineInfoTopView = [[MineInfoHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70) withUserID:isStrEmpty(self.user_id) ? shareInfo.user_id : self.user_id andNickname:isStrEmpty(self.nickname) ? @"" : self.nickname andUserName:isStrEmpty(self.userName)? @"" : self.userName andAvararUrl:isStrEmpty(self.avatarUrl) ? @"" : self.avatarUrl];
    
    [mineInfoTopView.topicBtn addTarget:self action:@selector(checkTopicListAction) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableHeaderView = mineInfoTopView;
    
    [imageView addSubview:mineInfoView];
    
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
    nameLabe.text = sharedInfo.nickname;
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",sharedInfo.picturedomain],BASE_IMAGE_URL,face,sharedInfo.picture]]placeholderImage:[UIImage imageNamed:@"mine_login"]];
    
    //    if ([sharedInfo.sex isEqualToString:@"女"]) {
    //        mineInfoTopView.sexImageView.image = [UIImage imageNamed:@"user_women"];
    //    }else{
    //        mineInfoTopView.sexImageView.image = [UIImage imageNamed:@"user_man.png"];
    //    }
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
        NSArray *items = [FriendSquareModel arrayOfModelsFromDictionaries:[result objectForKey:@"Detail"]];
        NSArray *tempArr = [result objectForKey:@"Detail"];
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
            [_praiseDataArray removeAllObjects];
        }
        
        for (int i = 0; i < items.count; i ++) {
            if (!self.dataArray) {
                self.dataArray = [[NSMutableArray alloc]init];
            }
            [self.dataArray addObject:[items objectAtIndex:i]];
        }
        
        for (int i = 0; i < tempArr.count; i ++) {
            if (!_praiseDataArray) {
                _praiseDataArray = [NSMutableArray new];
            }
            NSDictionary *dic = tempArr[i];
            [_praiseDataArray insertObject:[dic objectForKey:@"ispraise"] atIndex:i];
        }
        
        [self.tableView reloadData];
        
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
    static NSString *identifyCell = @"cell";
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyCell];
    if (!cell) {
        cell = [[DiscoverTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyCell];
        [cell.likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    FriendSquareModel *model = nil;
    model = [self.dataArray objectAtIndex:indexPath.row];
    cell.likeBtn.row = indexPath.row;
    
    [cell configureCellWithInfo:model];
    
    if (!_likeDataArray) {
        self.likeDataArray = [[NSMutableArray alloc]init];
    }
    [_likeDataArray addObject:model.praisenum];
    
    cell.likeImageView.image = [UIImage imageNamed:@"discover_find_friend_high"];
    
    cell.likeBtn.post_id = model.id;
    cell.likeBtn.isPraise = _praiseDataArray[indexPath.row];
    
    cell.likeLabel.text = _likeDataArray[indexPath.row];
    cell.likeBtn.praisenum = _likeDataArray[indexPath.row];
    
    if ([_praiseDataArray[indexPath.row]intValue] > 0) {
        cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
    }else{
        cell.likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
    }
    
    return cell;
}

//cell动态计算高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendSquareModel *model = nil;
    model = [self.dataArray objectAtIndex:indexPath.row];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize contentHeight = [model.describe boundingRectWithSize:CGSizeMake(ScreenWidth - 45 - 20 - 10 - 15, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    NSArray *imageArray = [model.images componentsSeparatedByString:@","];
    
    if (model.describe.length == 0) {
        contentHeight.height = 0;
    }
    
    if (imageArray.count > 1) {
        if (imageArray.count <= 3) {
            height = (((ScreenWidth - 45 - 20 - 10 - 15)/3)-5);
        }else if (imageArray.count >3 && imageArray.count<= 6){
            height = ((((ScreenWidth - 45 - 20 - 10 - 15)/3)-5)*2)+5;
        }else if (imageArray.count > 6){
            height = ((((ScreenWidth - 45 - 20 - 10 - 15)/3)-5)*3)+10;
        }
    }else if (imageArray.count == 1){
        int tempWidth;
        int imageMaxWidth = ScreenWidth - 45 - 20 - 10 - 15;
        if ([model.width intValue] >= imageMaxWidth) {
            tempWidth = imageMaxWidth;
            float scaleToHeight = [model.width intValue] - imageMaxWidth;
            height = ([model.height intValue]) - scaleToHeight;
        }else{
            height = [model.height intValue];
        }
    }
    return 70 + contentHeight.height + height + 20 + 14 + 17 - 5;
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
    
    [self initMBProgress:@""];
    //点赞
    if ([button.isPraise intValue] == 0) {
        NSDictionary *parameters = @{@"Method":@"AddPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"PostID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
            [self setMBProgreeHiden:YES];
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
                
                [_tableView reloadData];
            }else{
                [self initMBProgress:@"你已经赞过了" withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }else{  //取消点赞
        NSDictionary *parameters = @{@"Method":@"DelPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"PostID":button.post_id,@"UserID":sharedInfo.user_id}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
            [self setMBProgreeHiden:YES];
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
