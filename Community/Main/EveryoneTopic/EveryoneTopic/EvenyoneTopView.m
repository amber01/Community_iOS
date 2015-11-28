//
//  EvenyoneTopView.m
//  Community
//
//  Created by amber on 15/11/21.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "EvenyoneTopView.h"
#import "TopicBlockViewController.h"

@implementation EvenyoneTopView

{
    int imageIndex;
    UIPageControl *pageControl;
    UIScrollView  *btnScrollView;
    NSArray *titleArr;
    NSArray *btnImage;
    NSArray *titleArrOne;
    NSArray *btnImageOne;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageIndex = 0;
        [self initPhotoView:frame];
    }
    return self;
}

- (void)initPhotoView:(CGRect)frame
{
    btnScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, frame.size.height - 50)];
    btnScrollView.showsHorizontalScrollIndicator = NO; //指示器的状态
    btnScrollView.scrollsToTop = YES;  //当滑到最底部的时候，点击状态栏时自动返回到最顶部位置
    btnScrollView.pagingEnabled = YES; //出现一个翻页的效果
    btnScrollView.delegate = self;
    [self addSubview:btnScrollView];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, btnScrollView.frame.size.height - 20, ScreenWidth, 10)];
    pageControl.currentPageIndicatorTintColor = BASE_COLOR;
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#9d9d9d"];
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    
    self.topicHeadView = [[EveryoneTopicHeadView alloc]initWithFrame:CGRectMake(0, btnScrollView.bottom, ScreenWidth, 50)];
    [self addSubview:_topicHeadView];
}

- (void)setupTopButton:(int)page
{
    btnScrollView.contentSize = CGSizeMake(ScreenWidth*page, btnScrollView.frame.size.height);
    titleArr = @[@"同城互动",@"秀自拍",@"百姓话题",@"看资讯",@"聊美食",@"去哪玩",@"谈感情",@"搞笑吧"];
    btnImage = @[@"topic_send_city",@"topic_send_show",@"topic_send_people",@"topic_send_information",@"topic_send_food",@"topic_send_play",@"topic_send_feeling",@"topic_send_funny"];
    CGFloat width = ScreenWidth / 4;
    CGFloat height = 80;
    CGFloat start_x = 0;
    CGFloat start_y = 15;
    start_x -= width;
    for (int i = 0; i < titleArr.count; i ++) {
        if(i == 4) {
            start_x = 0;
            start_y += height;
        } else {
            start_x += width;
        }
        
        UIButton *mineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mineBtn setImage:[UIImage imageNamed:btnImage[i]] forState:UIControlStateNormal];
        mineBtn.frame = CGRectMake(start_x + (width - 45) / 2, start_y, 45, 45);
        [btnScrollView addSubview:mineBtn];
        mineBtn.tag = i + 100;
        [mineBtn addTarget:self action:@selector(onClickPageOne:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *btnTitle = [[UILabel alloc]initWithFrame:CGRectMake(start_x, start_y + height - 33, width, 20)];
        btnTitle.textColor = [UIColor grayColor];
        btnTitle.font = [UIFont systemFontOfSize:14];
        btnTitle.textAlignment = NSTextAlignmentCenter;
        btnTitle.text = titleArr[i];
        [btnScrollView addSubview:btnTitle];
    }
    
    /**
     *  第二页按钮
     */
    titleArrOne = @[@"育儿经",@"爱健康",@"灌水区",@"供求信息",@"提建议"];
    btnImageOne = @[@"topic_send_education",@"topic_send_health",@"topic_send_community",@"topic_send_shareinfo",@"topic_send_suggestion"];
    CGFloat width_one = ScreenWidth / 4;
    CGFloat height_one = 80;
    float start_x_one = 0;
    start_x_one -= width_one;
    CGFloat start_y_one = 15;
    
    for (int i = 0; i < titleArrOne.count; i ++) {
        if(i == 4) {
            start_x_one = 0;
            start_y_one += height_one;
        } else {
            start_x_one += width_one;
        }
        
        UIButton *mineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mineBtn setImage:[UIImage imageNamed:btnImageOne[i]] forState:UIControlStateNormal];
        mineBtn.frame = CGRectMake((start_x_one + (width_one - 45) / 2) + ScreenWidth, start_y_one, 45, 45);
        [btnScrollView addSubview:mineBtn];
        [mineBtn addTarget:self action:@selector(onClickPageTwo:) forControlEvents:UIControlEventTouchUpInside];
        mineBtn.tag = i + 200;
        UILabel *btnTitle = [[UILabel alloc]initWithFrame:CGRectMake(start_x_one + ScreenWidth, start_y_one + height_one - 33, width, 20)];
        btnTitle.textColor = [UIColor grayColor];
        btnTitle.font = [UIFont systemFontOfSize:14];
        btnTitle.textAlignment = NSTextAlignmentCenter;
        btnTitle.text = titleArrOne[i];
        [btnScrollView addSubview:btnTitle];
    }
    
    
    pageControl.numberOfPages = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x / ScreenWidth;
    pageControl.currentPage = current;
}

- (void)onClickPageOne:(UIButton *)button{
    int tag = (int)button.tag - 100;
    TopicBlockViewController *topicBlockVC = [[TopicBlockViewController alloc]init];
    switch (tag) {
        case 0:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 1:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 2:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 3:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 4:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];        }
            break;
        case 5:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];        }
            break;
        case 6:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 7:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)onClickPageTwo:(UIButton *)button
{
    TopicBlockViewController *topicBlockVC = [[TopicBlockViewController alloc]init];
    int tag = (int)button.tag - 200;
    switch (tag) {
        case 0:
        {
            topicBlockVC.imageName = btnImageOne[tag];
            topicBlockVC.blockName = titleArrOne[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 1:
        {
            topicBlockVC.imageName = btnImageOne[tag];
            topicBlockVC.blockName = titleArrOne[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 2:
        {
            topicBlockVC.imageName = btnImageOne[tag];
            topicBlockVC.blockName = titleArrOne[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 3:
        {
            topicBlockVC.imageName = btnImageOne[tag];
            topicBlockVC.blockName = titleArrOne[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 4:
        {
            topicBlockVC.imageName = btnImageOne[tag];
            topicBlockVC.blockName = titleArrOne[tag];
            topicBlockVC.cate_id = [NSString stringWithFormat:@"%d",tag + 1];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
