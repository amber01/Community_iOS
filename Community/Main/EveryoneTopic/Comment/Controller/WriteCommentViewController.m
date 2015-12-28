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
#import "WriteCommentTextView.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

@interface WriteCommentViewController ()<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,AGEmojiKeyboardViewDelegate, AGEmojiKeyboardViewDataSource>
{
    WriteCommentTextView     *sendTopicView;
    SendTopicKeyboardView    *sendKeyboardView;
    BOOL                     isInput;
    AGEmojiKeyboardView      *emojiKeyboardView;
    BOOL                     isKeyboardHide;
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
    
    [self setupSendTopicTextView];
    
    sendKeyboardView = [[SendTopicKeyboardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 45, ScreenWidth, 45)];
    sendKeyboardView.sendPhotoBtn.hidden = YES;
    sendKeyboardView.sendTopicBtn.hidden = YES;
    sendKeyboardView.sendEmojiBtn.frame = CGRectMake(15, sendKeyboardView.height/2 - 12.5, 25, 25);
    
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
    
    sendTopicView = [[WriteCommentTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    sendTopicView.contentTextView.delegate = self;
    sendTopicView.contentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [sendTopicView.contentTextView becomeFirstResponder];
    
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
    
    if (sendTopicView.contentTextView.text.length < 1) {
        [self initMBProgress:@"评论不能为空" withModeType:MBProgressHUDModeText afterDelay:1.5];
        return;
    }
    
    NSString * currentEmoji = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:sendTopicView.contentTextView.text];
    NSLog(@"currentEmoji:%@",currentEmoji);

    
    //回复评论
    if (!isStrEmpty(self.commentID)) {
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSDictionary *parameters = @{@"Method":@"AddCommentInfo",@"RunnerUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"PostID":self.post_id,@"UserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"ReplayContent":currentEmoji ,@"IP":@"",@"IsReplay":@"1",@"CommentID":self.commentID}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_COMMENT WithParam:parameters withMethod:@"POST" success:^(id result) {
            NSLog(@"result:%@",result);
            NSLog(@"msg:%@",[result objectForKey:@"Msg"]);
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kReloadDataNotification object:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kReloadCommentNotification object:nil];
                    [self initMBProgress:@"发布成功" withModeType:MBProgressHUDModeText afterDelay:1.5];
                }];
            }
            NSLog(@"result:%@",result);
        } failure:^(NSError *erro) {
            
        }];

    }else{ //评论帖子
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSDictionary *parameters = @{@"Method":@"AddCommentInfo",@"RunnerUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"1",@"Detail":@[@{@"PostID":self.post_id,@"UserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,@"Detail":currentEmoji ,@"IP":@"",@"IsReplay":@"0",@"ReplayContent":@"",@"CommentID":@"0"}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_COMMENT WithParam:parameters withMethod:@"POST" success:^(id result) {
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kReloadDataNotification object:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kReloadCommentNotification object:nil];
                    [self initMBProgress:@"发布成功" withModeType:MBProgressHUDModeText afterDelay:1.5];
                }];
            }
            NSLog(@"result:%@",result);
        } failure:^(NSError *erro) {
            
        }];
    }
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
