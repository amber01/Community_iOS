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
    NSArray *cateArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageIndex = 0;
        [self initPhotoView:frame];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBtnTitle) name:kChangeCityNameNotification object:nil];
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

- (void)changeBtnTitle
{
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
    
    self.currentCityName = [NSString stringWithFormat:@"%@热点",cityName];
    
    UILabel *tempLabel = [self viewWithTag:204];
    tempLabel.text = self.currentCityName;
}

- (void)setupTopButton:(int)page
{
    btnScrollView.contentSize = CGSizeMake(ScreenWidth*page, btnScrollView.frame.size.height);
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
    
    self.currentCityName = [NSString stringWithFormat:@"%@热点",cityName];
    
    titleArr = @[@"本地散件",@"同城互助",@"秀自拍",@"相亲交友",_currentCityName,@"吃货吧",@"去哪玩",@"供求信息"];
    btnImage = @[@"topic_send_community",@"topic_send_city",@"topic_send_show",@"topic_send_people",@"topic_send_information",@"topic_send_food",@"topic_send_play",@"topic_send_shareinfo"];
    cateArray = @[@"11",@"1",@"2",@"3",@"4",@"5",@"6",@"12",@"7",@"9",@"10",@"8",@"13"];
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
        btnTitle.tag = i + 200;
        btnTitle.text = titleArr[i];
        [btnScrollView addSubview:btnTitle];
    }
    
    /**
     *  第二页按钮
     */
    titleArrOne = @[@"男女情感",@"汽车之家",@"健康养生",@"轻松一刻",@"提建议"];
    btnImageOne = @[@"topic_send_feeling",@"topic_send_education",@"topic_send_health",@"topic_send_funny",@"topic_send_suggestion"];
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
        UILabel *twoBtnTitle = [[UILabel alloc]initWithFrame:CGRectMake(start_x_one + ScreenWidth, start_y_one + height_one - 33, width, 20)];
        twoBtnTitle.textColor = [UIColor grayColor];
        twoBtnTitle.font = [UIFont systemFontOfSize:14];
        twoBtnTitle.textAlignment = NSTextAlignmentCenter;
        twoBtnTitle.text = titleArrOne[i];
        [btnScrollView addSubview:twoBtnTitle];
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
            topicBlockVC.cate_id = cateArray[tag];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 1:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = cateArray[tag];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 2:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = cateArray[tag];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 3:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = cateArray[tag];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 4:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = cateArray[tag];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];        }
            break;
        case 5:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = cateArray[tag];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];        }
            break;
        case 6:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = cateArray[tag];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 7:
        {
            topicBlockVC.imageName = btnImage[tag];
            topicBlockVC.blockName = titleArr[tag];
            topicBlockVC.cate_id = cateArray[tag];
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
            topicBlockVC.cate_id = cateArray[tag + 8];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 1:
        {
            topicBlockVC.imageName = btnImageOne[tag];
            topicBlockVC.blockName = titleArrOne[tag];
            topicBlockVC.cate_id = cateArray[tag + 8];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 2:
        {
            topicBlockVC.imageName = btnImageOne[tag];
            topicBlockVC.blockName = titleArrOne[tag];
            topicBlockVC.cate_id = cateArray[tag + 8];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 3:
        {
            topicBlockVC.imageName = btnImageOne[tag];
            topicBlockVC.blockName = titleArrOne[tag];
            topicBlockVC.cate_id = cateArray[tag + 8];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        case 4:
        {
            topicBlockVC.imageName = btnImageOne[tag];
            topicBlockVC.blockName = titleArrOne[tag];
            topicBlockVC.cate_id = cateArray[tag + 8];
            [topicBlockVC setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:topicBlockVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
