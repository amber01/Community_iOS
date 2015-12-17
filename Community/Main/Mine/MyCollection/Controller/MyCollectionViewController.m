//
//  MyCollectionViewController.m
//  Community
//
//  Created by amber on 15/12/17.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "MyCollectionViewController.h"

@interface MyCollectionViewController ()

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self getMyCollectionData:1];
}


#pragma mark -- UI

#pragma mark -- HTTP
- (void)getMyCollectionData:(int)pageIndex
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageIndex];
    SharedInfo *shared = [SharedInfo sharedDataInfo];
    NSDictionary *parameters = @{@"Method":@"ReMyCollectionInfo",@"Detail":@[@{@"UserID":shared.user_id,@"PageIndex":pageStr,@"PageSize":@"20",@"IsShow":@"888",@"FldSortType":@"1"}]};
    [CKHttpRequest createRequest:HTTP_METHOD_MY_COLLECTION WithParam:parameters withMethod:@"POST" success:^(id result) {
        NSLog(@"reslt:%@",result);
        if (result && [[result objectForKey:@"Success"]intValue] > 0) {
            [self initMBProgress:@"收藏成功" withModeType:MBProgressHUDModeText afterDelay:1.0];
        }
    } failure:^(NSError *erro) {
        
    }];
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
