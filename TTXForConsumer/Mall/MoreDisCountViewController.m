//
//  MoreDisCountViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/28.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "MoreDisCountViewController.h"
#import "DisCountTableViewCell.h"
#import "Watch.h"
#import "GoodsDetailNewViewController.h"

@interface MoreDisCountViewController ()
@property (nonatomic, strong)NSMutableArray *dataSouceArray;
@property (nonatomic, assign)NSInteger page;
@end

@implementation MoreDisCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"限时折扣";
    __weak MoreDisCountViewController *weak_self = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getGoodsListRequestIsHeader:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getGoodsListRequestIsHeader:NO];
        
    }];
    
    [self.tableView addNoDatasouceWithCallback:^{
        [weak_self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有相关的商品" andErrorImage:@"pic_1" andRefreshBtnHiden:YES];
    [self.tableView.mj_header beginRefreshing];

}

- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}

#pragma mark - 获取商品列表
- (void)getGoodsListRequestIsHeader:(BOOL)isHeader
{
    NSDictionary *parms = @{@"typeId":NullToNumber(self.typeId),
                            @"goodsName":NullToSpace(self.searchName),
                            @"sort":@"",
                            @"upDownFlag":@"",
                            @"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount,
                            @"disCountFlag":@"1"};
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpClient GET:@"shop/goodsList/get" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [SVProgressHUD dismiss];
        if (IsRequestTrue) {
            if (isHeader) {
                [self.dataSouceArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            NSArray *array = jsonObject[@"data"][@"data"];
            if (array.count > 0) {
                self.page ++;
            }
            for (NSDictionary *dic in array) {
                Watch *model = [Watch modelWithDic:dic];
                [self.dataSouceArray addObject:model];
            }
            [self.tableView reloadData];
            
            if (self.dataSouceArray.count ==0) {
                [self.tableView showNoDataSouce];
            }else{
                [self.tableView hiddenNoDataSouce];
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [SVProgressHUD dismiss];
        if (isHeader) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.dataSouceArray.count == 0) {
            [self.tableView showRereshBtnwithALerString:@"网络连接不好"];
        }
    }];
}


#pragma mark - UITalbeView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DisCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DisCountTableViewCell indentify]];
    if (!cell) {
        cell = [DisCountTableViewCell newCell];
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
    return TWitdh*(202/750.);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailNewViewController *detailVC = [[GoodsDetailNewViewController alloc]init];
    Watch *watch = self.dataSouceArray[indexPath.row];
    detailVC.isDisCount = YES;
    detailVC.goodsID = watch.mch_id;
    [self.navigationController pushViewController:detailVC animated:YES];
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
