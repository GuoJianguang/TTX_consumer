//
//  MallHomeViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/23.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "MallHomeViewController.h"
#import "GoodsIndustryTableViewCell.h"
#import "MallDetailTableViewCell.h"
#import "Watch.h"
#import "GoodsTableViewCell.h"


@interface MallHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)NSInteger page;

@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@end

@implementation MallHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.hidden = YES;
    self.navigationBarView.layer.cornerRadius = self.navigationBarView.bounds.size.height/2;
    self.navigationBarView.layer.masksToBounds = YES;
    self.navigationBarView.layer.borderWidth = 1;
    self.navigationBarView.backgroundColor = [UIColor whiteColor];
    self.navigationBarView.layer.borderColor = MacolayerColor.CGColor;
    [self setAutomaticallyAdjustsScrollViewInsets:YES];

    self.tableView.backgroundColor = [UIColor clearColor];
    
    __weak MallHomeViewController *weak_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self getGoodsListRequestIsHeader:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weak_self getGoodsListRequestIsHeader:NO];
        
    }];

    [self.tableView.mj_header beginRefreshing];
    
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
    return self.dataSouceArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        GoodsIndustryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GoodsIndustryTableViewCell indentify]];
        if (!cell) {
            cell = [GoodsIndustryTableViewCell newCell];
        }
        return cell;
    }

    if (indexPath.row == 1) {
        MallDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MallDetailTableViewCell indentify]];
        if (!cell) {
            cell = [MallDetailTableViewCell newCell];
        }
        return cell;
    
    }else{
        GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GoodsTableViewCell indentify]];
        if (!cell) {
            cell = [GoodsTableViewCell newCell];
        }
        cell.dataModel = self.dataSouceArray[indexPath.row - 2];
        return cell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CGFloat intervalX = 50.0;/**<横向间隔*/
        CGFloat intervalY = 15.0;/**<纵向间隔*/
        NSInteger columnNum = 4;/**<九宫格列数*/
        CGFloat widthAndHeightRatio = 2.0/3.0;/**<宽高比*/
        CGFloat buttonWidth = (TWitdh - 40 - intervalX * (columnNum - 1))/(CGFloat)columnNum;/**<button的宽度*/
        CGFloat buttonHeight = buttonWidth/widthAndHeightRatio;/**<button的高度*/
        return buttonHeight * 2 + intervalY*2 + 18;
    }else if (indexPath.row == 1){
        return TWitdh*(400/320.);
    }
    return THeight*(205/1334.);
;
}




- (void)getGoodsListRequestIsHeader:(BOOL)isHeader
{
    NSDictionary *parms = @{@"typeId":NullToNumber(@""),
                            @"goodsName":NullToSpace(@""),
                            @"sort":NullToSpace(@""),
                            @"upDownFlag":NullToSpace(@""),
                            @"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount};
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
