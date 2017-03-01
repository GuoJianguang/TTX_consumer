//
//  DisCountViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/28.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DisCountViewController.h"
#import "SortCollectionViewCell.h"
#import "GoodsSearchViewController.h"
#import "Watch.h"
#import "DisCountTableViewCell.h"
#import "GoodsDetailNewViewController.h"

@interface DisCountViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

//分类数据源
@property (nonatomic, strong)NSMutableArray *sortDataSouceArray;

//商品列表数据源
@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@property (nonatomic, assign)NSInteger page;

//类型id
@property (nonatomic, strong)NSString *typeId;
//搜索的商品名称
@property (nonatomic, strong)NSString *searchName;
//排序方式取值：price （按价格）salenum(按销量)
@property (nonatomic, strong)NSString *sort;
//u升序 down 降序
@property (nonatomic, strong)NSString *upDownFlag;

@property (nonatomic, strong)GoodsSearchViewController *searchVC;


@end

@implementation DisCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"限时折扣";
    [self addChildViewController:self.searchVC];
    
    __weak DisCountViewController *weak_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getGoodsListRequestIsHeader:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getGoodsListRequestIsHeader:NO];
        
    }];
    
    [self.tableView addNoDatasouceWithCallback:^{
        [weak_self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有相关的商品" andErrorImage:@"pic_3" andRefreshBtnHiden:YES];

    [self getGoodsTypeRequest];
}

- (NSMutableArray *)sortDataSouceArray
{
    if (!_sortDataSouceArray) {
        _sortDataSouceArray = [NSMutableArray array];
    }
    return _sortDataSouceArray;
}

- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}
- (GoodsSearchViewController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [[GoodsSearchViewController alloc]init];
        _searchVC.view.frame = CGRectMake(0, 0, TWitdh, THeight);
        _searchVC.isDisCount = YES;
    }
    return _searchVC;
}

//获取所有商品类型
- (void)getGoodsTypeRequest
{
    [HttpClient GET:@"shop/goodsType/get" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.sortDataSouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                [self.sortDataSouceArray addObject:[GoodsSort modelWithDic:dic]];
            }
            NSDictionary *alldic = @{@"name":@"全部",
                                     @"isSelect":@1,
                                     @"id":@"0"};
            MerchantSort *allsort =[GoodsSort modelWithDic:alldic];
            [self.sortDataSouceArray insertObject:allsort atIndex:0];
            NSDictionary *dic = @{@"name":@"更多",
                                  @"isSelect":@0};
            GoodsSort *sort =[GoodsSort modelWithDic:dic];
            if (self.sortDataSouceArray.count > 4) {
                [self.sortDataSouceArray insertObject:sort atIndex:3];
            }else{
                [self.sortDataSouceArray addObject:sort];
            }
            ((GoodsSort*)self.sortDataSouceArray[0]).isSelect = YES;
            [self.sortCollectionView reloadData];
            [self.tableView.mj_header beginRefreshing];
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
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


#pragma mark - 分类
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.sortDataSouceArray.count < 5) {
        return self.sortDataSouceArray.count;
    }
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier =[SortCollectionViewCell indentify];
    static BOOL nibri =NO;
    if(!nibri)
    {
        UINib *nib = [SortCollectionViewCell newCell];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        nibri =YES;
    }
    SortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.goodsModel = self.sortDataSouceArray[indexPath.item];
    nibri=NO;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 3) {
        self.searchVC.isSerach = NO;
        [self.view addSubview:self.searchVC.view];
        return;
    }
    for (MerchantSort *sort in self.sortDataSouceArray) {
        sort.isSelect = NO;
    }
    ((GoodsSort *)self.sortDataSouceArray[indexPath.item]).isSelect = YES;
//    self.naviBar.title = ((GoodsSort *)self.sortDataSouceArray[indexPath.item]).name;
    [self.sortCollectionView reloadData];
    self.typeId = ((GoodsSort *)self.sortDataSouceArray[indexPath.item]).sortId;
    [self.tableView.mj_header beginRefreshing];
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sortDataSouceArray.count < 5) {
        return CGSizeMake(TWitdh/self.sortDataSouceArray.count, TWitdh *(9/75.));
    }
    return CGSizeMake(TWitdh/4, TWitdh *(9/75.));
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSouceArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailNewViewController *detailVC = [[GoodsDetailNewViewController alloc]init];
    Watch *watch = self.dataSouceArray[indexPath.row];
    detailVC.isDisCount = YES;
    detailVC.goodsID = watch.mch_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DisCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DisCountTableViewCell indentify]];
    if (!cell) {
        cell = [DisCountTableViewCell newCell];
    }
    cell.dataModel = self.dataSouceArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TWitdh*(202/750.);
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
