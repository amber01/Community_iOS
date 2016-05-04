//
//  DiscoverTableViewCell.m
//  Community
//
//  Created by shlity on 16/4/7.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import "CheckTopicDetailViewController.h"
#import "CommentViewController.h"
#import "MineInfoViewController.h"

#define Start_X 10.0f           // 第一个按钮的X坐标
#define Start_Y 50.0f           // 第一个按钮的Y坐标
#define Width_Space 5.0f        // 2个按钮之间的横间距
#define Height_Space 5.0f      // 竖间距


@implementation DiscoverTableViewCell
{
    PubliButton         *avatarImageView;
    UILabel             *nicknameLabel;
    UILabel             *dateLabel;
    
    UIImageView         *activityImageView;
    
    UILabel             *commentLabel;
    
    PubliButton         *commentBtn;
    NSArray             *imageArray;
    
    float               firstImageHeight;
    float               firstImageWidth;
    
    float               Button_Height; //高
    float               Button_Width;  //宽
    UIImageView         *imageView;
    UIButton            *shareBtn;
    
    UILabel             *prestigeLabel;  //声望
    NSMutableArray      *bmiddleArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        avatarImageView = [[PubliButton alloc]initWithFrame:CGRectMake(20, 15, 45, 45)];
        [avatarImageView addTarget:self action:@selector(checkUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        [UIUtils setupViewRadius:avatarImageView cornerRadius:45/2];

        nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, 18, ScreenWidth - avatarImageView.width - 40, 20)];
        nicknameLabel.textColor = [UIColor grayColor];
        nicknameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        nicknameLabel.text = @"盛夏光年";
        
        prestigeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nicknameLabel.right + 10, nicknameLabel.top + 2, 32, 16)];
        prestigeLabel.textAlignment = NSTextAlignmentCenter;
        prestigeLabel.textColor = [UIColor whiteColor];
        prestigeLabel.backgroundColor = [UIColor colorWithHexString:@"#f5a623"];
        [UIUtils setupViewRadius:prestigeLabel cornerRadius:3];
        prestigeLabel.font = kFont(12);
        //prestigeLabel.text = @"v1";
        [self.contentView addSubview:prestigeLabel];
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right+10, nicknameLabel.bottom+2, ScreenWidth - avatarImageView.width - 40, 20)];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.text = @"今天 12:23 iPhone6";
        
        activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(dateLabel.right, nicknameLabel.bottom+2, 20*1.5, 9*1.5)];
        activityImageView.image = [UIImage imageNamed:@"topic_is_activity.png"];
        [self.contentView addSubview:activityImageView];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImageView.right + 10, avatarImageView.bottom + 5, ScreenWidth - avatarImageView.width - 20 - 10 - 15, 20)];
        [_contentLabel verticalUpAlignmentWithText: @"说的方法第三方水电费水电费水电费说的方法第三方第三方第三方的说法是法师打发" maxHeight:10];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
        [_contentLabel setFont:[UIFont systemFontOfSize:15]];
        
        
        self.likeBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        //_likeBtn.frame = CGRectMake(0, photoImageBtn1.bottom + 15, 34, 26);
        _likeBtn.backgroundColor = [UIColor whiteColor];
        self.likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28/2, 28/2)];
        _likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
        _likeImageView.userInteractionEnabled = NO;
        [_likeBtn addSubview:_likeImageView];
        
        self.likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_likeImageView.right + 5,-2, 70, 20)];
        _likeLabel.textColor = [UIColor grayColor];
        _likeLabel.font = [UIFont systemFontOfSize:10];
        _likeLabel.text = @"顶 232";
        [_likeBtn addSubview:_likeLabel];
        
        commentBtn = [PubliButton buttonWithType:UIButtonTypeCustom];
        //commentBtn.frame = CGRectMake(35 + 55, photoImageBtn1.bottom + 15, 90, 30);
        commentBtn.backgroundColor = [UIColor whiteColor];
        [commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 26/2 - 13, 14, 14)];
        commentImageView.userInteractionEnabled = NO;
        commentImageView.image = [UIImage imageNamed:@"everyone_topic_comment"];
        [commentBtn addSubview:commentImageView];
        
        Button_Width = ((ScreenWidth - avatarImageView.width - 20 - 10 - 15)/3)-5;
        Button_Height = Button_Width;
        
        commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentImageView.right + 5, -2, 100, 20)];
        commentLabel.textColor = [UIColor grayColor];
        commentLabel.font = [UIFont systemFontOfSize:10];
        commentLabel.text = @"评论 234";
        [commentBtn addSubview:commentLabel];
        
        shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"discover_item_shared"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:shareBtn];
        [self.contentView addSubview:commentBtn];
        [self.contentView addSubview:_likeBtn];
        
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:_contentLabel];
        [self.contentView addSubview:nicknameLabel];
        [self.contentView addSubview:avatarImageView];
    }
    return self;
}

- (void)configureCellWithInfo:(FriendSquareModel*)model
{
    [avatarImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.logopicturedomain],BASE_IMAGE_URL,face,model.logopicture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    nicknameLabel.text = model.nickname;
    CGSize nickNameWidth = [nicknameLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGRect textFrame = prestigeLabel.frame;
    textFrame.origin.x = avatarImageView.right+10 + nickNameWidth.width + 10;
    prestigeLabel.frame = textFrame;
    prestigeLabel.text = [NSString stringWithFormat:@"v%@",model.prestige];
    
    commentBtn.post_id = model.id;
    commentBtn.user_id = model.userid;
    commentLabel.text = model.commentnum;
    
    avatarImageView.user_id = model.userid;
    avatarImageView.nickname = model.nickname;
    avatarImageView.userName = model.username;
    avatarImageView.avatarUrl = model.logopicture;
    
    NSString *deteString  = [NSString stringWithFormat:@"%@  #%@#",[UIUtils format:model.createtime],model.classname];
    dateLabel.text = deteString;
    CGSize textWith = [deteString sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if ([model.isact intValue] == 1) {
        activityImageView.hidden = NO;
        activityImageView.frame = CGRectMake(avatarImageView.right+10 + textWith.width + 5, nicknameLabel.bottom+6, 20*1.5, 9*1.5);
    }else{
        activityImageView.hidden = YES;
    }
    
    /**
     *  动态计算内容高度
     */
    _contentLabel.text = model.describe;

    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize contentHeight = [_contentLabel.text boundingRectWithSize:CGSizeMake(_contentLabel.frame.size.width, MAXFLOAT) options:  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    if (model.describe.length == 0) {
        contentHeight.height = 0;
    }
    
    /**
     *  是否点赞
     */
    if ([model.ispraise intValue] == 1) {
        _likeImageView.image = [UIImage imageNamed:@"everyone_topic_cancel_like"];
    }else{
        _likeImageView.image = [UIImage imageNamed:@"everyone_topic_like"];
    }
    
    CGRect frame = _contentLabel.frame;
    frame.size.height = contentHeight.height;
    _contentLabel.frame = frame;
    //imageArray = nil;
    imageArray = [model.images componentsSeparatedByString:@","];
    
    for (int i = 200; i <= 209; i ++) {
        UIImageView *tempImageView = [self.contentView viewWithTag:i];
        [tempImageView removeFromSuperview];
    }
    
    /**
     *  当只有一张图片的情况下就根据图片的实际尺寸来展示
     */
    if (imageArray.count == 1) {
        float tempWidth;
        float tempHeight;
        if ([model.width intValue] >= _contentLabel.width) {
            CGFloat tempImageWith = _contentLabel.width / [model.width floatValue];
            tempWidth = _contentLabel.width;
            tempHeight = ([model.height floatValue]) * tempImageWith;
        }else{
            tempWidth = [model.width intValue];
            tempHeight = [model.height intValue];
        }
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(avatarImageView.right + 10, _contentLabel.bottom + 5, tempWidth, tempHeight)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 200;
        
        UITapGestureRecognizer *secondPhotoTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPhotoBrowse:)];
        secondPhotoTapGesture.cancelsTouchesInView = YES;
        secondPhotoTapGesture.delegate = self;
        [imageView addGestureRecognizer:secondPhotoTapGesture];

        
        NSLog(@"images frame:%f",imageView.frame.size.height);
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray lastObject]] placeholderImage:[UIImage imageNamed:@"default_background"]];
        [self.contentView addSubview:imageView];
    }else{
        for (int i = 0 ; i < imageArray.count; i++) {
            
            NSInteger index = i % 3;
            NSInteger page = i / 3;
            
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + avatarImageView.right + 10, page  * (Button_Height + Height_Space)+_contentLabel.bottom + 5, Button_Width, Button_Height)];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            imageView.tag = i + 200;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"default_background"]];
            UITapGestureRecognizer *secondPhotoTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPhotoBrowse:)];
            secondPhotoTapGesture.cancelsTouchesInView = YES;
            secondPhotoTapGesture.delegate = self;
            [imageView addGestureRecognizer:secondPhotoTapGesture];
            [self.contentView addSubview:imageView];
        }
    }
    
    _likeBtn.frame = CGRectMake(_contentLabel.left, imageView.bottom + 15,50, 30);
    commentBtn.frame = CGRectMake(_likeBtn.right, imageView.bottom + 15, 50, 30);
    shareBtn.frame = CGRectMake(commentBtn.right + 40, imageView.bottom + 15, 14, 14);
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



- (void)showPhotoBrowse:(UITapGestureRecognizer *)tapGesture
{
    
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = self.contentView;
    browserVc.imageCount = imageArray.count;
    
    [bmiddleArray removeAllObjects];
    for (int i = 0; i < imageArray.count; i++) {
        NSString *str = [imageArray objectAtIndex:i];
        NSString *urlStr = [str stringByReplacingOccurrencesOfString:@"/small" withString:@"/big"];
        if (!bmiddleArray) {
            bmiddleArray = [NSMutableArray new];
        }
        [bmiddleArray addObject:urlStr];
    }
    
    int tag = (int)([tapGesture view].tag) - 200;
    
    NSLog(@"tags:%d",tag);
    
    browserVc.currentImageIndex = tag;
    // 代理
    browserVc.delegate = self;
    // 展示图片浏览器
    [browserVc show];
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

#pragma mark - photobrowser代理方法
//临时占位图（thumbnail图）
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *tempImageView = [self.contentView viewWithTag:index + 200];
    return tempImageView.image;
}
//高清原图 （bmiddle图）
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = bmiddleArray[index];
    return [NSURL URLWithString:urlStr];
}

#pragma mark -- other
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
