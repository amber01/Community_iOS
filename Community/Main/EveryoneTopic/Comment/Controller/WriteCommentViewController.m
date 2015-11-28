//
//  WriteCommentViewController.m
//  Community
//
//  Created by amber on 15/11/26.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "WriteCommentViewController.h"
#import "SendTopicTextView.h"
#import "SendTopicKeyboardView.h"
#import "AGEmojiKeyBoardView.h"


@interface WriteCommentViewController ()<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,AGEmojiKeyboardViewDelegate, AGEmojiKeyboardViewDataSource>
{
    SendTopicTextView     *sendTopicView;
    SendTopicKeyboardView *sendKeyboardView;
    BOOL                  isInput;
    AGEmojiKeyboardView   *emojiKeyboardView;
    BOOL                  isKeyboardHide;
}

@end

@implementation WriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表评论";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem =  [[CustomButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(closeCurrentView) andTtintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem =  [[CustomButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(sendTopicAction) andTtintColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    sendKeyboardView = [[SendTopicKeyboardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 45, ScreenWidth, 45)];
    [sendKeyboardView.sendEmojiBtn addTarget:self action:@selector(selectEmojiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendKeyboardView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.delegate = self;
    tapGesture.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark -- UI
- (void)setupSendTopicTextView
{
    sendTopicView = [[SendTopicTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    sendTopicView.titleTextField.delegate = self;
    sendTopicView.contentTextView.delegate = self;
    sendTopicView.contentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [sendTopicView.titleTextField becomeFirstResponder];
    
    [self.view addSubview:sendTopicView];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    isInput = YES;
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    isInput = NO;
    [UIView animateWithDuration:0.3 animations:^{
        emojiKeyboardView.frame = CGRectMake(0, ScreenHeight, self.view.frame.size.width, 225);
    }];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        sendTopicView.defaultLabel.hidden = YES;
    }else{
        sendTopicView.defaultLabel.hidden = NO;
    }
    
    //动态改变textView 高度
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    CGRect frame = textView.frame;
    frame.size.height = size.height;
    textView.frame = frame;
    [textView scrollRangeToVisible:NSMakeRange(0,0)];
}

#pragma mark -- UITextViewDelegate

- (void)keyboardWillShow:(NSNotification*) notification {
    //键盘高度自适应
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGRect q = sendKeyboardView.frame;
    q.origin.y  = ScreenHeight - 64 - 45 - keyboardSize.height;
    sendKeyboardView.frame = q;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    CGRect q = sendKeyboardView.frame;
    q.origin.y= ScreenHeight - 64 - 45;
    sendKeyboardView.frame = q;
    isKeyboardHide = YES;
}

#pragma mark -- action
- (void)closeCurrentView
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)sendTopicAction{

}


- (void)selectEmojiAction
{
    if (!emojiKeyboardView) {
        emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, ScreenHeight, self.view.frame.size.width, 225) dataSource:self];
        emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        emojiKeyboardView.delegate = self;
        [self.view addSubview:emojiKeyboardView];
    }
    [self.view endEditing:YES];
    
    if (isKeyboardHide == YES) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect q = sendKeyboardView.frame;
            q.origin.y  = ScreenHeight - 64 - 45 - 225;
            sendKeyboardView.frame = q;
            emojiKeyboardView.frame = CGRectMake(0, ScreenHeight - 225 - 64, self.view.frame.size.width, 225);
        }];
    }
}


#pragma mark -- AGEmojiKeyboardViewDelegate

- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
    NSLog(@"emoji:%@",emoji);
    sendTopicView.contentTextView.text = [NSMutableString stringWithFormat:@"%@%@",sendTopicView.contentTextView.text,emoji];
    if (sendTopicView.contentTextView.text.length>0) {
        sendTopicView.defaultLabel.hidden = YES;
    }else{
        sendTopicView.defaultLabel.hidden = NO;
    }
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView {
    [sendTopicView.contentTextView deleteBackward];
    
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *selectedIamge;
    switch (category) {
        case AGEmojiKeyboardViewCategoryImageRecent:
            selectedIamge = [UIImage imageNamed:@"recent_s"];
            break;
        case AGEmojiKeyboardViewCategoryImageFace:
            selectedIamge = [UIImage imageNamed:@"face_s"];
            break;
        case AGEmojiKeyboardViewCategoryImageBell:
            selectedIamge = [UIImage imageNamed:@"bell_s"];
            break;
        case AGEmojiKeyboardViewCategoryImageFlower:
            selectedIamge = [UIImage imageNamed:@"flower_s"];
            break;
        case AGEmojiKeyboardViewCategoryImageCar:
            selectedIamge = [UIImage imageNamed:@"car_s"];
            break;
        case AGEmojiKeyboardViewCategoryImageCharacters:
            selectedIamge = [UIImage imageNamed:@"characters_s"];
            break;
        default:
            break;
    }
    return selectedIamge;
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *noneSelectedIamge;
    switch (category) {
        case AGEmojiKeyboardViewCategoryImageRecent:
            noneSelectedIamge = [UIImage imageNamed:@"recent_n"];
            break;
        case AGEmojiKeyboardViewCategoryImageFace:
            noneSelectedIamge = [UIImage imageNamed:@"face_n"];
            break;
        case AGEmojiKeyboardViewCategoryImageBell:
            noneSelectedIamge = [UIImage imageNamed:@"bell_n"];
            break;
        case AGEmojiKeyboardViewCategoryImageFlower:
            noneSelectedIamge = [UIImage imageNamed:@"flower_n"];
            break;
        case AGEmojiKeyboardViewCategoryImageCar:
            noneSelectedIamge = [UIImage imageNamed:@"car_n"];
            break;
        case AGEmojiKeyboardViewCategoryImageCharacters:
            noneSelectedIamge = [UIImage imageNamed:@"characters_n"];
            break;
        default:
            break;
    }
    return noneSelectedIamge;
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
    UIImage *deleteImage = [UIImage imageNamed:@"backspace_n"];
    return deleteImage;
}

#pragma mark--UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}
#pragma mark -- other
- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
