//
//  SendTopicBtnView.m
//  Community
//
//  Created by shlity on 15/11/10.
//  Copyright © 2015年 shlity. All rights reserved.
//


#import "SendTopicBtnView.h"
#import "SendTopicViewController.h"

@implementation SendTopicBtnView
{
    NSMutableArray *_optionButtons;
    UIDynamicAnimator *_animator;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *titleArr = @[@"同城互动", @"秀自拍", @"百姓话题", @"看资讯", @"聊美食", @"去哪玩",@"谈感情", @"搞笑吧", @"育儿经", @"爱健康", @"灌小区", @"供求信息",@"提建议"];
        NSArray *btnImage = @[@"topic_send_city",@"topic_send_show",@"topic_send_people",@"topic_send_information",@"topic_send_food",@"topic_send_play",@"topic_send_feeling",@"topic_send_funny",@"topic_send_education",@"topic_send_health",@"topic_send_community",@"topic_send_shareinfo",@"topic_send_suggestion"];
        CGFloat width = ScreenWidth / 4;
        CGFloat height = 80;
        CGFloat start_x = 0;
        CGFloat start_y = 15;
        start_x -= width;
        for (int i = 0; i < titleArr.count; i ++) {
            if(i == 4 | i == 8 | i == 12) {
                start_x = 0;
                start_y += height;
            } else {
                start_x += width;
            }
            
            self.mineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_mineBtn setImage:[UIImage imageNamed:btnImage[i]] forState:UIControlStateNormal];
            _mineBtn.frame = CGRectMake(start_x + (width - 40) / 2, start_y, 40, 40);
            [self addSubview:_mineBtn];
            _mineBtn.tag = i + 100;
            UILabel *btnTitle = [[UILabel alloc]initWithFrame:CGRectMake(start_x, start_y + height - 33, width, 20)];
            btnTitle.textColor = [UIColor grayColor];
            btnTitle.font = [UIFont systemFontOfSize:14];
            btnTitle.textAlignment = NSTextAlignmentCenter;
            btnTitle.text = titleArr[i];
            [self addSubview:btnTitle];
        }
    }
    return self;
}

- (void)clickSendTopicAction:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kHideSendTopicNotification object:nil];
    NSArray *buttonTitles = @[@"同城互动", @"秀自拍", @"百姓话题", @"看资讯", @"聊美食", @"去哪玩",@"谈感情", @"搞笑吧", @"育儿经", @"爱健康", @"灌小区", @"供求信息",@"提建议"];
    SendTopicViewController *sendTopVC = [[SendTopicViewController alloc]init];
    sendTopVC.title = buttonTitles[button.tag];
    BaseNavigationController *navi =[[BaseNavigationController alloc] initWithRootViewController:sendTopVC];
    [self.window.rootViewController presentViewController:navi animated:YES completion:^{
        
    } ];
    
}

@end
