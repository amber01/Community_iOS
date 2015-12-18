//
//  MyCollectionModel.h
//  Community
//
//  Created by shlity on 15/12/18.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MyCollectionModel : JSONModel

@property (nonatomic,copy)NSString *createtime;
@property (nonatomic,copy)NSString *logopicture;
@property (nonatomic,copy)NSString *logopicturedomain;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *postid;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *id;

@end
