//
//  TopLineViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/28.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "TopLineViewController.h"
#import "TopLineTableViewCell.h"
#import "NewMerchantDetailViewController.h"
#import "GoodsDetailNewViewController.h"

@interface TopLineViewController ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation TopLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"添客头条";
    self.tableView.backgroundColor = [UIColor clearColor];

    __weak TopLineViewController *weak_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self getActivityRequest];
    }];

    [self.tableView addNoDatasouceWithCallback:^{
        [self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有数据" andErrorImage:@"pic_1" andRefreshBtnHiden:YES];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 接口请求
- (void)getActivityRequest
{
    [HttpClient POST:@"shop/index/activity" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [self.tableView.mj_header endRefreshing];
        if (IsRequestTrue) {
            [self.dataSouceArray removeAllObjects];
            NSArray *lineListArray = jsonObject[@"data"][@"topLineList"];
            for (NSDictionary *dic in lineListArray) {
                [self.dataSouceArray addObject:[TopLineModel modelWithDic:dic]];
            }
            if (self.dataSouceArray.count == 0) {
                [self.tableView showNoDataSouce];
            }else{
                [self.tableView hiddenNoDataSouce];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.tableView showNoDataSouce];
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
    return self.dataSouceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return TWitdh*(203/759.);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TopLineTableViewCell indentify]];
    if (!cell) {
        cell = [TopLineTableViewCell newCell];
    }
    cell.dataModel = self.dataSouceArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TopLineModel *model = self.dataSouceArray[indexPath.row];
    switch ([model.jumpWay integerValue]) {
        case 1://跳转app商户详情
        {
            NewMerchantDetailViewController *merchantDvc = [[NewMerchantDetailViewController alloc]init];
            merchantDvc.merchantCode = model.jumpValue;
            [self.navigationController pushViewController:merchantDvc animated:YES];
            
        }
            break;
        case 2://跳转app产品详情
        {
            GoodsDetailNewViewController *goodsDVC = [[GoodsDetailNewViewController alloc]init];
            goodsDVC.goodsID = model.jumpValue;
            [self.navigationController pushViewController:goodsDVC animated:YES];
        }
            break;
        case 3://跳转网页
        {
            BaseHtmlViewController *htmlVC = [[BaseHtmlViewController alloc]init];
            htmlVC.htmlUrl = model.jumpValue;
            htmlVC.htmlTitle = model.name;
            [self.navigationController pushViewController:htmlVC animated:YES];
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
