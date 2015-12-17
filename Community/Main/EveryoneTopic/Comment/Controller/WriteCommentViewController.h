//
//  WriteCommentViewController.h
//  Community
//
//  Created by amber on 15/11/26.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "BaseViewController.h"

@interface WriteCommentViewController : BaseViewController

@property (nonatomic,copy)NSString  *post_id;
@property (nonatomic,copy)NSString  *commentID; //0是评论帖子，CommentID>0评论ID（变量）
@property (nonatomic,copy)NSString  *toUserID;

@end
