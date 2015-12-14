//
//  TWebView.h
//  TestWebview
//
//  Created by bang on 12-2-8.
//

#import <Foundation/Foundation.h>

@protocol TWebScrollViewDelegate <NSObject>

@optional

- (void)currentScorollDidEndDragging:(UIScrollView *)scrollView;

@end

@interface TWebView : UIWebView {
	UIScrollView *_scrollView;
	UIView *headerView;
	UIView *footerView;
}

@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, assign) id<TWebScrollViewDelegate> scorollDelegate;

- (void) headerViewHeightChange:(int)height animated:(BOOL)animated;

- (instancetype)initWithFrame:(CGRect)frame withPost:(NSString *)post_id;

@end
