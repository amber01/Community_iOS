//
//  EveryoneTopicTableViewCell.m
//  Community
//
//  Created by amber on 15/11/21.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "EveryoneTopicTableViewCell.h"
#import "TouchImageButton.h"
#import "LoginViewController.h"
#import "CommentViewController.h"

@implementation EveryoneTopicTableViewCell
{
    UIImageView         *avatarImageView;
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    
    UILabel             *contentLabel;
    UIButton            *photoImageBtn1;
    UIButton            *photoImageBtn2;
    UIButton            *photoImageBtn3;
    
    UILabel             *likeLabel;
    UILabel             *commentLabel;
    UILabel             *fromLabel;
    
    PubliButton         *likeBtn;
    PubliButton         *commentBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 45, 45)];
        avatarImageView.image = [UIImage imageNamed:@"001"];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:45/2];
        
        nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, 18, ScreenWidth - avatarImageView.width - 40, 20)];
        nicknameLabel.font = [UIFont systemFontOfSize:14];
        nicknameLabel.text = @"盛夏光年";
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, nicknameLabel.bottom+2, ScreenWidth - avatarImageView.width - 40, 20)];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.text = @"今天 12:23 iPhone6";
        
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, 20)];
        [contentLabel verticalUpAlignmentWithText: @"说的方法第三方水电费水电费水电费说的方法第三方第三方第三方的说法是法师打发" maxHeight:10];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        [contentLabel setFont:[UIFont systemFontOfSize:15]];
        
        photoImageBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(15, contentLabel.bottom + 15, 175/2, 130/2)];
        [photoImageBtn1 addTarget:self action:@selector(showPhotoBrowseOne:) forControlEvents:UIControlEventTouchUpInside];
        
        photoImageBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(photoImageBtn1.right + 7, contentLabel.bottom + 15, 175/2, 130/2)];
        [photoImageBtn2 addTarget:self action:@selector(showPhotoBrowseTwo:) forControlEvents:UIControlEventTouchUpInside];
        
        photoImageBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(photoImageBtn2.right + 7, contentLabel.bottom + 15, 175/2, 130/2)];
        [photoImageBtn3 addTarget:self action:@selector(showPhotoBrowseThree:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        likeBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        likeBtn.frame = CGRectMake(0, photoImageBtn1.bottom + 15, 34, 26);
        likeBtn.backgroundColor = [UIColor whiteColor];
        [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 26/2 - 13, 34/2, 26/2)];
        likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
        likeImageView.userInteractionEnabled = YES;
        [likeBtn addSubview:likeImageView];
        
        likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(likeImageView.right + 5,-2, 70, 20)];
        likeLabel.textColor = [UIColor grayColor];
        likeLabel.font = [UIFont systemFontOfSize:10];
        likeLabel.text = @"顶 232";
        [likeBtn addSubview:likeLabel];
        
        commentBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        commentBtn.frame = CGRectMake(35 + 55, photoImageBtn1.bottom + 15, 90, 30);
        commentBtn.backgroundColor = [UIColor whiteColor];
        [commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 26/2 - 13, 15, 15)];
        commentImageView.userInteractionEnabled = YES;
        commentImageView.image = [UIImage imageNamed:@"everyone_topic_comment"];
        [commentBtn addSubview:commentImageView];
        
        commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentImageView.right + 5, -2, 100, 20)];
        commentLabel.textColor = [UIColor grayColor];
        commentLabel.font = [UIFont systemFontOfSize:10];
        commentLabel.text = @"评论 234";
        [commentBtn addSubview:commentLabel];
        
        fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, photoImageBtn1.bottom + 12, ScreenWidth - 100 - 15, 20)];
        fromLabel.textColor = [UIColor grayColor];
        fromLabel.font = [UIFont systemFontOfSize:10];
        fromLabel.textAlignment = NSTextAlignmentRight;
        fromLabel.text = @"灌水区";
        
        [self.contentView addSubview:fromLabel];
        [self.contentView addSubview:commentBtn];
        [self.contentView addSubview:likeBtn];
        [self.contentView addSubview:photoImageBtn3];
        [self.contentView addSubview:photoImageBtn1];
        [self.contentView addSubview:photoImageBtn2];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:contentLabel];
        [self.contentView addSubview:nicknameLabel];
        [self.contentView addSubview:avatarImageView];
        
    }
    return self;
}

- (void)configureCellWithInfo:(EveryoneTopicModel *)model withImages:(NSArray *)imageArray
{
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",picturedomain,BASE_IMAGE_URL,face,model.logopicture]]];
    nicknameLabel.text = model.nickname;
    dateLabel.text = model.createtime;
    
    /**
     *  动态计算内容高度
     */
    NSString *titleStr = isStrEmpty(model.name) ? @"" : [NSString stringWithFormat:@"【%@】",model.name];
    contentLabel.text = [NSString stringWithFormat:@"%@%@",titleStr,model.detail];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize contentHeight = [contentLabel.text boundingRectWithSize:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    if (contentLabel.text.length == 0) {
        contentHeight.height = 0;
    }
    
    likeBtn.post_id = model.id;
    commentBtn.post_id = model.id;
    
    contentLabel.frame = CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, contentHeight.height);
    
    /**
     *  创建图片
     */
    
    [self.photoUrlArray removeAllObjects];
    
    float imageHeight;
    if ([model.imagecount intValue] > 0) {
        
        photoImageBtn1.frame = CGRectMake(15, contentLabel.bottom + 10, 80, 80);
        photoImageBtn2.frame = CGRectMake(photoImageBtn1.right + 7, contentLabel.bottom + 10, 80, 80);
        photoImageBtn3.frame = CGRectMake(photoImageBtn2.right + 7, contentLabel.bottom + 10, 80, 80);

        photoImageBtn1.hidden = NO;
        photoImageBtn2.hidden = NO;
        photoImageBtn3.hidden = NO;
        
        
        imageHeight = 80 + contentLabel.bottom + 10;
        int k=0;
        for (int i = 0; i < imageArray.count; i ++) {
            TodayTopicImagesModel *imagesModel = [imageArray objectAtIndex:i];
            
            if ([model.id isEqualToString:imagesModel.postid]) {
                if (!self.photoUrlArray) {
                    self.photoUrlArray = [[NSMutableArray alloc]init];
                }
                
                NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",picturedomain,BASE_IMAGE_URL,BigImage,imagesModel.picture];
                if (k==0) {
                    [photoImageBtn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",picturedomain,BASE_IMAGE_URL,postinfo,imagesModel.picture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_background"]];
                    [self.photoUrlArray addObject:imageURL];
                    k=1;
                }else if (k==1){
                    [photoImageBtn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",picturedomain,BASE_IMAGE_URL,postinfo,imagesModel.picture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_background"]];
                    [self.photoUrlArray addObject:imageURL];
                    k=2;
                }else if (k == 2){
                    [photoImageBtn3 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",picturedomain,BASE_IMAGE_URL,postinfo,imagesModel.picture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_background"]];
                    [self.photoUrlArray addObject:imageURL];
                    k = 3;
                }else if (k == 3){
                    [self.photoUrlArray addObject:imageURL];
                    k = 4;
                }else if (k == 4){
                    [self.photoUrlArray addObject:imageURL];
                    k = 5;
                }else if (k == 5){
                    [self.photoUrlArray addObject:imageURL];
                    k = 6;
                }else if (k == 6){
                    [self.photoUrlArray addObject:imageURL];
                    k = 7;
                }else if (k == 7){
                    [self.photoUrlArray addObject:imageURL];
                    k = 8;
                }else if (k == 8){
                    [self.photoUrlArray addObject:imageURL];
                }
            }else{
                if (self.photoUrlArray.count == 2) {
                    photoImageBtn3.hidden = YES;
                }else if (self.photoUrlArray.count == 1){
                    photoImageBtn2.hidden = YES;
                    photoImageBtn3.hidden = YES;
                }
            }
        }
    }else{
        photoImageBtn1.hidden = YES;
        photoImageBtn2.hidden = YES;
        photoImageBtn3.hidden = YES;
        imageHeight = contentLabel.bottom;
    }
    
    commentLabel.text = [NSString stringWithFormat:@"评论%@",model.commentnum];
    likeLabel.text = [NSString stringWithFormat:@"顶%@",model.praisenum];
    fromLabel.text = model.classname;
    
    likeBtn.frame = CGRectMake(0, imageHeight + 10, 90, 26);
    commentBtn.frame = CGRectMake(35 + 40, imageHeight + 10, 100, 30);
    fromLabel.frame = CGRectMake(100, imageHeight + 8, ScreenWidth - 100 - 15, 20);
    self.frame = CGRectMake(0, 0, ScreenWidth,avatarImageView.height + imageHeight - 10);
}

#pragma mark - photobrowser代理方法
- (void)showPhotoBrowseOne:(TouchImageButton *)button
{

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.imageCount = self.photoUrlArray.count; //图片总数
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];
}

- (void)showPhotoBrowseTwo:(TouchImageButton *)button
{
    if (self.photoUrlArray.count > 1) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.imageCount = self.photoUrlArray.count; //图片总数
        browser.currentImageIndex = 1;
        browser.delegate = self;
        [browser show];
    }
}

- (void)showPhotoBrowseThree:(TouchImageButton *)button
{
    if (self.photoUrlArray.count > 2) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.imageCount = self.photoUrlArray.count; //图片总数
        browser.currentImageIndex = 2;
        browser.delegate = self;
        [browser show];
    }
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.photoUrlArray[index];
    return [NSURL URLWithString:urlStr];
}

#pragma mark -- action
- (void)likeAction:(PubliButton *)button
{
    NSLog(@"id:%@",button.post_id);
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        LoginViewController *loginVC = [[LoginViewController  alloc]init];
        [loginVC setHidesBottomBarWhenPushed:YES];
        [self.viewController.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    NSDictionary *parameters = @{@"Method":@"AddPostToPraise",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIp":@"1",@"Detail":@[@{@"PostID":button.post_id,@"UserID":sharedInfo.user_id}]};
    
    [CKHttpRequest createRequest:HTTP_METHOD_PRAISE WithParam:parameters withMethod:@"POST" success:^(id result) {
        
        if (result && [[result objectForKey:@"Success"]intValue] > 0) {
            likeLabel.text = @"顶10";
        }
        
        } failure:^(NSError *erro) {
        
    }];
}

- (void)commentAction:(PubliButton *)button
{
    NSLog(@"button:%@",button.post_id);
    CommentViewController *commentVC = [[CommentViewController alloc]init];
    commentVC.post_id = button.post_id;
    [commentVC setHidesBottomBarWhenPushed:YES];
    [self.viewController.navigationController pushViewController:commentVC animated:YES];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
