//
//  LoginView.h
//  Community
//
//  Created by amber on 15/11/19.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIScrollView

@property (nonatomic,retain) UITextField *phoneNumTextField;
@property (nonatomic,retain) UITextField *passwordTextField;

@property (nonatomic,retain) UIButton    *findPassword;

@property (nonatomic,retain) UIButton    *qqLoginBtn;
@property (nonatomic,retain) UIButton    *weiChatBtn;

@end
