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
        
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSString *cityName;
        
        NSRange foundObj=[sharedInfo.cityarea rangeOfString:@"城区"];  // options:NSCaseInsensitiveSearch
        if(foundObj.length>0){
            cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"城区" withString:@""];
        }else{
            NSRange foundObj2 = [sharedInfo.cityarea rangeOfString:@"县"];
            if (foundObj2.length > 0) {
                cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"县" withString:@""];
            }else{
                NSRange foundObj3 = [sharedInfo.cityarea rangeOfString:@"区"];
                if (foundObj3.length > 0) {
                    cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"区" withString:@""];
                }else{
                    cityName = sharedInfo.cityarea;
                }
            }
        }
        
        NSString *tempCityName = [NSString stringWithFormat:@"%@热点",cityName];
        
        self.backgroundColor = [UIColor whiteColor];
        NSArray *titleArr = @[@"本地散件",@"同城互助",@"秀自拍",@"相亲交友",tempCityName,@"吃货吧",@"去哪玩",@"供求信息",@"男女情感",@"汽车之家",@"健康养生",@"轻松一刻",@"提建议"];
        NSArray *btnImage = @[@"topic_send_community",@"topic_send_city",@"topic_send_show",@"topic_send_people",@"topic_send_information",@"topic_send_food",@"topic_send_play",@"topic_send_shareinfo",@"topic_send_feeling",@"topic_send_education",@"topic_send_health",@"topic_send_funny",@"topic_send_suggestion"];
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
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSString *cityName;
    
    NSRange foundObj=[sharedInfo.cityarea rangeOfString:@"城区"];  // options:NSCaseInsensitiveSearch
    if(foundObj.length>0){
        cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"城区" withString:@""];
    }else{
        NSRange foundObj2 = [sharedInfo.cityarea rangeOfString:@"县"];
        if (foundObj2.length > 0) {
            cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"县" withString:@""];
        }else{
            NSRange foundObj3 = [sharedInfo.cityarea rangeOfString:@"区"];
            if (foundObj3.length > 0) {
                cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"区" withString:@""];
            }else{
                cityName = sharedInfo.cityarea;
            }
        }
    }
    
    NSString *tempCityName = [NSString stringWithFormat:@"%@热点",cityName];
    NSArray *buttonTitles = @[@"本地散件",@"同城互助",@"秀自拍",@"相亲交友",tempCityName,@"吃货吧",@"去哪玩",@"供求信息",@"男女情感",@"汽车之家",@"健康养生",@"轻松一刻",@"提建议"];
    SendTopicViewController *sendTopVC = [[SendTopicViewController alloc]init];
    sendTopVC.title = buttonTitles[button.tag];
    BaseNavigationController *navi =[[BaseNavigationController alloc] initWithRootViewController:sendTopVC];
    [self.window.rootViewController presentViewController:navi animated:YES completion:^{
        
    } ];
    
}

@end
