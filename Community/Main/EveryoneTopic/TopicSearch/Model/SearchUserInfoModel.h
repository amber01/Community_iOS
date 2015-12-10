//
//  SearchUserInfoModel.h
//  Community
//
//  Created by amber on 15/12/10.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SearchUserInfoModel : JSONModel

@property (nonatomic,copy)NSString   *picture;
@property (nonatomic,copy)NSString   *id;
@property (nonatomic,copy)NSString   *nickname;

@end
