//
//  MessageViewController.m
//  Community
//
//  Created by amber on 15/11/8.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MessageViewController.h"
#import "MsgCommentViewController.h"
#import "EaseMessageViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isLogin;
}

@property (nonatomic,retain) UITableView   *tableView;

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    const static char *cTitle[2][3] = {{"评论","顶","提到我的"},{"系统通知","user name"}};
    const static char *cImage[2][3] = {{"msg_comment","msg_like","msg_about_me"},{"msg_notification","msg_about_me"}};
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identityCell];
    }
    cell.textLabel.text = [NSString stringWithCString:cTitle[indexPath.section][indexPath.row] encoding:NSUTF8StringEncoding];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithCString:cImage[indexPath.section][indexPath.row] encoding:NSUTF8StringEncoding]];
    return cell;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MsgCommentViewController *msgCommentVC = [[MsgCommentViewController alloc]init];
            [self.navigationController pushViewController:msgCommentVC animated:YES];
        }else if (indexPath.row == 1){
            EaseMessageViewController *easeMessageVC = [[EaseMessageViewController alloc]initWithConversationChatter:@"CO-7631387" conversationType:eConversationTypeChat];
            easeMessageVC.title = @"CO-7631387";
            [easeMessageVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:easeMessageVC animated:YES];
        }
    }
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
