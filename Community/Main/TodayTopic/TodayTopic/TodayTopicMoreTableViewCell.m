//
//  TodayTopicMoreTableViewCell.m
//  Community
//
//  Created by amber on 15/11/22.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TodayTopicMoreTableViewCell.h"

@implementation TodayTopicMoreTableViewCell
{
    UIImageView   *imageView1;
    UIImageView   *imageView2;
    UIImageView   *imageView3;
    UILabel       *commentLabel;
    UILabel       *contentLabel;
    UIImageView   *activityImageView;
    UILabel       *sendDateLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, ScreenWidth - 55, 20)];
        contentLabel.text = @"是现代作家朱自清于1925年所写的一篇回忆性散文这篇散文叙述的是作者离开南京到北京大学，父亲送他到浦口车站，照料他上车，并替他买橘子的情形。";
        contentLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:contentLabel];
        
        float imageWidth = (ScreenWidth - 10 - 5 - 5 - 10) / 3;
        
        imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, (contentLabel.bottom+10), imageWidth, 70 * scaleToScreenHeight)];
        imageView1.contentMode = UIViewContentModeScaleAspectFill;
        imageView1.clipsToBounds = YES;
        [self.contentView addSubview:imageView1];
        
        imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView1.right + 5, (contentLabel.bottom+10), imageWidth, 70 * scaleToScreenHeight)];
        imageView2.contentMode = UIViewContentModeScaleAspectFill;
        imageView2.clipsToBounds = YES;
        [self.contentView addSubview:imageView2];
        
        imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView2.right + 5, (contentLabel.bottom+10), imageWidth, 70 * scaleToScreenHeight)];
        imageView3.contentMode = UIViewContentModeScaleAspectFill;
        imageView3.clipsToBounds = YES;
        [self.contentView addSubview:imageView3];
        
        commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, imageView1.bottom + 10, ScreenWidth - 210, 20)];
        commentLabel.textColor = TEXT_COLOR;
        commentLabel.textAlignment = NSTextAlignmentRight;
        commentLabel.font = [UIFont systemFontOfSize:12];
        commentLabel.text = @"232评论";
        
        sendDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(85 + 10, imageView1.bottom + 10, ScreenWidth - 110, 20)];
        sendDateLabel.textAlignment = NSTextAlignmentCenter;
        sendDateLabel.textColor = TEXT_COLOR;
        sendDateLabel.text = @"1小时前";
        sendDateLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:sendDateLabel];
        
        [self.contentView addSubview:commentLabel];
        
        activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(commentLabel.right, 11.5, 20*1.5, 9*1.5)];
        activityImageView.image = [UIImage imageNamed:@"topic_is_activity.png"];
        [self.contentView addSubview:activityImageView];
    }
    return self;
}

- (void)configureCellWithInfo:(TodayTopicModel *)model withImages:(NSArray *)imageArray
{
    contentLabel.text = model.name;
    commentLabel.text = [NSString stringWithFormat:@"%@评论",model.commentnum];
    
    if ([model.isact intValue] == 1) {
        contentLabel.frame = CGRectMake(10, 10, ScreenWidth - 55 - 25, 20);
        commentLabel.frame = CGRectMake(100 - 30 - 5,  imageView1.bottom + 10, ScreenWidth - 110, 20);
        activityImageView.frame = CGRectMake(commentLabel.right + 5, 11.5 , 20*1.5, 9*1.5);
        activityImageView.hidden = NO;
    }else{
        contentLabel.frame = CGRectMake(10, 10, ScreenWidth - 55, 20);
        commentLabel.frame = CGRectMake(100,  imageView1.bottom + 10, ScreenWidth - 110, 20);
        activityImageView.hidden = YES;
    }
    
    if ([model.imagecount intValue] > 1) {
        int k=0;
        for (int i = 0; i < imageArray.count; i ++) {
            TodayTopicImagesModel *imagesModel = [imageArray objectAtIndex:i];
            if ([model.id isEqualToString:imagesModel.postid]) {
                if (k==0) {
                    [imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.picturedomain],BASE_IMAGE_URL,postinfo,imagesModel.picture]]placeholderImage:[UIImage imageNamed:@"default_background_icon"]];
                    k=1;
                }else if (k==1){
                    [imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.picturedomain],BASE_IMAGE_URL,postinfo,imagesModel.picture]]placeholderImage:[UIImage imageNamed:@"default_background_icon"]];
                    k=2;
                }else{
                    [imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",model.picturedomain],BASE_IMAGE_URL,postinfo,imagesModel.picture]]placeholderImage:[UIImage imageNamed:@"default_background_icon"]];
                }
            }
        }
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
