//
//  SystemNoticeModel.h
//  Community
//
//  Created by amber on 15/12/22.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SystemNoticeModel : JSONModel

@property (nonatomic,copy)NSString *createtime;
@property (nonatomic,copy)NSString *detail;
@property (nonatomic,copy)NSString *hitnumber;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *isread;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *titlecolor;
@property (nonatomic,copy)NSString *touserid;
@property (nonatomic,copy)NSString *tablename;

@end
