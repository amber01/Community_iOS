//
//  DiscoverFindTopicViewController.m
//  Community
//
//  Created by amber on 16/4/10.
//  Copyright © 2016年 shlity. All rights reserved.
//

#import "DiscoverFindTopicViewController.h"
#import "DiscoverFindTopicTableViewCell.h"

@interface DiscoverFindTopicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UITableView     *tableView;
@property (nonatomic,retain)NSMutableArray  *dataArray;

@end

@implementation DiscoverFindTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_COLOR;
    [self tableView];

    [self getTopicData];
}

#pragma mark -- UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -2, ScreenWidth, ScreenHeight  - 64 - 49 - 20) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = VIEW_COLOR;
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma makr -- HTTP
- (void)getTopicData
{
    SharedInfo *sharedInfo = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ReHuatiClass",
                                 @"RunnerUserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,
                                 @"RunnerIP":@"",
                                 @"RunnerIsClient":@"1",
                                 @"Detail":@[@{@"UserID":isStrEmpty(sharedInfo.user_id) ? @"" : sharedInfo.user_id,
                                               }]};
    
    [CKHttpRequest createRequest:HTTP_SUB_CLASS_CATE WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"result:%@",result);
        
        NSArray *items = [result objectForKey:@"Detail"];
        NSMutableArray *array1 = [NSMutableArray new];
        NSMutableArray *array2 = [NSMutableArray new];
        NSMutableDictionary  *dataDic1 = [NSMutableDictionary new];
        NSMutableDictionary  *dataDic2 = [NSMutableDictionary new];
        
        for (int i = 0; i < items.count; i ++) {
            NSDictionary *dic = [items objectAtIndex:i];
            if ([[dic objectForKey:@"isfocus"]intValue] == 1) { //已关注
                [array1 addObject:items[i]];
            }else{ //未关注
                [array2 addObject:items[i]];
            }
        }
        
        [dataDic1 setObject:array1 forKey:@"topicInfo"];
        [dataDic2 setObject:array2 forKey:@"topicInfo"];
        
        if (!_dataArray) {
            _dataArray = [[NSMutableArray alloc]init];
        }
        [_dataArray addObject:dataDic1];
        [_dataArray addObject:dataDic2];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *erro) {
        
    }];
}
#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray  *tempArr = [[self.dataArray objectAtIndex:section] objectForKey:@"topicInfo"];
    return tempArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifyCell = @"cell";
    DiscoverFindTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyCell];
    if (!cell) {
        cell = [[DiscoverFindTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyCell];
        [cell.addFollowBtn addTarget:self action:@selector(addFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell configureCellWithInfo:self.dataArray WithIndexPath:indexPath];
    cell.addFollowBtn.indexPath = indexPath;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
        sectionView.backgroundColor = VIEW_COLOR;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        view.backgroundColor = [UIColor whiteColor];
        [sectionView addSubview:view];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, view.height)];
        label.font = kFont(16);
        label.text = @"更多话题";
        [view addSubview:label];
        
        return sectionView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 70;
    }
    return 0;
}

#pragma mark -- action
- (void)addFollowAction:(PubliButton *)button
{
    
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