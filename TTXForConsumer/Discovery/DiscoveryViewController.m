//
//  DiscoveryViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/16.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DiscoveryHomeTableViewCell.h"
#import "DiscoveryDetailViewController.h"




@interface DiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *datasouceArray;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviBar.title = @"发现";
    self.naviBar.hiddenBackBtn = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    __weak DiscoveryViewController *weak_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self getRequest];
    }];
   [ self.tableView addNoDatasouceWithCallback:^{
       [weak_self.tableView.mj_header beginRefreshing];
   } andAlertSting:@"暂时没有活动或者网络连接不好" andErrorImage:@"pic_2" andRefreshBtnHiden:NO];
    [self.tableView.mj_header beginRefreshing];
    
}


- (NSMutableArray *)datasouceArray
{
    if (!_datasouceArray) {
        _datasouceArray = [NSMutableArray array];
    }
    return _datasouceArray;
}



#pragma mark - 网络请求

- (void)getRequest{
    [HttpClient POST:@"find/list" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.datasouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            if (array.count ==0) {
                [self.tableView showNoDataSouce];
                [self.tableView reloadData];
                return;
            }
            for (NSDictionary *dic in array) {
                [self.datasouceArray addObject:[DiscoverHome modelWithDic:dic]];
            }
            [self.tableView hiddenNoDataSouce];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView showNoDataSouce];
    }];

}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasouceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        DiscoveryHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DiscoveryHomeTableViewCell indentify]];
        if (!cell) {
            cell = [DiscoveryHomeTableViewCell newCell];
        }
        cell.dataModel = self.datasouceArray[indexPath.row];
        return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TWitdh*(140/375.);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoverHome *model = self.datasouceArray[indexPath.row];
    switch ([model.jumpWay integerValue]) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:{// 抽奖活动
            DiscoveryDetailViewController *discoveryDV = [[DiscoveryDetailViewController alloc]init];
            discoveryDV.model = self.datasouceArray[indexPath.row];
            [self.navigationController pushViewController:discoveryDV animated:YES];
        }
            
            break;
            
        default:
            break;
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
