//
//  ScorellButtonView.h
//  WSScrollButtonSimple
//
//  Created by shlity on 15/10/28.
//  Copyright (c) 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckMoreDelegate <NSObject>

@optional
- (void)checkMoreScorollDidEndDragging:(UIScrollView *)scrollView;

@end

@interface ScorellButtonView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int            page;
    MBProgressHUD  *progress;
}

- (instancetype)initWithFrame:(CGRect)frame withPostID:(NSString *)post_id;

@property (nonatomic,retain  ) UITableView    *tableView;
@property (nonatomic,copy    ) NSString       *post_id;

@property (nonatomic,copy    ) NSString       *sortStr;
@property (nonatomic,copy    ) NSString       *userID;
@property (nonatomic,copy    ) NSString       *tempUserID;

@property (nonatomic,retain  ) NSMutableArray *dataArray;
@property (nonatomic,retain  ) NSMutableArray *likeDataArray;//记录本地点赞的状态
@property (nonatomic,retain  ) NSMutableArray *praiseDataArray;//自己是否点赞的数据

@property (nonatomic,assign  ) id<CheckMoreDelegate> delegate;

@end

