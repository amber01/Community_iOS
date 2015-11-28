//
//  RegisterView.h
//  Community
//
//  Created by amber on 15/11/18.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

@interface RegisterView : UIView

@property (nonatomic,retain) UITextField *phoneNumTextField;
@property (nonatomic,retain) UITextField *codeTextField;
@property (nonatomic,retain) UITextField *passwordTextField;

@property (nonatomic,retain) UIButton    *registerBtn;
@property (nonatomic,retain) UIButton    *autoRegisterBtn;
@property (nonatomic,retain) UIButton    *getCodeBtn;

@property (nonatomic,retain)TTTAttributedLabel *summaryLabel;
@property (nonatomic,retain)NSMutableAttributedString *hintString;

@end
