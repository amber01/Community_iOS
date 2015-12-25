//
//  MessageViewController.m
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MessageViewController.h"
#import "CommentStatusViewController.h"
#import "EaseMessageViewController.h"
#import "TopicLikeViewController.h"
#import "CommentLikeViewController.h"
#import "MessageTableViewCell.h"
#import "SystemNoticeViewController.h"
#import "TopicChatConversationCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL      isLogin;
    NSString  *commentNumber;
    NSString  *commentpraisenum;
    NSString  *postpraisenum;
    NSString  *sysmsgnum;
}

@property (nonatomic,retain) UITableView          *tableView;
@property (nonatomic,retain) NSMutableArray       *arrConversations;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"username"]length]> 0) {
        isLogin = YES;
    }else{
        isLogin = NO;
    }
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getMsgCount];
    
    //聊天管理器, 获取该对象后, 可以做登录、聊天、加好友等操作
    [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
    [self removeEmptyConversationsFromDB]; //清空空会话
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

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
    
    
    [self getChatDataList];
}

#pragma mark -- ChatData
- (void)getChatDataList
{
    self.arrConversations = (NSMutableArray *)[[EaseMob sharedInstance].chatManager conversations];
}

#pragma mark -- HTTP
- (void)getMsgCount
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    if (isStrEmpty(sharedInfo.user_id)) {
        [_tableView reloadData];
        return;
    }
    NSDictionary *parameters = @{@"Method":@"ReCommentInfoRead",@"Detail":@[@{@"UserID":sharedInfo.user_id}]};
    [CKHttpRequest createRequest:HTTP_METHOD_COMMENT WithParam:parameters withMethod:@"POST" success:^(id result) {
        if (result) {
            NSArray *item = [result objectForKey:@"Detail"];
            for (int i = 0; i < item.count; i ++ ) {
                NSDictionary *dic = [item objectAtIndex:i];
                commentNumber = [dic objectForKey:@"commentnum"];
                commentpraisenum = [dic objectForKey:@"commentpraisenum"];
                postpraisenum = [dic objectForKey:@"postpraisenum"];
                sysmsgnum = [dic objectForKey:@"sysmsgnum"];
            }
            if (([commentNumber intValue] + [commentpraisenum intValue] + [postpraisenum intValue] + [sysmsgnum intValue] > 0)) {
                
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationHideAlertDot object:nil];
            }
        }
        [_tableView reloadData];
       // NSLog(@"result:%@",result);
    } failure:^(NSError *erro) {
        
    }];

}

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else{
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        if (isStrEmpty(sharedInfo.user_id)) {
            return 1;
        }else{
            return self.arrConversations.count + 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identityCell = @"cell";
        MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
        NSArray * cTitle = @[@"评论",@"帖子点赞",@"评论点赞"];
        NSArray * cImage = @[@"msg_comment",@"msg_like",@"msg_about_me"];
        
        if (!cell) {
            cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
        cell.textLabel.text = cTitle[indexPath.row];
        cell.imageView.image  = [UIImage imageNamed:cImage[indexPath.row]];
        
        if (!isStrEmpty(sharedInfo.user_id)) {
            
            if (indexPath.row == 0) {
                if ([commentNumber intValue] > 0) {
                    cell.tipsView.hidden = NO;
                    cell.tipsLabel.text = commentNumber;
                }else{
                    cell.tipsView.hidden = YES;
                }
            }else if (indexPath.row == 1){
                if ([postpraisenum intValue] > 0) {
                    cell.tipsView.hidden = NO;
                    cell.tipsLabel.text = postpraisenum;
                }else{
                    cell.tipsView.hidden = YES;
                }
            }else if (indexPath.row == 2){
                if ([commentpraisenum intValue] > 0) {
                    cell.tipsView.hidden = NO;
                    cell.tipsLabel.text = commentpraisenum;
                }else{
                    cell.tipsView.hidden = YES;
                }
            }
        }else{
            cell.tipsView.hidden = YES;
        }
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            static NSString *identityCell = @"noticeCell";
            MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
            if (!cell) {
                cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"系统通知";
            cell.imageView.image  = [UIImage imageNamed:@"msg_notification"];
            
            if (indexPath.row == 0) {
                if ([sysmsgnum intValue] > 0) {
                    cell.tipsView.hidden = NO;
                    cell.tipsLabel.text = sysmsgnum;
                }else{
                    cell.tipsView.hidden = YES;
                }
            }else{
                cell.tipsView.hidden = YES;
            }
            return cell;
        }else{
            static NSString *identityCell = @"chatCell";
            TopicChatConversationCell *cell  = [tableView dequeueReusableCellWithIdentifier:identityCell];
            if (!cell) {
                cell = [[TopicChatConversationCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
            }
            SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
            if (!isStrEmpty(sharedInfo.user_id)) {
                EMConversation *conversation = [self.arrConversations objectAtIndex:indexPath.row-1];
                
                NSLog(@"conversation:%@",conversation);
                
                //单聊会话
                if (conversation.conversationType == eConversationTypeChat) {
                    
                    cell.labMsg.text = [self subTitleMessageByConversation:conversation];
                    //cell.imgHeader.image = [UIImage imageNamed:@"chatListCellHead"];
                    NSString *nickName = [conversation.ext objectForKey:@"nickName"];
                    NSString *avatarURL = [conversation.ext objectForKey:@"avatarURL"];
                    cell.labName.text = nickName;
                    NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",sharedInfo.picturedomain],BASE_IMAGE_URL,face,avatarURL];
                    //NSLog(@"extaaa:%@",conversation.ext);
                    [cell.imgHeader sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"mine_login"]];
                    EMMessage *lastMessage = [conversation latestMessage];
                    
                    NSLog(@"nick name:%@",nickName);
                    
                    //会话列表中收到别人的消息的时候
                    if (isStrEmpty(nickName)) {
                        NSString *lastMegNickName = [lastMessage.ext objectForKey:@"nickName"];
                        NSString *lastMegAvatarURL = [lastMessage.ext objectForKey:@"avatarURL"];
                        cell.labName.text = lastMegNickName;
                        NSString *lastMsgImageURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",sharedInfo.picturedomain],BASE_IMAGE_URL,face,lastMegAvatarURL];
                        [cell.imgHeader sd_setImageWithURL:[NSURL URLWithString:lastMsgImageURL] placeholderImage:[UIImage imageNamed:@"mine_login"]];
                    }
                    
                    //NSLog(@"lastMessage:%@",lastMessage.ext);
                    cell.labTime.text = [UIUtils convertDateToString:[NSString stringWithFormat:@"%zd",lastMessage.timestamp]];
                }
            }
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return CGFLOAT_MIN;
    }
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.f)];
        CGRect frameRect = CGRectMake(15, 50/2 - 10, 100, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
        label.textColor = TEXT_COLOR;
        [label setFont:[UIFont systemFontOfSize:14]];
        label.text=@"私信联系人";
        [sectionView addSubview:label];
        return sectionView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isStrEmpty(sharedInfo.user_id)) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [loginVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CommentStatusViewController *msgCommentVC = [[CommentStatusViewController alloc]init];
            [msgCommentVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:msgCommentVC animated:YES];
        }else if (indexPath.row == 1){
            TopicLikeViewController *topicLikeVC = [[TopicLikeViewController alloc]init];
            [topicLikeVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:topicLikeVC animated:YES];
        }else if (indexPath.row ==2 ){
            CommentLikeViewController *commentLikeVC = [[CommentLikeViewController alloc]init];
            [commentLikeVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:commentLikeVC animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            SystemNoticeViewController *systemNoticeView = [[SystemNoticeViewController alloc]init];
            [systemNoticeView setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:systemNoticeView animated:YES];
        }else{
            
            EMConversation *conversation = [self.arrConversations objectAtIndex:indexPath.row-1];
            NSString *nickName = [conversation.ext objectForKey:@"nickName"];
            NSString *avatarURL = [conversation.ext objectForKey:@"avatarURL"];
            
            EMMessage *lastMessage = [conversation latestMessage];
            NSString *lastMegNickName = [lastMessage.ext objectForKey:@"nickName"];
            NSString *lastMegAvatarURL = [lastMessage.ext objectForKey:@"avatarURL"];
            //NSString *lastMegUserName = [lastMessage.ext objectForKey:@"userName"];
            
            //查看用户发送给我的消息的情况下
            if (isStrEmpty(nickName)) {
                EaseMessageViewController *easeMessageVC = [[EaseMessageViewController alloc]initWithConversationChatter:conversation.chatter conversationType:eConversationTypeChat];
                easeMessageVC.nickname = lastMegNickName;
                easeMessageVC.avatarUrl = lastMegAvatarURL;
                easeMessageVC.title = lastMegNickName;
                [easeMessageVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:easeMessageVC animated:YES];
            }else{
                
                EaseMessageViewController *easeMessageVC = [[EaseMessageViewController alloc]initWithConversationChatter:conversation.chatter conversationType:eConversationTypeChat];
                easeMessageVC.nickname = nickName;
                easeMessageVC.avatarUrl = avatarURL;
                easeMessageVC.title = nickName;
                [easeMessageVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:easeMessageVC animated:YES];
            }
        }
    }
}

//得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
                //图像类型
            case eMessageBodyType_Image:
            {
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
                //文本类型
            case eMessageBodyType_Text:
            {
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];  //表情映射
                ret = didReceiveText;
            } break;
                //语音类型
            case eMessageBodyType_Voice:
            {
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
                //位置类型
            case eMessageBodyType_Location:
            {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
                //视频类型
            case eMessageBodyType_Video:
            {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
                
            default:
                break;
        }
    }
    
    return ret;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
