//
//  SendTopicBtnView.m
//  Community
//
//  Created by shlity on 15/11/10.
//  Copyright © 2015年 shlity. All rights reserved.
//

#define Start_X 15.0f* scaleToScreenHeight           // 第一个按钮的X坐标
#define Start_Y 130.0f* scaleToScreenHeight           // 第一个按钮的Y坐标
#define Width_Space 30.0f* scaleToScreenHeight        // 2个按钮之间的横间距
#define Height_Space 35.0f* scaleToScreenHeight       // 竖间距

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
        
        UILabel *tiplsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Start_Y/2 + 20, ScreenWidth, 20)];
        tiplsLabel.textAlignment = NSTextAlignmentCenter;
        tiplsLabel.text = @"请选择板块";
        [self addSubview:tiplsLabel];
        
        self.backgroundColor = [UIColor colorWithHexString:@"#f1ecec" alpha:0.95];
        float Button_Height =  50 * scaleToScreenHeight;  // 高
        float Button_Width  =  50 * scaleToScreenHeight;   // 宽
        
        NSArray *buttonTitles = @[@"同城互动", @"秀自拍", @"百姓话题", @"看资讯", @"聊美食", @"去哪玩",@"谈感情", @"搞笑吧", @"育儿经", @"爱健康", @"灌小区", @"供求信息",@"提建议"];
        NSArray *buttonImages = @[@"send_btn", @"send_btn", @"send_btn", @"send_btn", @"send_btn", @"send_btn",@"send_btn", @"send_btn", @"send_btn", @"send_btn", @"send_btn", @"send_btn",@"send_btn"];
        for (int i = 0; i < buttonImages.count; i ++) {
            NSInteger index = i % 4;
            NSInteger page = i / 4;
            
            UIButton *sendTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendTopicBtn setBackgroundImage:[UIImage imageNamed:buttonImages[i]] forState:UIControlStateNormal];
            sendTopicBtn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
            sendTopicBtn.tag = i;
            [sendTopicBtn addTarget:self action:@selector(clickSendTopicAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *btnTitleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X-5* scaleToScreenHeight,sendTopicBtn.bottom, Button_Width+10* scaleToScreenHeight, 20)];
            btnTitleLabel.textColor = [UIColor grayColor];
            btnTitleLabel.text = buttonTitles [i];
            btnTitleLabel.textAlignment = NSTextAlignmentCenter;
            btnTitleLabel.font = [UIFont systemFontOfSize:13];
            
            [self addSubview:sendTopicBtn];
            [self addSubview:btnTitleLabel];
        }
        
        UIImageView *btnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-20, ScreenHeight - 45, 40, 40)];
        btnImageView.image = [UIImage imageNamed:@"send_close_btn.png"];
        [self addSubview:btnImageView];
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
