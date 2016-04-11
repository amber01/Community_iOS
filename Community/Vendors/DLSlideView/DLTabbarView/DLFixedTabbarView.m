//
//  DLFixedTabbarView.m
//  DLSlideController
//
//  Created by Dongle Su on 14-12-8.
//  Copyright (c) 2014年 dongle. All rights reserved.
//

#import "DLFixedTabbarView.h"
#import "DLUtility.h"

#define kTrackViewHeight 2
#define kImageSpacingX 3.0f

#define kLabelTagBase 1000
#define kImageTagBase 2000
#define kSelectedImageTagBase 3000

@implementation DLFixedTabbarViewTabItem

@end

@implementation DLFixedTabbarView{
    UIScrollView *scrollView_;
    UIImageView *backgroudView_;
    BOOL        isImageTop;
}

- (void)commonInit{
    _selectedIndex = -1;
    
    backgroudView_ = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:backgroudView_];
    
    scrollView_ = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView_];
    
    _trackView_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.tabbarHeight - self.tabbarBottomSpacing+1, self.bounds.size.width, kTrackViewHeight)];
    [self addSubview:_trackView_];
    
    /**
     *  shldy先注释掉
     */
    //trackView_.layer.cornerRadius = 2.0f;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [scrollView_ addGestureRecognizer:tap];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    backgroudView_.image = backgroundImage;
}

- (void)setTrackColor:(UIColor *)trackColor{
    _trackView_.backgroundColor = trackColor;
}

- (void)setTabbarItems:(NSArray *)tabbarItems{
    if (_tabbarItems != tabbarItems) {
        _tabbarItems = tabbarItems;
        
        assert(tabbarItems.count <= 4);
        
        float width = self.bounds.size.width/tabbarItems.count;
        float height = self.bounds.size.height;
        float x = 0.0f;
        NSInteger i=0;
        for (DLFixedTabbarViewTabItem *item in tabbarItems) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width, height)];
            label.text = item.title;
            isImageTop = item.isImageTop;
            label.font = [UIFont systemFontOfSize:15];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = item.titleColor;
            [label sizeToFit];
            label.tag = kLabelTagBase+i;
            
            /**
             *  未选中选中的图片
             */
            UIImageView *imageView = [[UIImageView alloc] initWithImage:item.image];
            [imageView sizeToFit];
            imageView.tag = kImageTagBase+i;
            
            /**
             *  选中的图片
             */
            UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:item.selectedImage];
            [selectedImageView sizeToFit];
            selectedImageView.alpha = 0.0f;
            selectedImageView.tag = kSelectedImageTagBase+i;

            [scrollView_ addSubview:label];
            [scrollView_ addSubview:imageView];
            [scrollView_ addSubview:selectedImageView];
            i++;
        }
        
        [self layoutTabbar];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    backgroudView_.frame = self.bounds;
    scrollView_.frame = self.bounds;
    [self layoutTabbar];
}

- (void)layoutTabbar{
    float width = self.bounds.size.width/self.tabbarItems.count;
    float height = self.bounds.size.height;
    float x = 0.0f;
    for (NSInteger i=0; i<self.tabbarItems.count; i++) {
        x = i*width;
        UILabel *label = (UILabel *)[scrollView_ viewWithTag:kLabelTagBase+i];
        UIImageView *imageView = (UIImageView *)[scrollView_ viewWithTag:kImageTagBase+i];
        UIImageView *selectedIamgeView = (UIImageView *)[scrollView_ viewWithTag:kSelectedImageTagBase+i];


        /**
         *  图片在上文字在下
         */
        if (isImageTop) {


            
            imageView.frame = CGRectMake((i * width) + width/2 - CGRectGetWidth(imageView.bounds)/2, 5, CGRectGetWidth(imageView.bounds), CGRectGetHeight(imageView.bounds));
            
            label.frame = CGRectMake(x + (width-label.bounds.size.width)/2.0f, imageView.bottom + 6, CGRectGetWidth(label.bounds), CGRectGetHeight(label.bounds));
            /**
             *  选中图片的位置
             */
            selectedIamgeView.frame = imageView.frame;
        }else{
            label.frame = CGRectMake(x + (width-label.bounds.size.width-CGRectGetWidth(imageView.bounds))/2.0f, (height-label.bounds.size.height)/2.0f, CGRectGetWidth(label.bounds), CGRectGetHeight(label.bounds));
            imageView.frame = CGRectMake(label.frame.origin.x + label.bounds.size.width+kImageSpacingX, (height-imageView.bounds.size.height)/2.0, CGRectGetWidth(imageView.bounds), CGRectGetHeight(imageView.bounds));
            
            /**
             *  选中图片的位置
             */
            selectedIamgeView.frame = imageView.frame;
        }
        
        /**
         *  未选中图片的位置
         */
        NSLog(@"isTopImage:%d",isImageTop);
        

    }
    
    float trackX = width*self.selectedIndex;
    _trackView_.frame = CGRectMake(trackX, _trackView_.frame.origin.y, width, kTrackViewHeight);
}

- (NSInteger)tabbarCount{
    return self.tabbarItems.count;
}

- (void)switchingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent{
    DLFixedTabbarViewTabItem *fromItem = [self.tabbarItems objectAtIndex:fromIndex];
    UILabel *fromLabel = (UILabel *)[scrollView_ viewWithTag:kLabelTagBase+fromIndex];
    UIImageView *fromIamge = (UIImageView *)[scrollView_ viewWithTag:kImageTagBase+fromIndex];
    UIImageView *fromSelectedIamge = (UIImageView *)[scrollView_ viewWithTag:kSelectedImageTagBase+fromIndex];
    fromLabel.textColor = [DLUtility getColorOfPercent:percent between:fromItem.titleColor and:fromItem.selectedTitleColor];
    fromIamge.alpha = percent;
    fromSelectedIamge.alpha = (1-percent);

    if (toIndex >= 0 && toIndex < [self tabbarCount]) {
        DLFixedTabbarViewTabItem *toItem = [self.tabbarItems objectAtIndex:toIndex];
        UILabel *toLabel = (UILabel *)[scrollView_ viewWithTag:kLabelTagBase+toIndex];
        UIImageView *toIamge = (UIImageView *)[scrollView_ viewWithTag:kImageTagBase+toIndex];
        UIImageView *toSelectedIamge = (UIImageView *)[scrollView_ viewWithTag:kSelectedImageTagBase+toIndex];
        toLabel.textColor = [DLUtility getColorOfPercent:percent between:toItem.selectedTitleColor and:toItem.titleColor];
        toIamge.alpha = (1-percent);
        toSelectedIamge.alpha = percent;
    }
    
    float width = self.bounds.size.width/self.tabbarItems.count;
    float trackX;
    if (toIndex > fromIndex) {
        trackX = width*fromIndex + width*percent;
    }
    else{
        trackX = width*fromIndex - width*percent;
    }
    
    //底部滚动条的frame
    _trackView_.frame = CGRectMake(trackX, self.tabbarHeight - self.tabbarBottomSpacing+1, CGRectGetWidth(_trackView_.bounds), CGRectGetHeight(_trackView_.bounds));
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex != selectedIndex) {
        if (_selectedIndex >= 0) {
            DLFixedTabbarViewTabItem *fromItem = [self.tabbarItems objectAtIndex:_selectedIndex];
            UILabel *fromLabel = (UILabel *)[scrollView_ viewWithTag:kLabelTagBase+_selectedIndex];
            UIImageView *fromIamge = (UIImageView *)[scrollView_ viewWithTag:kImageTagBase+_selectedIndex];
            UIImageView *fromSelectedIamge = (UIImageView *)[scrollView_ viewWithTag:kSelectedImageTagBase+_selectedIndex];
            fromLabel.textColor = fromItem.titleColor;
            fromIamge.alpha = 1.0f;
            fromSelectedIamge.alpha = 0.0f;
        }
        
        if (selectedIndex >= 0 && selectedIndex < [self tabbarCount]) {
            DLFixedTabbarViewTabItem *toItem = [self.tabbarItems objectAtIndex:selectedIndex];
            UILabel *toLabel = (UILabel *)[scrollView_ viewWithTag:kLabelTagBase+selectedIndex];
            UIImageView *toIamge = (UIImageView *)[scrollView_ viewWithTag:kImageTagBase+selectedIndex];
            UIImageView *toSelectedIamge = (UIImageView *)[scrollView_ viewWithTag:kSelectedImageTagBase+selectedIndex];
            toLabel.textColor = toItem.selectedTitleColor;
            toIamge.alpha = 0.0f;
            toSelectedIamge.alpha = 1.0f;
        }
        
        float width = self.bounds.size.width/self.tabbarItems.count;
        float trackX = width*selectedIndex;
        _trackView_.frame = CGRectMake(trackX, _trackView_.frame.origin.y, CGRectGetWidth(_trackView_.bounds), CGRectGetHeight(_trackView_.bounds));

        _selectedIndex = selectedIndex;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    float width = self.bounds.size.width/self.tabbarItems.count;

    CGPoint point = [tap locationInView:scrollView_];
    NSInteger i = point.x/width;
    self.selectedIndex = i;
    if (self.delegate) {
        [self.delegate DLSlideTabbar:self selectAt:i];
    }
}
@end
