
//
//  TopicSearchViewController.m
//  Community
//
//  Created by amber on 15/12/9.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicSearchViewController.h"
#import "TopicSearchBarView.h"
#import "TopicSearchTopView.h"

@interface TopicSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView    *_tableView;
    TopicSearchBarView      *topicSearchBarView;
}

@end

@implementation TopicSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackView];
    
    self.view.backgroundColor = CELL_COLOR;
    
    TopicSearchTopView *searchTopView = [[TopicSearchTopView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth, 42)];
    [searchTopView.segmentedView addTarget:self action:@selector(selectCatAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchTopView];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, ScreenWidth, ScreenHeight - 64 - 42) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [UIUtils setExtraCellLineHidden:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}


- (void)customBackView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];  //自定义返回按钮
    button.frame = CGRectMake(0, 0, 35, 35);
    [button setImage:[UIImage imageNamed:@"back_btn_image"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [self setHidesBottomBarWhenPushed:YES];
    
    topicSearchBarView = [[TopicSearchBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 125, 25)];
    topicSearchBarView.myTextField.delegate = self;
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithCustomView:topicSearchBarView];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, searchItem,nil];

    
    UIButton *serarchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serarchBtn.frame = CGRectMake(0, 0, 22, 22);
    [serarchBtn setImage:[UIImage imageNamed:@"topic_search_icon"] forState:UIControlStateNormal];
    [serarchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchItems = [[UIBarButtonItem alloc]initWithCustomView:serarchBtn];
    self.navigationItem.rightBarButtonItem = searchItems;
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 23;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    cell.textLabel.text = @"test";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -- action
- (void)selectCatAction
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
