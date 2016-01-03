//
//  TopicBlockTopView.m
//  Community
//
//  Created by amber on 15/11/28.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicBlockTopView.h"
#import "EveryoneTopicHeadView.h"
#import "TopicBlockViewController.h"

@implementation TopicBlockTopView
{
    UIImageView *topicImageView;
    UILabel     *subLabel;
}

- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName wihtIsShowSubView:(BOOL)isSubView
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSubCateData:) name:@"SubCateDataNotification" object:nil];
        topicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 45, 45)];
        topicImageView.image = [UIImage imageNamed:imageName];
        [self addSubview:topicImageView];
        
        self.blockNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(topicImageView.right + 10, 17, ScreenWidth - topicImageView.width + 20 + 50, 20)];
        
        self.topicNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(topicImageView.right + 10, _blockNameLabel.bottom + 5, (ScreenWidth - topicImageView.width - 20)/2, 20)];
        _topicNumberLabel.textColor = [UIColor grayColor];
        _topicNumberLabel.font = [UIFont systemFontOfSize:15];
        _topicNumberLabel.text = @"总帖数：0";
        
        self.todayNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_topicNumberLabel.right + 15, _blockNameLabel.bottom + 5, (ScreenWidth - topicImageView.width - 20)/2, 20)];
        _todayNumberLabel.textColor = [UIColor grayColor];
        _todayNumberLabel.font = [UIFont systemFontOfSize:15];
        _todayNumberLabel.text = @"今日：0";
        
        //有子模块的情况下
        if (isSubView) {
            subLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _todayNumberLabel.bottom + 15, 65, 20)];
            subLabel.textColor = [UIColor grayColor];
            subLabel.text = @"子版块：";
            subLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:subLabel];
            self.topicHeadView = [[EveryoneTopicHeadView alloc]initWithFrame:CGRectMake(0, subLabel.bottom + 30, ScreenWidth, 10)];

        }else{
            self.topicHeadView = [[EveryoneTopicHeadView alloc]initWithFrame:CGRectMake(0, 45+15+15, ScreenWidth, 10)];
        }
        
        [self addSubview:_blockNameLabel];
        [self addSubview:_todayNumberLabel];
        [self addSubview:_topicNumberLabel];
        [self addSubview:_topicHeadView];
        
    }
    return self;
}

- (void)setTopImageIcon:(NSString *)imageName withIsShowSubView:(BOOL)isSubView
{
    topicImageView.image = [UIImage imageNamed:imageName];
    if (isSubView) {
        subLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _todayNumberLabel.bottom + 15, 65, 20)];
        subLabel.textColor = [UIColor grayColor];
        subLabel.text = @"子版块：";
        subLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:subLabel];
        subLabel.hidden = NO;
        self.tagList.hidden = NO;
        if (_tagList) {
            _tagList.frame = CGRectMake(subLabel.right, subLabel.top, ScreenWidth - subLabel.width - 20, 40);
        }
        self.topicHeadView.frame = CGRectMake(0, subLabel.bottom + 30, ScreenWidth, 10);
    }else{
        subLabel.hidden = YES;
        self.tagList.hidden = YES;
        self.topicHeadView.frame = CGRectMake(0, 45+15+15, ScreenWidth, 10);
    }
}

- (void)getSubCateData:(NSNotification *)notifi
{
    self.dataArray = [notifi object];
    //[_dataArray removeAllObjects];
    NSLog(@"dataArray:%ld",_dataArray.count);
    
    for (int i = 0 ; i < self.dataArray.count; i ++) {
        NSDictionary *dic = [self.dataArray objectAtIndex:i];
        NSString *titleName = [dic objectForKey:@"name"];
        if (!self.titleArray) {
            self.titleArray = [NSMutableArray new];
        }
        [self.titleArray addObject:titleName];
    }
    
    if (!_tagList) {
        _tagList = [[DWTagList alloc]initWithFrame:CGRectMake(subLabel.right, subLabel.top, ScreenWidth - subLabel.width - 20, 40)];
        [self addSubview:_tagList];
        
        [_tagList setAutomaticResize:YES];
        [_tagList setTags:self.titleArray];
        [_tagList setTagDelegate:self];
    }
}

#pragma mark -- DWTagListDelegate
- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex
{
    NSDictionary *dic = self.dataArray[tagIndex];
    NSString *cate_id = [dic objectForKey:@"id"];
    
    TopicBlockViewController *topicBlockVC = [[TopicBlockViewController alloc]init];
    topicBlockVC.imageName = @"topic_send_shareinfo"; //图片就用父模块的图片（供求信息）
    topicBlockVC.blockName = tagName;
    topicBlockVC.cate_id = cate_id;
    topicBlockVC.ishasSubView = YES;
    [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
    NSLog(@"cate_id:%@",cate_id);
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
