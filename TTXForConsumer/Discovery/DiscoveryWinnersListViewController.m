//
//  DiscoveryWinnersListViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/22.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryWinnersListViewController.h"
#import "WinnerListTableViewCell.h"
#import "WinnerListHeaderTableViewCell.h"
#import "DiscoveryDeatailModel.h"

@interface DiscoveryWinnersListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@end

@implementation DiscoveryWinnersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"中奖名单";
    
    __weak DiscoveryWinnersListViewController *weak_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self getRequest:self.dataModel.detailId];
        
    }];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 中奖名单数据请求

- (void)getRequest:(NSString *)detailId
{
    NSDictionary *parms = @{@"id":detailId};
    [HttpClient POST:@"find/draw/awardWiner" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            for (NSString *phone in jsonObject[@"data"]) {
                [self.dataSouceArray  addObject:phone];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];

    }];

}


- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSouceArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        WinnerListHeaderTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:[WinnerListHeaderTableViewCell indentify]];
        if (!cell) {
            cell = [WinnerListHeaderTableViewCell newCell];
            
        }
        if (self.dataModel) {
            cell.dataModel = self.dataModel;
        }
        return cell;
    }
    WinnerListTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:[WinnerListTableViewCell indentify]];
    if (!cell) {
        cell = [WinnerListTableViewCell newCell];
    }
    if (self.dataSouceArray.count > 0) {
        cell.winnerPhoneNumber.text = self.dataSouceArray[indexPath.row - 1];
      cell.winnerPhoneNumber.text = [cell.winnerPhoneNumber.text stringByReplacingCharactersInRange:NSMakeRange(3,4)withString:@"****"];
    }
   
    

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return TWitdh * (40/75.) + 75;
    }

    return 44.;
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
