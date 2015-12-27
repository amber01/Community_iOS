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
#import "MineInfoViewController.h"
#import "CheckTopicDetailViewController.h"

@implementation EveryoneTopicTableViewCell
{
    PubliButton         *avatarImageView;
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;

    MLEmojiLabel        *contentLabel;
    UIImageView         *photoImageBtn1;
    UIImageView         *photoImageBtn2;
    UIImageView         *photoImageBtn3;
    
    UILabel             *commentLabel;
    UILabel             *fromLabel;
    
    PubliButton         *commentBtn;
    
    float               firstImageHeight;
    float               firstImageWidth;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        avatarImageView = [[PubliButton alloc]initWithFrame:CGRectMake(15, 15, 45, 45)];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:45/2];
        
        nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, 18, ScreenWidth - avatarImageView.width - 40, 20)];
        nicknameLabel.font = [UIFont systemFontOfSize:14];
        nicknameLabel.text = @"盛夏光年";
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, nicknameLabel.bottom+2, ScreenWidth - avatarImageView.width - 40, 20)];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.text = @"今天 12:23 iPhone6";
        
        
        contentLabel = [[MLEmojiLabel alloc]initWithFrame:CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, 20)];
        [contentLabel verticalUpAlignmentWithText: @"说的方法第三方水电费水电费水电费说的方法第三方第三方第三方的说法是法师打发" maxHeight:10];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        contentLabel.isNeedAtAndPoundSign = YES;
        contentLabel.delegate = self;
        contentLabel.backgroundColor = [UIColor clearColor];
        [contentLabel setFont:[UIFont systemFontOfSize:15]];
        
        photoImageBtn1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, contentLabel.bottom + 15, 80, 80)];
        UITapGestureRecognizer *fristPhotoTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPhotoBrowseOne:)];
        fristPhotoTapGesture.cancelsTouchesInView = YES;
        fristPhotoTapGesture.delegate = self;
        photoImageBtn1.userInteractionEnabled = YES;
        [photoImageBtn1 setContentMode:UIViewContentModeScaleAspectFill]; //居中截取，长宽等比
        photoImageBtn1.clipsToBounds  = YES; //需要设置为YES
        [photoImageBtn1 addGestureRecognizer:fristPhotoTapGesture];
        
        photoImageBtn2 = [[UIImageView alloc]initWithFrame:CGRectMake(photoImageBtn1.right + 7, contentLabel.bottom + 15, 80, 80)];
        [photoImageBtn2 setContentMode:UIViewContentModeScaleAspectFill]; //居中截取，长宽等比
        photoImageBtn2.clipsToBounds  = YES; //需要设置为YES
        photoImageBtn2.userInteractionEnabled = YES;
        UITapGestureRecognizer *secondPhotoTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPhotoBrowseTwo:)];
        secondPhotoTapGesture.cancelsTouchesInView = YES;
        secondPhotoTapGesture.delegate = self;
        [photoImageBtn2 addGestureRecognizer:secondPhotoTapGesture];
        
        photoImageBtn3 = [[UIImageView alloc]initWithFrame:CGRectMake(photoImageBtn2.right + 7, contentLabel.bottom + 15, 80, 80)];
        [photoImageBtn3 setContentMode:UIViewContentModeScaleAspectFill]; //居中截取，长宽等比
        photoImageBtn3.clipsToBounds  = YES; //需要设置为YES
        photoImageBtn3.userInteractionEnabled = YES;
        UITapGestureRecognizer *lastPhotoTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPhotoBrowseThree:)];
        lastPhotoTapGesture.cancelsTouchesInView = YES;
        lastPhotoTapGesture.delegate = self;
        [photoImageBtn3 addGestureRecognizer:lastPhotoTapGesture];
        
        
        self.likeBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.frame = CGRectMake(0, photoImageBtn1.bottom + 15, 34, 26);
        _likeBtn.backgroundColor = [UIColor whiteColor];
        self.likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 26/2 - 13, 34/2, 26/2)];
        _likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
        _likeImageView.userInteractionEnabled = YES;
        [_likeBtn addSubview:_likeImageView];
        
        self.likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_likeImageView.right + 5,-2, 70, 20)];
        _likeLabel.textColor = [UIColor grayColor];
        _likeLabel.font = [UIFont systemFontOfSize:10];
        _likeLabel.text = @"顶 232";
        [_likeBtn addSubview:_likeLabel];
        
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
        [self.contentView addSubview:_likeBtn];
        
        [self.contentView addSubview:photoImageBtn1];
        [self.contentView addSubview:photoImageBtn2];
        [self.contentView addSubview:photoImageBtn3];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:contentLabel];
        [self.contentView addSubview:nicknameLabel];
        [self.contentView addSubview:avatarImageView];
        
    }
    return self;
}

- (void)configureCellWithInfo:(EveryoneTopicModel *)model withImages:(NSArray *)imageArray andPraiseData:(NSArray *)praiseArray andRow:(NSInteger )row
{
    [avatarImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.logopicturedomain],BASE_IMAGE_URL,face,model.logopicture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    nicknameLabel.text = model.nickname;
    
    dateLabel.text = [NSString stringWithFormat:@"%@ %@",model.createtime,model.source];
    
    /**
     *  获取是否点赞过的数据状态
     */
    if (!isArrEmpty(praiseArray)) {
        NSDictionary *dic = praiseArray[row];
        NSString *post_id = [dic objectForKey:@"postid"];
        NSString *isPraise = [dic objectForKey:@"value"];
        
        if ([post_id intValue] == [model.id intValue]) {
            if ([isPraise intValue] == 1) {
                _likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
            }else{
                _likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
            }
        }
    }
    
    
    /**
     *  动态计算内容高度
     */
    NSString *titleStr = isStrEmpty(model.name) ? @"" : [NSString stringWithFormat:@"【%@】",model.name];
    contentLabel.text = [NSString stringWithFormat:@"%@%@",titleStr,model.detail];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize contentHeight = [contentLabel.text boundingRectWithSize:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
//    if (contentLabel.text.length == 0) {
//        contentHeight.height = 0;
//    }
    
    commentBtn.post_id = model.id;
    commentBtn.user_id = model.userid;
    avatarImageView.user_id = model.userid;
    avatarImageView.nickname = model.nickname;
    avatarImageView.userName = model.username;
    avatarImageView.avatarUrl = model.logopicture;
    [avatarImageView addTarget:self action:@selector(checkUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    contentLabel.frame = CGRectMake(15, avatarImageView.bottom + 10, ScreenWidth - 30, contentHeight.height);
    
    /**
     *  创建图片
     */
    if (self.photoUrlArray) {
        [self.photoUrlArray removeAllObjects];
    }
    
    
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
                
                NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",imagesModel.picturedomain],BASE_IMAGE_URL,BigImage,imagesModel.picture];
                if (k==0) {
                    if (!isStrEmpty(imagesModel.picture)) {
                        
                        [photoImageBtn1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",imagesModel.picturedomain],BASE_IMAGE_URL,postinfo,imagesModel.picture]] placeholderImage:[UIImage imageNamed:@"default_background"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image) {
                                firstImageWidth = image.size.width;
                                firstImageHeight = image.size.height;
                            }else{
                                firstImageHeight = 80;
                            }
                        }];
                        [self.photoUrlArray addObject:imageURL];
                    }
                    k=1;
                }else if (k==1){
                    if (!isStrEmpty(imagesModel.picture)) {
                        
                        [photoImageBtn2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",imagesModel.picturedomain],BASE_IMAGE_URL,postinfo,imagesModel.picture]]placeholderImage:[UIImage imageNamed:@"default_background"]];
                        
                        //[photoImageBtn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.logopicturedomain],BASE_IMAGE_URL,postinfo,imagesModel.picture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_background"]];
                        [self.photoUrlArray addObject:imageURL];
                    }
                    k=2;
                }else if (k == 2){
                    if (!isStrEmpty(imagesModel.picture)) {
                        [photoImageBtn3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",imagesModel.picturedomain],BASE_IMAGE_URL,postinfo,imagesModel.picture]]placeholderImage:[UIImage imageNamed:@"default_background"]];
                        [self.photoUrlArray addObject:imageURL];
                    }
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
                [self showPhotoImage:self.photoUrlArray withTag:row];
            }else{
            }
        }
        if (self.photoUrlArray.count == 2) {
            photoImageBtn3.hidden = YES;
        }else if (self.photoUrlArray.count == 1){
            photoImageBtn1.frame = CGRectMake(15, contentLabel.bottom + 12, firstImageWidth, firstImageHeight);
            
            photoImageBtn2.hidden = YES;
            photoImageBtn3.hidden = YES;
        }
    }else{
        photoImageBtn1.hidden = YES;
        photoImageBtn2.hidden = YES;
        photoImageBtn3.hidden = YES;
        imageHeight = contentLabel.bottom;
    }
    
    commentLabel.text = [NSString stringWithFormat:@"评论%@",model.commentnum];
    
    fromLabel.text = model.classname;
    
    
    if (self.photoUrlArray.count == 1) {
        _likeBtn.frame = CGRectMake(0, imageHeight + 10 - 78 + firstImageHeight, 90, 26);
        commentBtn.frame = CGRectMake(35 + 40, imageHeight + 10 - 78 + firstImageHeight, 100, 30);
        fromLabel.frame = CGRectMake(100, imageHeight + 8 - 78 + firstImageHeight, ScreenWidth - 100 - 15, 20);
        self.frame = CGRectMake(0, 0, ScreenWidth,avatarImageView.height + imageHeight - 10 - 78 + firstImageHeight);
    }else{
        _likeBtn.frame = CGRectMake(0, imageHeight + 10, 90, 26);
        commentBtn.frame = CGRectMake(35 + 40, imageHeight + 10, 100, 30);
        fromLabel.frame = CGRectMake(100, imageHeight + 8, ScreenWidth - 100 - 15, 20);
        self.frame = CGRectMake(0, 0, ScreenWidth,avatarImageView.height + imageHeight - 10);
    }
}

#pragma mark - photobrowser代理方法
- (void)showPhotoBrowseOne:(UITapGestureRecognizer *)tapGesture
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.imageCount = self.photoUrlArray.count; //图片总数
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];
}

- (void)showPhotoBrowseTwo:(UITapGestureRecognizer *)tapGesture
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

- (void)showPhotoBrowseThree:(UITapGestureRecognizer *)tapGesture
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

- (void)showPhotoImage:(NSMutableArray *)photoArray withTag:(NSInteger)row
{
    //NSLog(@"photo array:%@",photoArray);
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.photoUrlArray[index];
    return [NSURL URLWithString:urlStr];
}

#pragma mark -- action
- (void)commentAction:(PubliButton *)button
{
    NSLog(@"button:%@",button.post_id);
    CommentViewController *commentVC = [[CommentViewController alloc]init];
    commentVC.post_id = button.post_id;
    commentVC.user_id = button.user_id;
    [commentVC setHidesBottomBarWhenPushed:YES];
    [self.viewController.navigationController pushViewController:commentVC animated:YES];
}

- (void)checkUserInfo:(PubliButton *)button
{
    MineInfoViewController *userInfoVC = [[MineInfoViewController alloc]init];
    userInfoVC.user_id = button.user_id;
    userInfoVC.nickname = button.nickname;
    userInfoVC.userName = button.userName;
    userInfoVC.avatarUrl = button.avatarUrl;
    [userInfoVC setHidesBottomBarWhenPushed:YES];
    [self.viewController.navigationController pushViewController:userInfoVC animated:YES];
    NSLog(@"user_id:%@",button.user_id);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark -- MLEmojiLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
        {
            CheckTopicDetailViewController *checkTopicDetailVC = [[CheckTopicDetailViewController alloc]init];
            checkTopicDetailVC.keyword = [link stringByReplacingOccurrencesOfString:@"#" withString:@""];
            [self.viewController.navigationController pushViewController:checkTopicDetailVC animated:YES];
        }
            NSLog(@"点击了话题%@",link);
            break;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
