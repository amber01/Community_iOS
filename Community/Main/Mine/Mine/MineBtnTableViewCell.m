//
//  MineBtnTableViewCell.m
//  Community
//
//  Created by amber on 15/11/15.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MineBtnTableViewCell.h"

@implementation MineBtnTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *titleArr = @[@"积分商城",@"每日签到",@"邀请有奖"];
        NSArray *btnImage = @[@"mine_store_car",@"mine_check_in",@"mine_ rewards"];
        CGFloat width = ScreenWidth / 3;
        float start_x = 0;
        start_x -= width;
        for (int i = 0; i < titleArr.count; i ++) {
            UIButton *mineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [mineBtn addTarget:self action:@selector(clickOn:) forControlEvents:UIControlEventTouchUpInside];
            start_x += width;
            mineBtn.tag = i;
            [mineBtn setImage:[UIImage imageNamed:btnImage[i]] forState:UIControlStateNormal];
            mineBtn.frame = CGRectMake(start_x + (width - 45) / 2, 10, 45, 45);
            [self.contentView addSubview:mineBtn];
            
            UILabel *btnTitle = [[UILabel alloc]initWithFrame:CGRectMake(width * i, mineBtn.bottom + 5, width, 20)];
            btnTitle.textColor = [UIColor blackColor];
            btnTitle.font = [UIFont systemFontOfSize:14];
            btnTitle.textAlignment = NSTextAlignmentCenter;
            btnTitle.text = titleArr[i];
            [self.contentView addSubview:btnTitle];
        }
        
    }
    return self;
}

- (void)clickOn:(UIButton *)button
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    WebDetailViewController *webDetailVC = [[WebDetailViewController alloc]init];
    if (button.tag == 0) {
        webDetailVC.url = [NSString stringWithFormat:@"%@Default.aspx?mobile/mall&UserID=%@",ROOT_URL,sharedInfo.user_id];
        [webDetailVC setHidesBottomBarWhenPushed:YES];
        [self.viewController.navigationController pushViewController:webDetailVC animated:YES];
    }else if (button.tag == 1){
        webDetailVC.url = [NSString stringWithFormat:@"%@Default.aspx?mobile/sign&UserID=%@",ROOT_URL,sharedInfo.user_id];
        [webDetailVC setHidesBottomBarWhenPushed:YES];
        [self.viewController.navigationController pushViewController:webDetailVC animated:YES];
    }else{
        webDetailVC.url = [NSString stringWithFormat:@"%@Default.aspx?mobile/prize&UserID=%@",ROOT_URL,sharedInfo.user_id];
        [webDetailVC setHidesBottomBarWhenPushed:YES];
        [self.viewController.navigationController pushViewController:webDetailVC animated:YES];
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
