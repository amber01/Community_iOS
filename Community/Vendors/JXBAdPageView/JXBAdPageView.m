//
//  JXBAdPageView.m
//  XBAdPageView
//
//  Created by Peter Jin mail:i@Jxb.name on 15/5/13.
//  Github ---- https://github.com/JxbSir
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "JXBAdPageView.h"

@interface JXBAdPageView()<UIScrollViewDelegate>
@property (nonatomic,assign) int               indexShow;
@property (nonatomic,copy  ) NSArray           *arrImage;
@property (nonatomic,strong) UIScrollView      *scView;
@property (nonatomic,strong) UIImageView       *imgPrev;
@property (nonatomic,strong) UIImageView       *imgCurrent;
@property (nonatomic,strong) UIImageView       *imgNext;
@property (nonatomic,strong) JXBAdPageCallback myBlock;

@property (nonatomic,strong) NSArray           *titleArray;

@end

@implementation JXBAdPageView
@synthesize myBlock;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initUI];
}

- (void)initUI {
    _scView = [[UIScrollView alloc] initWithFrame:self.frame];
    _scView.delegate = self;
    _scView.pagingEnabled = YES;
    _scView.bounces = NO;
    _scView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    _scView.showsHorizontalScrollIndicator = NO;
    _scView.showsVerticalScrollIndicator = NO;
    [_scView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self addSubview:_scView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAds)];
    [_scView addGestureRecognizer:tap];
    
    
    _imgPrev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _imgCurrent = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    _imgNext = [[UIImageView alloc] initWithFrame:CGRectMake(2*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    [_scView addSubview:_imgPrev];
    [_scView addSubview:_imgCurrent];
    [_scView addSubview:_imgNext];
    
    UIView *topPageView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 32*scaleToScreenHeight, ScreenWidth, 32*scaleToScreenHeight)];
    [topPageView setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.7]];
    [self addSubview:topPageView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, topPageView.height/2-5, self.frame.size.width, 10)];
    _pageControl.currentPageIndicatorTintColor = BASE_COLOR;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [topPageView addSubview:_pageControl];
    
    self.adTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, topPageView.height/2-10, ScreenWidth - 100, 20)];
    //_adTextLabel.text = @"是的第三方是的范德萨发是的范德萨范德萨水电费水电费多少是的范德萨发";
    _adTextLabel.font = [UIFont systemFontOfSize:15.0];
    _adTextLabel.textColor = [UIColor whiteColor];
    [topPageView addSubview:_adTextLabel];
}

/**
 *  启动函数
 *
 *  @param imageArray 图片数组
 *  @param block      click回调
 */
- (void)startAdsWithBlock:(NSArray*)imageArray block:(JXBAdPageCallback)block {
    if(imageArray.count <= 1)
        _scView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _pageControl.numberOfPages = imageArray.count;
    
    //小圆点靠右显示
    CGSize pointSize =  [_pageControl sizeForNumberOfPages:imageArray.count];
    CGFloat page_x = -(_pageControl.bounds.size.width - pointSize.width) / 2 ;
    [_pageControl setBounds:CGRectMake(page_x+10, _pageControl.bounds.origin.y, _pageControl.bounds.size.width, _pageControl.bounds.size.height)];;
    _arrImage = imageArray;
    self.myBlock = block;
    [self reloadImages];
}

/**
 *  点击广告
 */
- (void)tapAds
{
    if (self.myBlock != NULL) {
        self.myBlock(_indexShow);
    }
    if (_myTimer)
        [_myTimer invalidate];
    if (_iDisplayTime > 0)
        [self startTimerPlay];
}

/**
 *  加载图片顺序
 */
- (void)reloadImages {
    if (_indexShow >= (int)_arrImage.count)
        _indexShow = 0;
    if (_indexShow < 0)
        _indexShow = (int)_arrImage.count - 1;
    int prev = _indexShow - 1;
    if (prev < 0)
        prev = (int)_arrImage.count - 1;
    int next = _indexShow + 1;
    if (next > _arrImage.count - 1)
        next = 0;
    _pageControl.currentPage = _indexShow;
    NSString* prevImage = [_arrImage objectAtIndex:prev];
    NSString* curImage = [_arrImage objectAtIndex:_indexShow];
    NSString* nextImage = [_arrImage objectAtIndex:next];
    if(_bWebImage)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(setWebImage:imgUrl:)])
        {
            [_delegate setWebImage:_imgPrev imgUrl:prevImage];
            [_delegate setWebImage:_imgCurrent imgUrl:curImage];
            [_delegate setWebImage:_imgNext imgUrl:nextImage];
        }
        else
        {
            [_imgPrev sd_setImageWithURL:[NSURL URLWithString:prevImage]placeholderImage:[UIImage imageNamed:@"banner_default_background"]];
            [_imgCurrent sd_setImageWithURL:[NSURL URLWithString:curImage]placeholderImage:[UIImage imageNamed:@"banner_default_background"]];
            [_imgNext sd_setImageWithURL:[NSURL URLWithString:nextImage]placeholderImage:[UIImage imageNamed:@"banner_default_background"]];
        }
    }
    else
    {
        _imgPrev.image = [UIImage imageNamed:prevImage];
        _imgCurrent.image = [UIImage imageNamed:curImage];
        _imgNext.image = [UIImage imageNamed:nextImage];
    }
    [_scView scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
    
    if (_iDisplayTime > 0)
        [self startTimerPlay];
}

/**
 *  切换图片完毕事件
 *
 *  @param scrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_myTimer){
        [_myTimer invalidate];
        _myTimer = nil;//此处需要将定时器只为空,不然会定时器会跑的飞起,轮播速度飞快啊
    }
    if (scrollView.contentOffset.x >=self.frame.size.width)
        _indexShow++;
    else if (scrollView.contentOffset.x < self.frame.size.width)
        _indexShow--;
    [self reloadImages];
    
    NSDictionary *dic = self.titleArray[_indexShow];
    _adTextLabel.text = [dic objectForKey:@"describe"];
}

- (void)startTimerPlay {
    [_myTimer invalidate];
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:_iDisplayTime target:self selector:@selector(doImageGoDisplay) userInfo:nil repeats:NO];
    
    NSDictionary *dic = self.titleArray[_indexShow];
    _adTextLabel.text = [dic objectForKey:@"describe"];
}

/**
 *  获取title
 */
- (void)getCurrentAdData:(NSArray *)adArray
{
    self.titleArray = adArray;
    NSDictionary *dic = self.titleArray[0];
    _adTextLabel.text = [dic objectForKey:@"describe"];
}

/**
 *  轮播图片
 */
- (void)doImageGoDisplay {
    [_scView scrollRectToVisible:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height) animated:YES];
    _indexShow++;
    [self performSelector:@selector(reloadImages) withObject:nil afterDelay:0.3];
}

@end
