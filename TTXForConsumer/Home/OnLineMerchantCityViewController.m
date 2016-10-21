//
//  OnLineMerchantCityViewController.m
//  TTXForConsumer
//
//  Created by Guo on 16/10/18.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "OnLineMerchantCityViewController.h"
#import "OnlineMerCityTableViewCell.h"
#import "GoodsSearchViewController.h"
#import "GoodsDetailNewViewController.h"
#import "OnlineMerCityCollectionViewCell.h"
#import "GoodsTableViewCell.h"
#import "Watch.h"


@interface OnLineMerchantCityViewController ()<UITableViewDelegate,UITableViewDataSource,BasenavigationDelegate>

@property (nonatomic, strong)NSMutableArray *venueDataSouceArray;

@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@property (nonatomic, strong)GoodsSearchViewController *searchVC;

@property (nonatomic, assign)NSInteger page;

@end

@implementation OnLineMerchantCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"线上商城";
    self.naviBar.detailImage = [UIImage imageNamed:@"icon_mall_search"];
    self.naviBar.delegate = self;
    self.naviBar.hiddenDetailBtn = NO;
    [self addChildViewController:self.searchVC];[self addChildViewController:self.searchVC];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self venceRequest];
        [self getGoodsListRequestIsHeader:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getGoodsListRequestIsHeader:NO];
        
    }];
    
    [self.tableView addNoDatasouceWithCallback:^{
        [self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有数据" andErrorImage:@"pic_2" andRefreshBtnHiden:YES];
    
    [self.tableView.mj_header beginRefreshing];
}


- (void)venceRequest
{
    [HttpClient POST:@"shop/goodsPavilions" parameters:nil success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.venueDataSouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                [self.venueDataSouceArray addObject:[VenceDataModel modelWithDic:dic]];
            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (GoodsSearchViewController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [[GoodsSearchViewController alloc]init];
        _searchVC.view.frame = CGRectMake(0, 0, TWitdh, THeight);
        
    }
    return _searchVC;
}

- (void)detailBtnClick
{
    self.searchVC.isSerach = YES;
    [self.view addSubview:self.searchVC.view];
}

- (NSMutableArray *)venueDataSouceArray
{
    if (!_venueDataSouceArray) {
        _venueDataSouceArray = [NSMutableArray array];
    }
    return _venueDataSouceArray;
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
    NSDictionary *parms = @{@"typeId":@"",
                            @"goodsName":@"",
                            @"sort":@"",
                            @"upDownFlag":@"",
                            @"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount,
                            @"pavilionId":@"",
                            @"activityId":@"",
                            @"recommend":@"1"};
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

#pragma mark - UITabelview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        OnlineMerCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OnlineMerCityTableViewCell indentify]];
        if (!cell) {
            cell = [OnlineMerCityTableViewCell newCell];
        }
        cell.venceArray = self.venueDataSouceArray;
        return cell;
    }
    
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GoodsTableViewCell indentify]];
    if (!cell) {
        cell = [GoodsTableViewCell newCell];
    }
    if (self.dataSouceArray.count > 0) {
        cell.dataModel = self.dataSouceArray[indexPath.row -1];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    GoodsDetailNewViewController *detailVC = [[GoodsDetailNewViewController alloc]init];
    Watch *watch = self.dataSouceArray[indexPath.row -1];
    detailVC.goodsID = watch.mch_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
       return TWitdh*(385/750.);
    }
    return THeight*(205/1334.);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSouceArray.count + 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
