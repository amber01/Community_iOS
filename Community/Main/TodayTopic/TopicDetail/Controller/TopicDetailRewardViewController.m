//
//  TopicDetailRewardViewController.m
//  Community
//
//  Created by shlity on 15/12/22.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicDetailRewardViewController.h"
#import "TopicDetailRewardTableViewCell.h"
#import "MineInfoViewController.h"

@interface TopicDetailRewardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView          *tableView;
@property (nonatomic,retain) NSMutableArray       *dataArray;

@end

@implementation TopicDetailRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打赏记录";
    [self setupTableView];
    [self setupRefreshHeader];
    [self getRewardData];
}

#pragma mark -- UI
- (UITableView *)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [UIUtils setExtraCellLineHidden:_tableView];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -- HTTP
- (void)getRewardData
{
    NSDictionary *parameters = @{@"Method":@"ReUserScoreLogInfo",@"Detail":@[@{@"Descrip":@"打赏",@"PostID":self.post_id,@"IsShow":@"888"}]};
    [CKHttpRequest  createRequest:HTTP_METHOD_SCORE_INFO WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        if (result) {
            if (self.dataArray) {
                [self.dataArray removeAllObjects];
            }
            self.dataArray = [result objectForKey:@"Detail"];
        }
        [_tableView reloadData];
    } failure:^(NSError *erro) {
        
    }];
}

#pragma mark -- MJRefreshHeader
- (void)setupRefreshHeader{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    //[header beginRefreshing];
    self.tableView.mj_header = header;
}
- (void)loadNewData{
    [self getRewardData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    TopicDetailRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[TopicDetailRewardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
        [cell.avatarBtn addTarget:self action:@selector(checkUserInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *imageURL = [NSString stringWithFormat:@"%@%@%@%@",[NSString stringWithFormat:@"http://%@.",[dic objectForKey:@"logopicturedomain"]],BASE_IMAGE_URL,face,[dic objectForKey:@"logopicture"]];
    [cell.avatarBtn sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_login.png"]];
    cell.scoreLabel.text = [[dic objectForKey:@"score"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cell.titleLabel.text = [dic objectForKey:@"nickname"];
    cell.avatarBtn.user_id = [dic objectForKey:@"userid"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- action
- (void)checkUserInfoBtn:(PubliButton *)button
{
    MineInfoViewController *mineInfoVC = [[MineInfoViewController alloc]init];
    mineInfoVC.user_id = button.user_id;
    [self.navigationController pushViewController:mineInfoVC animated:YES];
}

#pragma mark -- other
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
