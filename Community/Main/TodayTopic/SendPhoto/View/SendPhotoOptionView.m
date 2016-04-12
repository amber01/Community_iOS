//
//  SendPhotoOptionView.m
//  Community
//
//  Created by shlity on 16/4/12.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "SendPhotoOptionView.h"

@implementation SendPhotoOptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotoBtn.frame = CGRectMake(20, 5, 40, 40);
        [_addPhotoBtn setImage:[UIImage imageNamed:@"topic_select_photo.png"] forState:UIControlStateNormal];
        [self addSubview:_addPhotoBtn];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _addPhotoBtn.bottom + 10, ScreenWidth, 40)];
        view.backgroundColor = VIEW_COLOR;
        UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, view.height)];
        tipsLabel.text = @"选择话题";
        tipsLabel.font = kFont(15);
        [view addSubview:tipsLabel];
        [self addSubview:view];
        
        NSArray *topicArray = @[@"所有话题",@"我关注的话题",@"未关注的话题"];
        for (int i = 0; i < topicArray.count; i ++) {
            self.checkTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _checkTopicBtn.frame = CGRectMake(i * (ScreenWidth / 3), view.bottom, ScreenWidth/3, 40);
            [_checkTopicBtn setTitle:topicArray[i] forState:UIControlStateNormal];
            _checkTopicBtn.titleLabel.font = kFont(16);
            _checkTopicBtn.tag = 200 + i;
            [CommonClass setBorderWithView:_checkTopicBtn top:NO left:NO bottom:YES right:NO borderColor:CELL_COLOR borderWidth:0.5];
            if (i == 0) {
                [_checkTopicBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
            }else{
                [_checkTopicBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            }
            
            [self addSubview:_checkTopicBtn];
        }
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, view.bottom + 40 - 2.5, ScreenWidth/3, 2)];
        _lineView.backgroundColor = BASE_COLOR;
        [self addSubview:_lineView];
    }
    return self;
}

@end
