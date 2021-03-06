//
//  SendTopicViewController.m
//  Community
//
//  Created by shlity on 15/11/10.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "SendTopicViewController.h"
#import "CustomButtonItem.h"
#import "SendTopicTextView.h"
#import "SendTopicKeyboardView.h"
#import "AGEmojiKeyBoardView.h"
#import "ELCAlbumPickerController.h"
#import "ELCAssetTablePicker.h"
#import "ELCImagePickerController.h"
#import "TopicSendNavigationView.h"
#import "SendTopicBtnView.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "SendPhotoOptionView.h"

@interface SendTopicViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,AGEmojiKeyboardViewDelegate, AGEmojiKeyboardViewDataSource,ELCImagePickerControllerDelegate,UIGestureRecognizerDelegate>
{
    SendTopicTextView     *sendTopicView;
    SendTopicKeyboardView *sendKeyboardView;
    BOOL                  isInput;
    AGEmojiKeyboardView   *emojiKeyboardView;
    BOOL                  isKeyboardHide;
    UIImageView           *photoImageview;
    UIScrollView          *photoScrollView;
    UIButton              *addImageBtn;
    UIView                *photoBackgroundView;
    NSMutableDictionary   *Exparams;
    int                   deleteCount;
    SendTopicBtnView      *sendTopicBtnView;
    TopicSendNavigationView *sendNavigationView;
    BOOL                  isHidenSendView;
    int                   imageCount;
    UIScrollView          *scrollView;
}

@property (nonatomic,retain) NSMutableArray      *locaPhotoArr;
@property (nonatomic,retain) NSMutableArray      *imagesArray;
@property (nonatomic,copy  ) NSString            *filename;
@property (nonatomic,retain) NSMutableArray      *sendPhotoCountTitle;
@property (nonatomic,retain) SendPhotoOptionView *sendPhotoOptionView;
@property (nonatomic,retain) NSMutableArray      *topicArray;
@property (nonatomic,copy  ) NSString            *selectBtnTitle;

@end

@implementation SendTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSendTopicTextView];
    Exparams = [[NSMutableDictionary alloc]init];
    self.navigationItem.rightBarButtonItem =  [[CustomButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(sendTopicAction) andTtintColor:[UIColor whiteColor]];
    
    [self customNaviBack];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    sendKeyboardView = [[SendTopicKeyboardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 45, ScreenWidth, 45)];
    [sendKeyboardView.sendPhotoBtn addTarget:self action:@selector(selectPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [sendKeyboardView.sendEmojiBtn addTarget:self action:@selector(selectEmojiAction) forControlEvents:UIControlEventTouchUpInside];
    [sendKeyboardView.sendTopicBtn addTarget:self action:@selector(selectTopicAction) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:sendKeyboardView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.delegate = self;
    tapGesture.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGesture];
    
    deleteCount = -1;
    
    if (!isArrEmpty(self.myDraftDataArray)) {
        [self createPhotoList];
    }


    imageCount = 1;
}

#pragma mark -- UI
- (void)setupSendTopicTextView
{
    sendTopicView = [[SendTopicTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    sendTopicView.contentTextView.delegate = self;
    sendTopicView.contentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (!isStrEmpty(self.topicContent)) {
        sendTopicView.defaultLabel.hidden = YES;
    }
        sendTopicView.contentTextView.text = self.topicContent;
    
    photoBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, sendTopicView.contentTextView.bottom, ScreenWidth, 50)];
    [sendTopicView addSubview:photoBackgroundView];
    
    [self.view addSubview:sendTopicView];
    [self sendPhotoOptionView];
}

- (SendPhotoOptionView *)sendPhotoOptionView
{
    if (!_sendPhotoOptionView) {
        _sendPhotoOptionView = [[SendPhotoOptionView alloc]initWithFrame:CGRectMake(0, sendTopicView.contentTextView.bottom + 10, ScreenWidth, ScreenHeight - sendTopicView.contentTextView.bottom - 10)];
        [_sendPhotoOptionView.addPhotoBtn addTarget:self action:@selector(selectPhotoAction) forControlEvents:UIControlEventTouchUpInside];
        [sendTopicView addSubview:_sendPhotoOptionView];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _sendPhotoOptionView.lineView.bottom, ScreenWidth, ScreenHeight - sendTopicView.contentTextView.height - 10 - 40 - 40 - 40 - 10 - 40 - 28)];
        NSLog(@"height:%f",ScreenHeight - sendTopicView.contentTextView.height - 10 - 40 - 40 - 40 - 10);
        scrollView.backgroundColor = [UIColor whiteColor];
        [_sendPhotoOptionView addSubview:scrollView];
        
        photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addImageBtn.frame = CGRectMake(5, 5, 40, 40);
        [addImageBtn setImage:[UIImage imageNamed:@"topic_select_photo.png"] forState:UIControlStateNormal];
        [addImageBtn addTarget:self action:@selector(selectPhotoAction) forControlEvents:UIControlEventTouchUpInside];
        [photoScrollView addSubview:addImageBtn];
        
        photoScrollView.showsVerticalScrollIndicator = FALSE;
        photoScrollView.showsHorizontalScrollIndicator = FALSE;
        [_sendPhotoOptionView addSubview:photoScrollView];

        
        [self createTopicButtonData:MyTopicListTypeAll];
        
        for (int i = 200; i <= _sendPhotoOptionView.checkTopicBtn.tag; i ++) {
            UIButton *tempBtn = [_sendPhotoOptionView viewWithTag:i];
            tempBtn.tag = i;
            [tempBtn addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _sendPhotoOptionView;
}

#pragma mark -- UI
- (void)customNaviBack
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 40);
    [button setImage:[UIImage imageNamed:@"back_btn_image"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeCurrentView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backItem,nil];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField    
{
    isInput = NO; //
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
    
//    //动态改变textView 高度
//    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
//    CGRect frame = textView.frame;
//    frame.size.height = size.height;
//    textView.frame = frame;
//    [textView scrollRangeToVisible:NSMakeRange(0,0)];
//    
//    CGRect q = photoBackgroundView.frame;
//    q.origin.y = (size.height) + 40;
//    photoBackgroundView.frame = q;
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

- (void)onClickAction:(UIButton *)button
{
    
    NSLog(@"tag:%ld",button.tag);
    for (int i = 200; i <= _sendPhotoOptionView.checkTopicBtn.tag; i ++) {
        UIButton *tempBtn = [self.view viewWithTag:i];
        if (button.tag == i) {
            [tempBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        }else{
            [tempBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _sendPhotoOptionView.lineView.frame;
        frame.origin.x = (ScreenWidth/3) * (button.tag - 200);
        _sendPhotoOptionView.lineView.frame = frame;
    }];
    
    if (button.tag == 200) { //所有话题
        [self createTopicButtonData:MyTopicListTypeAll];
    }else if (button.tag == 201){ //我关注的话题
        [self createTopicButtonData:MyTopicListTypeConcern];
    }else{ //未关注的话题
        [self createTopicButtonData:MyTopicListTypeNotConcern];
    }
    
}

- (void)changeCatTap
{
    if (!sendTopicBtnView) {
        sendTopicBtnView = [[SendTopicBtnView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        for (int i = 100; i < sendTopicBtnView.mineBtn.tag + 1; i ++) {
            UIButton *button = (UIButton *)[sendTopicBtnView viewWithTag:i];
            [button addTarget:self action:@selector(onClickPageOne:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:sendTopicBtnView];
    }
    if (!isHidenSendView) {
        sendTopicBtnView.hidden = NO;
        isHidenSendView = YES;
    }else{
        sendTopicBtnView.hidden = YES;
        isHidenSendView = NO;
    }
    [self.view endEditing:YES];
}

- (void)onClickPageOne:(UIButton *)button
{
    NSArray *cateArray = @[@"11",@"1",@"2",@"3",@"4",@"5",@"6",@"12",@"7",@"9",@"10",@"8",@"13"];
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSString *cityName;
    
    NSRange foundObj=[sharedInfo.cityarea rangeOfString:@"城区"];  // options:NSCaseInsensitiveSearch
    if(foundObj.length>0){
        cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"城区" withString:@""];
    }else{
        NSRange foundObj2 = [sharedInfo.cityarea rangeOfString:@"县"];
        if (foundObj2.length > 0) {
            cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"县" withString:@""];
        }else{
            NSRange foundObj3 = [sharedInfo.cityarea rangeOfString:@"区"];
            if (foundObj3.length > 0) {
                cityName = [sharedInfo.cityarea stringByReplacingOccurrencesOfString:@"区" withString:@""];
            }else{
                cityName = sharedInfo.cityarea;
            }
        }
    }
    sendTopicBtnView.hidden = YES;
    isHidenSendView = NO;
}

- (void)closeCurrentView
{
    if (sendTopicView.contentTextView.text.length >0) {
        if ( ![sendTopicView.contentTextView.text isEqualToString:self.topicContent]) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"存为草稿", @"不保存", nil];
            sheet.actionSheetStyle =UIActionSheetStyleAutomatic;
            [sheet showInView:self.view];
            sheet.tag = 3000;
            [self.view endEditing:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)createTopicButtonData:(MyTopicListType)type
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ReHuatiClass",
                                 @"RunnerUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,
                                 @"RunnerIP":@"",
                                 @"RunnerIsClient":@"1",
                                 @"Detail":@[@{@"UserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,
                                               }]};
    
    [CKHttpRequest createRequest:HTTP_SUB_CLASS_CATE WithParam:parameters withMethod:@"POST" success:^(id result) {
        
        if (result) {
            NSArray *items = [result objectForKey:@"Detail"];
            NSLog(@"items:%@",items);
            
            for (int i = 0; i <= _topicArray.count; i ++) {
                UIButton *tempBtn = [scrollView viewWithTag:i + 400];
                [tempBtn removeFromSuperview];
            }
            
            [_topicArray removeAllObjects];
            if (!_topicArray) {
                _topicArray = [NSMutableArray new];
            }
            
            
            for (int i = 0; i < items.count; i ++) {
                if (type == MyTopicListTypeAll) { //全部话题的
                    _topicArray = [items mutableCopy];
                    break;
                }else if (type == MyTopicListTypeConcern){
                    NSDictionary *dic = [items objectAtIndex:i];
                    if ([[dic objectForKey:@"isfocus"]intValue] == 1) {
                        [_topicArray addObject:items[i]];
                    }
                }else{
                    NSDictionary *dic = [items objectAtIndex:i];
                    if ([[dic objectForKey:@"isfocus"]intValue] == 0) {
                        [_topicArray addObject:items[i]];
                    }
                }
            }
            
            /**
             *  创建城市按钮
             */
            float Start_X = 10.0f;           // 第一个按钮的X坐标
            float Start_Y = 10;           // 第一个按钮的Y坐标
            float Width_Space = 10.0f;        // 2个按钮之间的横间距
            float Height_Space = 10.0f;      // 竖间距
            float Button_Height = 35.f;    // 高
            float Button_Width = (ScreenWidth - 40)/3;      // 宽
            
            for (int i = 0 ; i < _topicArray.count; i++) {
                NSInteger index = i % 3;
                NSInteger page = i / 3;
                
                NSDictionary *dic = [_topicArray objectAtIndex:i];
                
                // 圆角按钮
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.backgroundColor = [UIColor whiteColor];
                [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
                [button setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
                [UIUtils setupViewBorder:button cornerRadius:Button_Height/2 borderWidth:1 borderColor:[UIColor colorWithHexString:@"#adadad"]];
                button.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
                button.tag = 400 + i;
                [button addTarget:self action:@selector(selectTopicAction:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:button];
                
                //已经选中过的
                if ([[dic objectForKey:@"name"] isEqualToString:self.selectBtnTitle]) {
                    button.backgroundColor = [UIColor colorWithHexString:@"#1ad155"];
                    [UIUtils setupViewBorder:button cornerRadius:35/2 borderWidth:1 borderColor:[UIColor whiteColor]];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
                if (i == (_topicArray.count - 1)) {
                    
                    scrollView.contentSize = CGSizeMake(ScreenWidth, button.bottom + 10);
                }
            }
        }
    } failure:^(NSError *erro) {
        
    }];
}

- (void)selectTopicAction:(UIButton *)button
{
    for (int i = 400; i <self.topicArray.count + 400;i++) {//num为总共设置单选效果按钮的数目
        UIButton *btn = (UIButton*)[self.view viewWithTag:i];//view为这些btn的父视图
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [UIUtils setupViewBorder:btn cornerRadius:35/2 borderWidth:1 borderColor:[UIColor colorWithHexString:@"#adadad"]];
    }
    NSDictionary *dic = _topicArray[button.tag - 400];
    self.selectBtnTitle = [dic objectForKey:@"name"];
    self.cate_id = [dic objectForKey:@"id"];
    
    button.backgroundColor = [UIColor colorWithHexString:@"#1ad155"];
    [UIUtils setupViewBorder:button cornerRadius:35/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)sendTopicAction{
    for (int i = 0; i < _locaPhotoArr.count; i ++) {
        NSDictionary *dict = [_locaPhotoArr objectAtIndex:i];
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
        NSString *indexStr = [NSString stringWithFormat:@"picturename%d",i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.0f);
        [Exparams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:imageData,indexStr, nil]];
    }
    [self sendTopicImageToServer:Exparams];
}

- (void)selectTopicAction
{
    sendTopicView.defaultLabel.hidden = YES;
    [sendTopicView.contentTextView becomeFirstResponder];
    sendTopicView.contentTextView.text = [NSString stringWithFormat:@"%@##",sendTopicView.contentTextView.text];
    sendTopicView.contentTextView.selectedRange = NSMakeRange(sendTopicView.contentTextView.text.length - 1,0);
}

- (void)selectPhotoAction
{
    [UIView animateWithDuration:0.2 animations:^{
        sendKeyboardView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 45);
        [self.view endEditing:YES];
    } completion:^(BOOL finished) {
        UIActionSheet *actionSheet;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            actionSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择", @"立即拍照上传", nil];
            actionSheet.tag = 2000;
        }
        else {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
            actionSheet.tag = 2001;
        }
        
        actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }];
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
    NSString * currentEmoji = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:sendTopicView.contentTextView.text];
    NSLog(@"currentEmoji:%@",currentEmoji);

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
     
            break;
    }
    return noneSelectedIamge;
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
    UIImage *deleteImage = [UIImage imageNamed:@"backspace_n"];
    return deleteImage;
}


#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2000 | actionSheet.tag == 2001) {
        //支持相机的情况下
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if (buttonIndex == 0) { //相册
                if (_locaPhotoArr.count == 9) {
                    [self initMBProgress:@"最多只能上传9张图片" withModeType:MBProgressHUDModeText afterDelay:1.5];
                }else{
                    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                    
                    elcPicker.maximumImagesCount = 9 - _locaPhotoArr.count;
                    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
                    elcPicker.imagePickerDelegate = self;
                    
                    [self presentViewController:elcPicker animated:YES completion:nil];
                }
            }else if (buttonIndex == 1){  //照相机
                if (_locaPhotoArr.count == 9) {
                    [self initMBProgress:@"最多只能上传9张图片" withModeType:MBProgressHUDModeText afterDelay:1.5];
                }else{
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = NO;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
                
            }else{
                
                if (isInput == YES) {
                    [sendTopicView.titleTextField becomeFirstResponder];
                }else{
                    [sendTopicView.contentTextView becomeFirstResponder];
                }
            }
        }else{
            if (buttonIndex == 0) {
                if (_locaPhotoArr.count == 9) {
                    [self initMBProgress:@"最多只能上传9张图片" withModeType:MBProgressHUDModeText afterDelay:1.5];
                }else{
                    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                    
                    elcPicker.maximumImagesCount = 9 - _locaPhotoArr.count;
                    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
                    elcPicker.imagePickerDelegate = self;
                    
                    [self presentViewController:elcPicker animated:YES completion:nil];
                }
            }else{
                if (isInput == YES) {
                    [sendTopicView.titleTextField becomeFirstResponder];
                }else{
                    [sendTopicView.contentTextView becomeFirstResponder];
                }
            }
        }
    }else if (actionSheet.tag == 3000){
        if (buttonIndex == 0) {
            //创建一个plist文件，将数据存储在本地
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path=[paths    objectAtIndex:0];
            
            _filename=[path stringByAppendingPathComponent:@"myDraft.plist"];
            NSFileManager* fm = [NSFileManager defaultManager];
            
            //判断是否存在，如果不存在就创建
            if (![fm fileExistsAtPath:_filename]) {
                [fm createFileAtPath:_filename contents:nil attributes:nil];
            }
            
            NSString *plistPath = [UIUtils getDocumentFile:@"myDraft.plist"];
            NSData *data = [[NSData alloc] initWithContentsOfFile:plistPath];
            NSMutableArray  *tempArray =  [NSKeyedUnarchiver unarchiveObjectWithData:data];

            //向plist文件中写入NSArray数据
            //NSLog(@"tempArray:%@",tempArray);

            NSMutableArray  *dataArray = [[NSMutableArray alloc]init];
            if (tempArray.count != 0) {
                dataArray = [tempArray mutableCopy];
                if (!isStrEmpty(self.listTag)) {
                    //修改的情况下需要将以前的删除掉，再重新添加
                    [dataArray removeObjectAtIndex:[self.listTag intValue]];
                }
                [dataArray insertObject:@{@"cate_id":self.cate_id,@"title":isStrEmpty(sendTopicView.titleTextField.text) ? @"" : sendTopicView.titleTextField.text,@"content":isStrEmpty(sendTopicView.contentTextView.text) ? @"" : sendTopicView.contentTextView.text,@"date":[UIUtils getCurrentDate:@"MM-dd HH:mm"],@"imaes":isArrEmpty(_locaPhotoArr) ? @[] : _locaPhotoArr}atIndex:0];
            }else{
                [dataArray insertObject:@{@"cate_id":self.cate_id,@"title":isStrEmpty(sendTopicView.titleTextField.text) ? @"" : sendTopicView.titleTextField.text,@"content":isStrEmpty(sendTopicView.contentTextView.text) ? @"" : sendTopicView.contentTextView.text,@"date":[UIUtils getCurrentDate:@"MM-dd HH:mm"],@"imaes":isArrEmpty(_locaPhotoArr) ? @[] : _locaPhotoArr}atIndex:0];
            }

            NSError  *error;
            NSData* archiveData = [NSKeyedArchiver archivedDataWithRootObject:dataArray];
            if ([archiveData writeToFile:self.filename options:NSDataWritingAtomic error:&error]) {
                NSLog(@"1");
            }else{
                NSLog(@"2");
            }
            
            [self dismissViewControllerAnimated:YES completion:^{
                if (!isStrEmpty(self.listTag)) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateContentNotification" object:nil];
                }
            }];
            
        }else if (buttonIndex == 1){
            [self  dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        
    }else{
        if (buttonIndex == 0) {
            UIImageView *imageView = (UIImageView *)[self.view viewWithTag:actionSheet.tag];
            [imageView removeFromSuperview];
            if (_locaPhotoArr.count > 0) {
                [_locaPhotoArr removeObjectAtIndex:actionSheet.tag - 500];
                [self createImageList];
            }
        }
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ELCImagePickerControllerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self.sendPhotoCountTitle removeAllObjects];
    for (int i = 0; i < info.count; i ++) {
        if (!self.locaPhotoArr) {
            _locaPhotoArr = [[NSMutableArray alloc]init];
        }
        [_locaPhotoArr addObject:[info objectAtIndex:i]];
    }
    for (int i = 0; i < _locaPhotoArr.count; i ++) {
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:[[_locaPhotoArr objectAtIndex:i] valueForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
        } failureBlock:^(NSError *err) {
            NSLog(@"Error: %@",[err localizedDescription]);
        }];
    }
    
    float start_x = 5.0f;
    float width_space = 5.0f;
    float height = 50.0f;
    float width = 50.0f;
    
    photoScrollView.contentSize = CGSizeMake(((50 + 10)*_locaPhotoArr.count) + 20, 0);
    for (int i = 0; i < _locaPhotoArr.count; i ++) {
        NSDictionary *dict = [_locaPhotoArr objectAtIndex:i];
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
        photoImageview= [[UIImageView alloc] initWithImage:image];
        [photoImageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
        photoImageview.contentMode =  UIViewContentModeScaleAspectFill;
        photoImageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        photoImageview.clipsToBounds  = YES;
        photoImageview.userInteractionEnabled = YES;
        photoImageview.frame = CGRectMake(i * (width + width_space) + start_x, 0, width, height);
        [photoScrollView addSubview:photoImageview];
        
        UITapGestureRecognizer *deleteImageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImageAction:)];
        photoImageview.userInteractionEnabled = YES;
        photoImageview.tag = 500 + i;
        [photoImageview addGestureRecognizer:deleteImageTapGesture];
    }
    

    addImageBtn.frame = CGRectMake(photoImageview.right + 10, 2.5, 45, 45);
}

#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.sendPhotoCountTitle removeAllObjects];
    /**
     *  上传照片的个数
     */
    if (!self.sendPhotoCountTitle) {
        self.sendPhotoCountTitle = [[NSMutableArray alloc]init];
    }

    [picker dismissViewControllerAnimated:YES completion:^{
        
        if (!self.locaPhotoArr) {
            _locaPhotoArr = [[NSMutableArray alloc]init];
        }
        [_locaPhotoArr addObject:info];
        
        float start_x = 5.0f;
        float width_space = 5.0f;
        float height = 50.0f;
        float width = 50.0f;
        
        photoScrollView.contentSize = CGSizeMake(((50 + 10)*_locaPhotoArr.count) + 20, 0);
        for (int i = 0; i < _locaPhotoArr.count; i ++) {
            NSDictionary *dict = [_locaPhotoArr objectAtIndex:i];
            UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
            
            photoImageview= [[UIImageView alloc] initWithImage:image];
            [photoImageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
            photoImageview.contentMode =  UIViewContentModeScaleAspectFill;
            photoImageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            photoImageview.clipsToBounds  = YES;
            photoImageview.userInteractionEnabled = YES;
            
            photoImageview.frame = CGRectMake(i * (width + width_space) + start_x, 0, width, height);
            
            [photoScrollView addSubview:photoImageview];
            
            UITapGestureRecognizer *deleteImageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImageAction:)];
            photoImageview.userInteractionEnabled = YES;
            photoImageview.tag = 500 + i;
            [photoImageview addGestureRecognizer:deleteImageTapGesture];
        }
        
        addImageBtn.frame = CGRectMake(photoImageview.right + 10, 2.5, 45, 45);
    }];
}

- (void)createPhotoList
{
    if (!self.locaPhotoArr) {
        _locaPhotoArr = [[NSMutableArray alloc]initWithArray:self.myDraftDataArray];
    }
    if (!self.locaPhotoArr) {
        _locaPhotoArr = [[NSMutableArray alloc]init];
    }
    
    float start_x = 5.0f;
    float width_space = 5.0f;
    float height = 50.0f;
    float width = 50.0f;
    
    photoScrollView.contentSize = CGSizeMake(((50 + 10)*_locaPhotoArr.count) + 20, 0);
    for (int i = 0; i < _locaPhotoArr.count; i ++) {
        NSDictionary *dict = [_locaPhotoArr objectAtIndex:i];
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
        photoImageview= [[UIImageView alloc] initWithImage:image];
        [photoImageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
        photoImageview.contentMode =  UIViewContentModeScaleAspectFill;
        photoImageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        photoImageview.clipsToBounds  = YES;
        photoImageview.userInteractionEnabled = YES;
        
        photoImageview.frame = CGRectMake(i * (width + width_space) + start_x, 0, width, height);
        
        [photoScrollView addSubview:photoImageview];
        
        UITapGestureRecognizer *deleteImageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImageAction:)];
        photoImageview.userInteractionEnabled = YES;
        photoImageview.tag = 500 + i;
        [photoImageview addGestureRecognizer:deleteImageTapGesture];
    }
    
    addImageBtn.frame = CGRectMake(photoImageview.right + 10, 2.5, 45, 45);

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

#pragma makr -- action

- (void)deleteImageAction:(UITapGestureRecognizer *)recognizer
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除图片", nil];
    sheet.actionSheetStyle =UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];
    sheet.tag = recognizer.view.tag;
}

- (void)createImageList
{
    float start_x = 5.0f;
    float width_space = 5.0f;
    float height = 50.0f;
    float width = 50.0f;
    if (photoScrollView) {
        [photoScrollView removeFromSuperview];
    }
    
    photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    photoScrollView.showsVerticalScrollIndicator = FALSE;
    photoScrollView.showsHorizontalScrollIndicator = FALSE;
    [_sendPhotoOptionView addSubview:photoScrollView];
    
    addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageBtn addTarget:self action:@selector(selectPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"topic_select_photo.png"] forState:UIControlStateNormal];
    [photoScrollView addSubview:addImageBtn];
    
    photoScrollView.contentSize = CGSizeMake(((50 + 10)*_locaPhotoArr.count) + 20, 0);
    for (int i = 0; i < _locaPhotoArr.count; i ++) {
        NSDictionary *dict = [_locaPhotoArr objectAtIndex:i];
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
        photoImageview= [[UIImageView alloc] initWithImage:image];
        [photoImageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
        photoImageview.contentMode =  UIViewContentModeScaleAspectFill;
        photoImageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        photoImageview.clipsToBounds  = YES;
        photoImageview.userInteractionEnabled = YES;
        
        photoImageview.frame = CGRectMake(i * (width + width_space) + start_x, 0, width, height);
        
        [photoScrollView addSubview:photoImageview];
        
        UITapGestureRecognizer *deleteImageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImageAction:)];
        photoImageview.userInteractionEnabled = YES;
        photoImageview.tag = 500 + i;
        [photoImageview addGestureRecognizer:deleteImageTapGesture];
    }
    
    if (_locaPhotoArr.count == 0) {
        addImageBtn.frame = CGRectMake(10, 2.5, 45, 45);
    }else{
        addImageBtn.frame = CGRectMake(photoImageview.right + 10, 2.5, 45, 45);
    }
}

/**
 *  上传多张照片
 *
 *  @param imageDic 字典数组
 */
- (void)sendTopicImageToServer:(NSMutableDictionary *)imageDic{
    
    NSString * currentEmoji = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:sendTopicView.contentTextView.text];
    if (sendTopicView.contentTextView.text.length == 0) {
        [self initMBProgress:@"请输入分享内容" withModeType:MBProgressHUDModeText afterDelay:1.5];
        return;

    }
    
    if (self.cate_id.length == 0) {
        [self initMBProgress:@"请选择话题" withModeType:MBProgressHUDModeText afterDelay:1.5];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager POST:SEND_TOPIC_IMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        //图片上传
        if (imageDic.count > 0) {
            for (NSString *key in [imageDic allKeys]) {
                [formData appendPartWithFileData:[imageDic objectForKey:key] name:key fileName:[NSString stringWithFormat:@"%@.png",key] mimeType:@"image/jpeg"];
            }
            [self initMBProgress:@"图片上传中..."];
            NSLog(@"imageDic:%@",imageDic);
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setMBProgreeHiden:YES];
        self.imagesArray = [responseObject objectForKey:@"Detail"];
        
        /**
         *  发布图片和内容到服务器
         */
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSDictionary *params = @{@"Method":@"AddPostInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"2",@"Detail":@[@{@"ClassID":self.cate_id,@"Name":@"",@"IsShow":@"1",@"Detail":currentEmoji,@"Sort":@"",@"UserID":sharedInfo.user_id,@"IP":@"",@"ProvinceID":isStrEmpty(sharedInfo.area)?@"1":sharedInfo.area,@"CityID":isStrEmpty(sharedInfo.city)?@"1":sharedInfo.city,@"Area":sharedInfo.city}],@"Images":self.imagesArray};
        
        NSLog(@"paramsss:%@",params);
        
        [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:params withMethod:@"POST" success:^(id result) {
            NSLog(@"resultss:%@",result);
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self initMBProgress:@"发布成功" withModeType:MBProgressHUDModeText afterDelay:1];
                [self performBlock:^{
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadDataNotification object:nil];
                    }];
                } afterDelay:1];
            }else{
                [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    /**
     *  没有图片的情况下发布
     */
    if (imageDic.count == 0) {
        /**
         *  发布图片和内容到服务器
         */
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSDictionary *params = @{@"Method":@"AddPostInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"2",@"Detail":@[@{@"ClassID":self.cate_id,@"Name":@"",@"Detail":currentEmoji,@"Sort":@"",@"IP":@"",@"IsShow":@"1",@"UserID":sharedInfo.user_id,@"ProvinceID":isStrEmpty(sharedInfo.city)?@"1":sharedInfo.city,@"CityID":isStrEmpty(sharedInfo.city)?@"1":sharedInfo.city,@"Area":sharedInfo.city}]};

        
        [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:params withMethod:@"POST" success:^(id result) {
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                
                [self initMBProgress:@"发布成功" withModeType:MBProgressHUDModeText afterDelay:1];
                [self performBlock:^{
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadDataNotification object:nil];
                    }];
                } afterDelay:1];
            }else{
                [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
    }
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
//    if (isInput == YES) {
//        [self.view endEditing:YES];
//    }else{
//        [sendTopicView.contentTextView  becomeFirstResponder];
//    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
