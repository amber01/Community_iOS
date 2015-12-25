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
}

@property (nonatomic,retain) NSMutableArray *locaPhotoArr;
@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,copy  ) NSString       *filename;
@property (nonatomic,retain) NSMutableArray *sendPhotoCountTitle;

@end

@implementation SendTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSendTopicTextView];
    Exparams = [[NSMutableDictionary alloc]init];
    self.navigationItem.leftBarButtonItem =  [[CustomButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(closeCurrentView) andTtintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem =  [[CustomButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(sendTopicAction) andTtintColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    sendKeyboardView = [[SendTopicKeyboardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 45, ScreenWidth, 45)];
    [sendKeyboardView.sendPhotoBtn addTarget:self action:@selector(selectPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [sendKeyboardView.sendEmojiBtn addTarget:self action:@selector(selectEmojiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendKeyboardView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.delegate = self;
    tapGesture.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGesture];
    
    deleteCount = -1;
    
    if (!isArrEmpty(self.myDraftDataArray)) {
        [self createPhotoList];
    }
}

#pragma mark -- UI
- (void)setupSendTopicTextView
{
    sendTopicView = [[SendTopicTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    sendTopicView.titleTextField.delegate = self;
    sendTopicView.contentTextView.delegate = self;
    sendTopicView.contentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [sendTopicView.titleTextField becomeFirstResponder];
    
    if (!isStrEmpty(self.topicContent)) {
        sendTopicView.defaultLabel.hidden = YES;
    }
    
    sendTopicView.titleTextField.text = self.topicTitle;
    sendTopicView.contentTextView.text = self.topicContent;
    
    photoBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, sendTopicView.contentTextView.bottom, ScreenWidth, 50)];
    [sendTopicView addSubview:photoBackgroundView];
    
    photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    photoScrollView.showsVerticalScrollIndicator = FALSE;
    photoScrollView.showsHorizontalScrollIndicator = FALSE;
    [photoBackgroundView addSubview:photoScrollView];
    
    addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageBtn addTarget:self action:@selector(selectPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"send_add_image"] forState:UIControlStateNormal];
    [photoScrollView addSubview:addImageBtn];
    
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
    
    CGRect q = photoBackgroundView.frame;
    q.origin.y = (size.height) + 40;
    photoBackgroundView.frame = q;
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
    if (sendTopicView.titleTextField.text.length>0 || sendTopicView.contentTextView.text.length >0) {
        if (![sendTopicView.titleTextField.text isEqualToString:self.topicTitle] || ![sendTopicView.contentTextView.text isEqualToString:self.topicContent]) {
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
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        
    }else{
        if (buttonIndex == 0) {
            NSLog(@"delete tag:%ld",actionSheet.tag);
            int deleteTag = (int)actionSheet.tag - 500;
            [self.sendPhotoCountTitle removeObjectAtIndex:deleteTag];
            
            //sendTopicView.contentTextView.text = [self.sendPhotoCountTitle componentsJoinedByString:@""];
            
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
        if (!self.sendPhotoCountTitle) {
            self.sendPhotoCountTitle = [[NSMutableArray alloc]init];
        }
        sendTopicView.defaultLabel.hidden = YES;
        [self.sendPhotoCountTitle addObject:[NSString stringWithFormat:@"[图片%d]",i+1]];
    }
    
    sendTopicView.contentTextView.text = [NSString stringWithFormat:@"%@%@",sendTopicView.contentTextView.text,[self.sendPhotoCountTitle componentsJoinedByString:@""]];
    addImageBtn.frame = CGRectMake(photoImageview.right + 10, 2.5, 45, 45);
}

#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
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
    [photoBackgroundView addSubview:photoScrollView];
    
    addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageBtn addTarget:self action:@selector(selectPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"send_add_image"] forState:UIControlStateNormal];
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
    
    addImageBtn.frame = CGRectMake(photoImageview.right + 10, 2.5, 45, 45);
}

/**
 *  上传多张照片
 *
 *  @param imageDic 字典数组
 */
- (void)sendTopicImageToServer:(NSMutableDictionary *)imageDic{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager POST:SEND_TOPIC_IMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //图片上传
        if (imageDic.count > 0) {
            for (NSString *key in [imageDic allKeys]) {
                [formData appendPartWithFileData:[imageDic objectForKey:key] name:key fileName:[NSString stringWithFormat:@"%@.png",key] mimeType:@"image/jpeg"];
            }
            [self initMBProgress:@"图片上传中..."];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setMBProgreeHiden:YES];
        self.imagesArray = [responseObject objectForKey:@"Detail"];
        
        /**
         *  发布图片和内容到服务器
         */
        if (sendTopicView.titleTextField.text.length<1) {
            [self initMBProgress:@"标题不能为空" withModeType:MBProgressHUDModeText afterDelay:1];
            return;
        }
        
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSDictionary *params = @{@"Method":@"AddPostInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"2",@"Detail":@[@{@"ClassID":self.cate_id,@"Name":sendTopicView.titleTextField.text,@"IsShow":@"1",@"Detail":sendTopicView.contentTextView.text,@"Sort":@"",@"UserID":sharedInfo.user_id,@"IP":@"",@"ProvinceID":isStrEmpty(sharedInfo.area)?@"1":sharedInfo.area,@"CityID":isStrEmpty(sharedInfo.city)?@"1":sharedInfo.city}],@"Images":self.imagesArray};
        
        [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:params withMethod:@"POST" success:^(id result) {
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [self initMBProgress:@"发布成功" withModeType:MBProgressHUDModeText afterDelay:1];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kReloadDataNotification object:nil];
                }];
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
        if (sendTopicView.titleTextField.text.length<1) {
            [self initMBProgress:@"标题不能为空" withModeType:MBProgressHUDModeText afterDelay:1];
            return;
        }
        
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSDictionary *params = @{@"Method":@"AddPostInfo",@"RunnerUserID":sharedInfo.user_id,@"RunnerIsClient":@"1",@"RunnerIP":@"2",@"Detail":@[@{@"ClassID":self.cate_id,@"Name":sendTopicView.titleTextField.text,@"Detail":sendTopicView.contentTextView.text,@"Sort":@"",@"IP":@"",@"IsShow":@"1",@"UserID":sharedInfo.user_id,@"ProvinceID":isStrEmpty(sharedInfo.area)?@"1":sharedInfo.area,@"CityID":isStrEmpty(sharedInfo.city)?@"1":sharedInfo.city}]};
        
        [CKHttpRequest createRequest:HTTP_COMMAND_SEND_TOPIC WithParam:params withMethod:@"POST" success:^(id result) {
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [self initMBProgress:@"发布成功" withModeType:MBProgressHUDModeText afterDelay:1];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kReloadDataNotification object:nil];
                }];
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
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
