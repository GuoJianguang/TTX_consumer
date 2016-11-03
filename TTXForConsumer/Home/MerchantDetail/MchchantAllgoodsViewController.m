//
//  MchchantAllgoodsViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MchchantAllgoodsViewController.h"
#import "GoodsListTableViewCell.h"
#import "GoodsDetailNewViewController.h"
#import "GoodsListViewController.h"

@interface MchchantAllgoodsViewController ()<UITableViewDelegate,UITableViewDataSource,BasenavigationDelegate>
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@end

@implementation MchchantAllgoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title  = @"所有商品";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.naviBar.detailTitle = @"逛逛商城";
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.delegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self searchReqest:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self searchReqest:NO];
    }];
    [self.tableView addNoDatasouceWithCallback:^{
        [self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有数据" andErrorImage:@"pic_2" andRefreshBtnHiden:YES];
    
    [self.tableView.mj_header beginRefreshing];
}
- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}

#pragma mark - BasenavigationDelegate

- (void)detailBtnClick
{
    GoodsListViewController *goodslistVC = [[GoodsListViewController alloc]init];
    [self.navigationController pushViewController:goodslistVC animated:YES];
}


- (void)searchReqest:(BOOL)isHeader
{
    NSDictionary *parms = @{@"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount,
                            @"mchCode":NullToSpace(self.mchChantCode)};
    [HttpClient GET:@"mch/goods/get" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            if (isHeader) {
                [self.dataSouceArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            }
            [self.tableView.mj_footer endRefreshing];
            NSArray *array = jsonObject[@"data"][@"data"];
            if (array.count > 0) {
                self.page ++;
            }
            for (NSDictionary *dic in array) {
                GoodsListModel *model = [GoodsListModel modelWithDic:dic];
                [self.dataSouceArray addObject:model];
            }
            //判断数据源有无数据
            [self.tableView judgeIsHaveDataSouce:self.dataSouceArray];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        //        self.keyWord = @"";
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView showRereshBtnwithALerString:@"网络连接不好"];
    }];
}
#pragma mark - UITalbeView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GoodsListTableViewCell indentify]];
    if (!cell) {
        cell = [GoodsListTableViewCell newCell];
    }
    if (self.dataSouceArray.count > 0) {
        cell.dataModel = self.dataSouceArray[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSouceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TWitdh*(80/320.);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        GoodsListModel *model = self.dataSouceArray[indexPath.row];
        GoodsDetailNewViewController *detailvC = [[GoodsDetailNewViewController alloc]init];
        detailvC.goodsID = model.goodsId;
        [self.navigationController pushViewController:detailvC animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
