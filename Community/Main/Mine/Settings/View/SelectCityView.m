//
//  SelectCityView.m
//  Community
//
//  Created by amber on 16/3/27.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "SelectCityView.h"

@implementation SelectCityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *cityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        cityView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [self addSubview:cityView];
        
        UILabel *currentCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, cityView.height/2 - 10, ScreenWidth - 20, 20)];
        currentCityLabel.textColor = [UIColor colorWithHexString:@"#adadad"];
        currentCityLabel.font = [UIFont systemFontOfSize:15];
        currentCityLabel.text = @"您现在的城市";
        [cityView addSubview:currentCityLabel];
        
        self.cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, cityView.bottom + 44/2-10, ScreenWidth - 20, 20)];
        _cityLabel.font = [UIFont systemFontOfSize:15];
        _cityLabel.text = @"温州";
        [self addSubview:_cityLabel];
        
        
        self.hotCityView = [[UIView alloc]initWithFrame:CGRectMake(0, cityView.bottom + 44 , ScreenWidth, 55)];
        _hotCityView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [self addSubview:_hotCityView];
        
        UILabel *hotCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _hotCityView.height/2 - 10, ScreenWidth - 20, 20)];
        hotCityLabel.textColor = [UIColor colorWithHexString:@"#adadad"];
        hotCityLabel.font = [UIFont systemFontOfSize:15];
        hotCityLabel.text = @"热门城市";
        [_hotCityView addSubview:hotCityLabel];
        
        [self addSubview:currentCityLabel];
    }
    return self;
}



@end
