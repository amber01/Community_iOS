//
//  UILabel+VerticalUpAlignment.h
//  妈妈去哪儿
//
//  Created by shlity on 15/9/2.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (VerticalUpAlignment)

//label换行时，让text向上对齐
- (void)verticalUpAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight;

@end
