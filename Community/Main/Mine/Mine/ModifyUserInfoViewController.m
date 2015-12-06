//
//  ModifyUserInfoViewController.m
//  Community
//
//  Created by amber on 15/11/30.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "ModifyUserInfoViewController.h"
#import "ModifyUserInfoTableViewCell.h"
#import "ModifyPasswordViewController.h"
#import "ModifyNicknameViewController.h"

@interface ModifyUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    NSMutableDictionary   *Exparams;
}

@property (nonatomic,retain)UITableView *tableView;

@end

@implementation ModifyUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改资料";
    Exparams = [[NSMutableDictionary alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataList) name:kReloadDataNotification object:nil];
    [self setupTableView];
}

- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sections[2] = {3,2};
    return sections[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    ModifyUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    const static char *cTitle[2][3] = {{"头像","性别","用户名"},{"修改密码","手机号"}};
    
    if (!cell) {
        cell = [[ModifyUserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [NSString stringWithCString:cTitle[indexPath.section][indexPath.row] encoding:NSUTF8StringEncoding];
    SharedInfo *shareInfo = [SharedInfo sharedDataInfo];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSString *originTel = shareInfo.mobile;
            NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            cell.detailTextLabel.text = tel;
        }
    }else if (indexPath.section == 0){
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",picturedomain,BASE_IMAGE_URL,face,shareInfo.picture]]placeholderImage:[UIImage imageNamed:@"mine_login"]];
        }else if (indexPath.row == 1){
            cell.detailTextLabel.text = shareInfo.sex;
        }else if (indexPath.row == 2){
            cell.detailTextLabel.text = shareInfo.nickname;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *actionSheet;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                actionSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择", @"立即拍照上传", nil];
            }
            else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
            }
            
            actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
            [actionSheet showInView:self.view];
        }else if (indexPath.row == 1){
            UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
            actionSheet.tag = 1001;
            actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
            [actionSheet showInView:self.view];
        }else if (indexPath.row == 2){
            ModifyNicknameViewController *modifyNicknameVC = [[ModifyNicknameViewController alloc]init];
            [self.navigationController pushViewController:modifyNicknameVC animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            ModifyPasswordViewController *modifyPasswordVC = [[ModifyPasswordViewController alloc]init];
            [self.navigationController pushViewController:modifyPasswordVC animated:YES];
        }
    }
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag != 1001) {
        //支持相机的情况下
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if (buttonIndex == 0) { //相册
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
                
            }else if (buttonIndex == 1){  //照相机
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }else{
            if (buttonIndex == 0) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
    }else{ //性别选择
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        if (buttonIndex == 0) {
            NSDictionary *params = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":sharedInfo.user_id,@"Detail":@[@{@"ID":sharedInfo.user_id,@"Sex":@"男",@"IsShow":@"2"}]};
            [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
                NSLog(@"result :%@",result);
                if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"男" forKey:@"picture"];
                    sharedInfo.sex = @"男";
                    [_tableView reloadData];
                }else{
                    [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.0];
                }
            } failure:^(NSError *erro) {
                
            }];
            
        }else if (buttonIndex == 1){
            NSDictionary *params = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":sharedInfo.user_id,@"Detail":@[@{@"ID":sharedInfo.user_id,@"Sex":@"女",@"IsShow":@"3"}]};
            [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
                if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"女" forKey:@"picture"];
                    sharedInfo.sex = @"女";
                    [_tableView reloadData];
                }else{
                    [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.0];
                }
            } failure:^(NSError *erro) {
                
            }];
        }
    }
}

#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //[self.view addSubview:img1];
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.0f);
    [Exparams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:imageData,@"picture", nil]];
    [self sendTopicImageToServer:Exparams];
}

#pragma mark --
- (void)reloadDataList
{
    [_tableView reloadData];
}

#pragma mark -- HTTP
//上传头像
- (void)sendTopicImageToServer:(NSMutableDictionary *)imageDic{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager POST:SEND_TOPIC_IMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //图片上传
        if (imageDic.count > 0) {
            for (NSString *key in [imageDic allKeys]) {
                [formData appendPartWithFileData:[imageDic objectForKey:key] name:key fileName:[NSString stringWithFormat:@"%@.jpg",key] mimeType:@"image/jpeg"];
            }
            [self initMBProgress:@""];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setMBProgreeHiden:YES];
        NSArray *imageArray = [responseObject objectForKey:@"Detail"];
        NSLog(@"response :%@",responseObject);
        NSDictionary *dic = [imageArray firstObject];
        
        NSString *pictureURL = [dic objectForKey:@"Picture"];
        NSString *pictureDomain = [dic objectForKey:@"PictureDomain"];
        
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        NSDictionary *params = @{@"Method":@"ModItemUserInfo",@"RunnerIP":@"",@"RunnerIsClient":@"",@"RunnerUserID":sharedInfo.user_id,@"Detail":@[@{@"ID":sharedInfo.user_id,@"Picture":pictureURL,@"PictureDomain":pictureDomain,@"IsShow":@"1"}]};
        
        [CKHttpRequest createRequest:HTTP_METHOD_REGISTER WithParam:params withMethod:@"POST" success:^(id result) {
            if (result && [[result objectForKey:@"Success"]intValue] > 0) {
                NSLog(@"result:%@",result);
                [[NSUserDefaults standardUserDefaults] setObject:pictureURL forKey:@"picture"];
                sharedInfo.picture = pictureURL;
                [_tableView reloadData];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }else{
                [self initMBProgress:[result objectForKey:@"Msg"] withModeType:MBProgressHUDModeText afterDelay:1.5];
            }
            
        } failure:^(NSError *erro) {
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



#pragma mark -- action

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
