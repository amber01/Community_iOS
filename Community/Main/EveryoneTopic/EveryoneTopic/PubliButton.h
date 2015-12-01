//
//  PubliButton.h
//  Community
//
//  Created by amber on 15/11/26.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PubliButton : UIButton

@property (nonatomic,copy  ) NSString  *post_id;
@property (nonatomic,copy  ) NSString  *user_id;
@property (nonatomic,copy  ) NSString  *like_num;
@property (nonatomic,copy  ) NSString  *nickname;

@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger section;


@end
