//
//  GoodsSearchRsultViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsSearchRsultViewController.h"
#import "GoodsTableViewCell.h"
#import "GoodsDetailNewViewController.h"
#import "Watch.h"

@interface GoodsSearchRsultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataSouceArray;
@property (nonatomic, assign)NSInteger page;


@end

@implementation GoodsSearchRsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = self.venceName;
    
    __weak GoodsSearchRsultViewController *weak_self = self;
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
    
    self.priceLabel.textColor = MacoTitleColor;
    [self.defaltBtn setTitleColor:MacoTitleColor forState:UIControlStateNormal];
    [self.saleBtn setTitleColor:MacoTitleColor forState:UIControlStateNormal];
    
}
#pragma mark - 获取商品列表
- (void)getGoodsListRequestIsHeader:(BOOL)isHeader
{
    NSDictionary *parms = @{@"typeId":NullToNumber(self.typeId),
                            @"goodsName":NullToSpace(self.searchName),
                            @"sort":NullToSpace(self.sort),
                            @"upDownFlag":NullToSpace(self.upDownFlag),
                            @"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount,
                            @"pavilionId":NullToSpace(self.venceId),
                            @"activityId":NullToSpace(self.activityId),
                            @"recommend":@""};
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpClient GET:@"shop/goodsList/get" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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


#pragma mark- 懒加载

- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}

#pragma mark - UITalbeView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GoodsTableViewCell indentify]];
    if (!cell) {
        cell = [GoodsTableViewCell newCell];
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
    return THeight*(205/1334.);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailNewViewController *detailVC = [[GoodsDetailNewViewController alloc]init];
    Watch *watch = self.dataSouceArray[indexPath.row];
    detailVC.goodsID = watch.mch_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - 价格排序
- (IBAction)saleBtn:(UIButton *)sender {
    [sender setTitleColor:MacoPriceColor forState:UIControlStateNormal];
    [self.defaltBtn setTitleColor:MacoTitleColor forState:UIControlStateNormal];
    self.priceImage.image = [UIImage imageNamed:@"icon_mall_price_ranking_nor"];
    sender.selected = !sender.selected;
    self.upDownFlag = @"down";
//    if (sender.selected) {
//        self.upDownFlag = @"down";
//    }else{
//        self.upDownFlag = @"up";
//    }
    self.sort = @"salenum";
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 销量排序
- (IBAction)priceBtn:(UIButton *)sender {
    [self.defaltBtn setTitleColor:MacoTitleColor forState:UIControlStateNormal];
    [self.saleBtn setTitleColor:MacoTitleColor forState:UIControlStateNormal];
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.priceImage.image = [UIImage imageNamed:@"icon_mall_from_high_to_low_sel"];
        self.upDownFlag = @"down";
    }else{
        self.priceImage.image = [UIImage imageNamed:@"icon_mall_from_low_to_high_sel"];
        self.upDownFlag = @"up";
    }
    self.sort = @"price";
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 默认
- (IBAction)defaultBtn:(UIButton *)sender {
    self.priceImage.image = [UIImage imageNamed:@"icon_mall_price_ranking_nor"];
    [self.saleBtn setTitleColor:MacoTitleColor forState:UIControlStateNormal];
    [sender setTitleColor:MacoPriceColor forState:UIControlStateNormal];
    self.sort = @"";
    [self.tableView.mj_header beginRefreshing];
    
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
