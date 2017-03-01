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
#import "GoodsSearchViewController.h"
#import "GoodsDetailNewViewController.h"
#import "FlagshipCollectionViewCell.h"
#import "TopLineModel.h"

@interface MallHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, assign)NSInteger page;

@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@property (nonatomic, strong)GoodsSearchViewController *searchVC;

@property (nonatomic, strong)NSMutableArray *flagShipDatasouceArray;

@property (nonatomic, strong)NSMutableArray *disCountDataSouceArray;
@property (nonatomic, strong)NSMutableArray *topLineDataSouceArray;


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

    [self addChildViewController:self.searchVC];

    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    __weak MallHomeViewController *weak_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self getGoodsListRequestIsHeader:YES];
        [weak_self getActivityRequest];
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


- (NSMutableArray *)flagShipDatasouceArray
{
    if (!_flagShipDatasouceArray) {
        _flagShipDatasouceArray = [NSMutableArray array];
    }
    return _flagShipDatasouceArray;
}

- (NSMutableArray *)disCountDataSouceArray
{
    if (!_disCountDataSouceArray) {
        _disCountDataSouceArray = [NSMutableArray array];
    }
    return _disCountDataSouceArray;
}

- (NSMutableArray *)topLineDataSouceArray
{
    if (!_topLineDataSouceArray) {
        _topLineDataSouceArray = [NSMutableArray array];
    }
    return _topLineDataSouceArray;
}


#pragma mark - 搜索的VC

- (GoodsSearchViewController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [[GoodsSearchViewController alloc]init];
        _searchVC.view.frame = CGRectMake(0, 0, TWitdh, THeight);
        
    }
    return _searchVC;
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
        cell.flagShipArray = self.flagShipDatasouceArray;
        cell.disCountArray = self.disCountDataSouceArray;
        cell.topLineArray = self.topLineDataSouceArray;
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
        if (self.flagShipDatasouceArray.count > 3) {
            return TWitdh*(1060./750.);
        }else{
            if (TWitdh > 320) {
                return TWitdh*(876./750.);
            }
            return TWitdh*(890./750.);

        }
        
    }
    return THeight*(205/1334.);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row < 2) {
        return;
    }
    
    GoodsDetailNewViewController *detailVC = [[GoodsDetailNewViewController alloc]init];
    Watch *watch = self.dataSouceArray[indexPath.row - 2];
    detailVC.goodsID = watch.mch_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}



- (void)getGoodsListRequestIsHeader:(BOOL)isHeader
{
    NSDictionary *parms = @{@"typeId":NullToNumber(@""),
                            @"goodsName":NullToSpace(@""),
                            @"sort":NullToSpace(@""),
                            @"upDownFlag":NullToSpace(@""),
                            @"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount,
                            };
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

#pragma mark

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.searchVC.isSerach = YES;
    [self.view addSubview:self.searchVC.view];
    [textField resignFirstResponder];
    
}



#pragma mark - 接口请求
- (void)getActivityRequest
{
    [HttpClient POST:@"shop/index/activity" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.flagShipDatasouceArray removeAllObjects];
            [self.disCountDataSouceArray removeAllObjects];
            [self.topLineDataSouceArray removeAllObjects];
            NSArray *flageshipArray = jsonObject[@"data"][@"flagshipList"];
            for (NSDictionary *dic in flageshipArray) {
                [self.flagShipDatasouceArray addObject:[FlagShipDataModel modelWithDic:dic]];
            }
            NSArray *disCounArray = jsonObject[@"data"][@"discountProduct"];
            for (NSDictionary *dic in disCounArray) {
                [self.disCountDataSouceArray addObject:[DiscountModel modelWithDic:dic]];
            }
            NSArray *lineListArray = jsonObject[@"data"][@"topLineList"];
            for (NSDictionary *dic in lineListArray) {
                [self.topLineDataSouceArray addObject:[TopLineModel modelWithDic:dic]];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
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
