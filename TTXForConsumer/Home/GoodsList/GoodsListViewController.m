//
//  GoodsListViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/21.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsListViewController.h"
#import "SortCollectionViewCell.h"
#import "GoodsTableViewCell.h"
#import "GoodsDetailNewViewController.h"
#import "Watch.h"
#import "GoodsSearchViewController.h"



@interface GoodsListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,BasenavigationDelegate>
//分类
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

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"商品";
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.detailImage = [UIImage imageNamed:@"icon_mall_search"];
    self.naviBar.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    __weak GoodsListViewController *weak_self = self;
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
    [self addChildViewController:self.searchVC];[self addChildViewController:self.searchVC];
    
    self.priceLabel.textColor = MacoTitleColor;
    [self.defaltBtn setTitleColor:MacoTitleColor forState:UIControlStateNormal];
    [self.saleBtn setTitleColor:MacoTitleColor forState:UIControlStateNormal];
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

#pragma mark - 获取商品列表
- (void)getGoodsListRequestIsHeader:(BOOL)isHeader
{
    NSDictionary *parms = @{@"typeId":NullToNumber(self.typeId),
                            @"goodsName":NullToSpace(self.searchName),
                            @"sort":NullToSpace(self.sort),
                            @"upDownFlag":NullToSpace(self.upDownFlag),
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
            NSDictionary *alldic = @{@"name":@"全部分类",
                                     @"isSelect":@1,
                                     @"id":@"0"};
            MerchantSort *allsort =[GoodsSort modelWithDic:alldic];
            NSDictionary *dic = @{@"name":@"更多",
                                  @"isSelect":@0};
            [self.sortDataSouceArray insertObject:allsort atIndex:0];
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



#pragma mark- 懒加载

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
    self.naviBar.title = ((GoodsSort *)self.sortDataSouceArray[indexPath.item]).name;
    [self.sortCollectionView reloadData];
    self.typeId = ((GoodsSort *)self.sortDataSouceArray[indexPath.item]).sortId;
    [self.tableView.mj_header beginRefreshing];
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sortDataSouceArray.count < 5) {
        return CGSizeMake(TWitdh/self.sortDataSouceArray.count, 50);
    }
    return CGSizeMake(TWitdh/4, 44);
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
    self.upDownFlag = @"down";
//    sender.selected = !sender.selected;
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
    self.naviBar.title = @"全部商品";
    self.typeId = @"";
    for (GoodsSort *sort in self.sortDataSouceArray) {
        sort.isSelect = NO;
    }
    [self.sortCollectionView reloadData];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
