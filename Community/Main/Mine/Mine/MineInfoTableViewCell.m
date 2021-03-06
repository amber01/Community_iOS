//
//  MineInfoTableViewCell.m
//  Community
//
//  Created by amber on 15/11/15.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MineInfoTableViewCell.h"
#import "MineInfoViewController.h"
#import "FansListViewController.h"

@implementation MineInfoTableViewCell
{
    UIImageView *avatarImageView;
    UIButton    *postsBtn;
    UIButton    *fansBtn;
    UIButton    *followBtn;
    UIButton    *scoreBtn;
    
    UILabel     *postsNumLabel;
    UILabel     *fansNumLabel;
    UILabel     *followNumLabel;
    UILabel     *scoreNumLabel;
    
    UILabel     *nicknameLabel;
    UILabel     *prestigeLabel;
    
    UIImageView         *showVImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadListData) name:kReloadDataNotification object:nil];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 125)];
        avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:30];
        
        showVImageView = [[UIImageView alloc]initWithFrame:CGRectMake(avatarImageView.right - 15, avatarImageView.bottom - 18, 15, 15)];
        showVImageView.image = [UIImage imageNamed:@"topic_isv_icon"];
        
        nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right + 10, 15, ScreenWidth - avatarImageView.right - 30, 20)];
        nicknameLabel.text = @"盛夏光年";
        [nicknameLabel setFont:[UIFont systemFontOfSize:16]];
        
        prestigeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nicknameLabel.left, nicknameLabel.bottom + 10, 230, 20)];
        prestigeLabel.textColor = TEXT_COLOR;
        [prestigeLabel setFont:[UIFont systemFontOfSize:14]];
        prestigeLabel.text = @"威望:V2";
        
        postsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [postsBtn addTarget:self action:@selector(checkPostListAction) forControlEvents:UIControlEventTouchUpInside];
        postsBtn.frame = CGRectMake(0, bgView.height - 53, ScreenWidth/4, 40);
        
        fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fansBtn addTarget:self action:@selector(checkMyFansAction) forControlEvents:UIControlEventTouchUpInside];
        fansBtn.frame = CGRectMake(postsBtn.right, bgView.height - 53, ScreenWidth/4, 40);
        
        followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [followBtn addTarget:self action:@selector(checkMyFollowAction) forControlEvents:UIControlEventTouchUpInside];
        followBtn.frame = CGRectMake(fansBtn.right, bgView.height - 53, ScreenWidth/4, 40);
        
        scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [scoreBtn addTarget:self action:@selector(checkScoreList) forControlEvents:UIControlEventTouchUpInside];
        scoreBtn.frame = CGRectMake(followBtn.right, bgView.height - 53, ScreenWidth/4, 40);
        
        [CommonClass setBorderWithView:postsBtn top:NO left:NO bottom:NO right:YES borderColor:LINE_COLOR borderWidth:0.5];
        [CommonClass setBorderWithView:fansBtn top:NO left:NO bottom:NO right:YES borderColor:LINE_COLOR borderWidth:0.5];
        [CommonClass setBorderWithView:followBtn top:NO left:NO bottom:NO right:YES borderColor:LINE_COLOR borderWidth:0.5];
        
        UILabel *postLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, ScreenWidth/4, 20)];
        [postLabel setFont:[UIFont systemFontOfSize:14]];
        postLabel.text = @"帖子";
        postLabel.textAlignment = NSTextAlignmentCenter;
        postLabel.textColor = TEXT_COLOR;
        
        UILabel *fansLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, ScreenWidth/4, 20)];
        [fansLabel setFont:[UIFont systemFontOfSize:14]];
        fansLabel.text = @"粉丝";
        fansLabel.textAlignment = NSTextAlignmentCenter;
        fansLabel.textColor = TEXT_COLOR;
        
        self.tipsView = [[UIView alloc]initWithFrame:CGRectMake(fansBtn.width/2 + 10,5 , 14, 14)];
        self.tipsView.backgroundColor = [UIColor redColor];
        [UIUtils setupViewRadius:_tipsView cornerRadius:_tipsView.height/2];
        
        self.tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _tipsView.height/2-10, _tipsView.width, 20)];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.font = [UIFont systemFontOfSize:9];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"0";
        [_tipsView addSubview:_tipsLabel];
        [fansBtn addSubview:_tipsView];
        
        UILabel *followLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, ScreenWidth/4, 20)];
        [followLabel setFont:[UIFont systemFontOfSize:14]];
        followLabel.text = @"关注";
        followLabel.textAlignment = NSTextAlignmentCenter;
        followLabel.textColor = TEXT_COLOR;
        
        
        UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, ScreenWidth/4, 20)];
        [scoreLabel setFont:[UIFont systemFontOfSize:14]];
        scoreLabel.text = @"积分";
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.textColor = TEXT_COLOR;
        
        postsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, ScreenWidth/4, 20)];
        postsNumLabel.font = [UIFont systemFontOfSize:14];
        postsNumLabel.textAlignment = NSTextAlignmentCenter;
        postsNumLabel.text = @"23";
        
        fansNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, ScreenWidth/4, 20)];
        fansNumLabel.font = [UIFont systemFontOfSize:14];
        fansNumLabel.textAlignment = NSTextAlignmentCenter;
        fansNumLabel.text = @"23";
        
        followNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, ScreenWidth/4, 20)];
        followNumLabel.font = [UIFont systemFontOfSize:14];
        followNumLabel.textAlignment = NSTextAlignmentCenter;
        followNumLabel.text = @"23";
        
        scoreNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, ScreenWidth/4, 20)];
        scoreNumLabel.font = [UIFont systemFontOfSize:14];
        scoreNumLabel.textAlignment = NSTextAlignmentCenter;
        scoreNumLabel.text = @"23";
        
        [scoreBtn addSubview:scoreNumLabel];
        [followBtn addSubview:followNumLabel];
        [fansBtn addSubview:fansNumLabel];
        [postsBtn addSubview:postsNumLabel];
        
        [scoreBtn addSubview:scoreLabel];
        [followBtn addSubview:followLabel];
        [fansBtn addSubview:fansLabel];
        [postsBtn addSubview:postLabel];
        
        
        [bgView addSubview:prestigeLabel];
        [bgView addSubview:scoreBtn];
        [bgView addSubview:followBtn];
        [bgView addSubview:fansBtn];
        [bgView addSubview:postsBtn];
        [bgView addSubview:nicknameLabel];
        [bgView addSubview:avatarImageView];
        [bgView addSubview:showVImageView];
        [self.contentView addSubview:bgView];
    }
    return self;
}

- (void)configureCellWithInfo:(UserModel *)model withNewFansCount:(NSString *)fansCount
{
    NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.picturedomain],BASE_IMAGE_URL,face,model.picture];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"mine_login"]];
    nicknameLabel.text = model.nickname;
    postsNumLabel.text = model.postnum;
    fansNumLabel.text = model.myfansnum;
    followNumLabel.text = model.mytofansnum;
    scoreNumLabel.text = model.totalscore;
    prestigeLabel.text = [NSString stringWithFormat: @"威望:V%@",model.prestige];
    [[NSUserDefaults standardUserDefaults] setObject:model.nickname forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] setObject:model.postnum forKey:@"postnum"];
    [[NSUserDefaults standardUserDefaults] setObject:model.myfansnum forKey:@"myfansnum"];
    [[NSUserDefaults standardUserDefaults] setObject:model.mytofansnum forKey:@"mytofansnum"];
    [[NSUserDefaults standardUserDefaults] setObject:model.totalscore forKey:@"totalscore"];
    
    if ([fansCount intValue] > 0) {
        self.tipsView.hidden = NO;
        self.tipsLabel.text = fansCount;
    }else{
        self.tipsView.hidden = YES;
    }
    
    
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    sharedInfo.nickname = model.nickname;
    sharedInfo.postnum = model.postnum;
    sharedInfo.myfansnum = model.myfansnum;
    sharedInfo.mytofansnum = model.mytofansnum;
    sharedInfo.totalscore = model.totalscore;
    if ([sharedInfo.isv intValue] == 1) {
        showVImageView.hidden = NO;
    }else{
        showVImageView.hidden = YES;
    }
    
}

- (void)checkPostListAction
{
    MineInfoViewController *mineInfoVC = [[MineInfoViewController alloc]init];
    mineInfoVC.status = @"0";
    [mineInfoVC setHidesBottomBarWhenPushed:YES];
    [self.viewController.navigationController pushViewController:mineInfoVC animated:YES];
}

- (void)checkMyFansAction
{
    FansListViewController *fansVC = [[FansListViewController alloc]init];
    fansVC.title = @"粉丝";
    [fansVC setHidesBottomBarWhenPushed:YES];
    fansVC.status = @"0";
    [self.viewController.navigationController pushViewController:fansVC animated:YES];
}

- (void)checkMyFollowAction
{
    FansListViewController *fansVC = [[FansListViewController alloc]init];
    fansVC.title = @"关注";
    [fansVC setHidesBottomBarWhenPushed:YES];
    fansVC.status = @"1";
    [self.viewController.navigationController pushViewController:fansVC animated:YES];
}

- (void)checkScoreList
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameter = @{@"UserID":sharedInfo.user_id,
                                @"UserName":sharedInfo.username};
    
    [CKHttpRequest createRequest:HTTP_METHOD_ENCRYPT WithParam:parameter withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if ([[result objectForKey:@"UserID"]length] > 0) {
            NSString *userID = [result objectForKey:@"UserID"];
            NSString *userName = [result objectForKey:@"UserName"];
            
            WebDetailViewController *webDetailVC = [[WebDetailViewController alloc]init];
            webDetailVC.url = [NSString stringWithFormat:@"%@detailed.aspx?UserID=%@&UserName=%@",ROOT_URL,userID,userName];
            [webDetailVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:webDetailVC animated:YES];
            
        }
        
    } failure:^(NSError *erro) {
        
    }];
}

- (void)reloadListData
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    nicknameLabel.text = sharedInfo.nickname;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
