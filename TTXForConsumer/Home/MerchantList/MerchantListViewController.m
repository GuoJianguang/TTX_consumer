//
//  MerchantListViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/20.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MerchantListViewController.h"
#import "SortCollectionViewCell.h"
#import "MerchantTableViewCell.h"
#import "HomeBusinessListTableViewCell.h"
#import "MerchantDetailViewController.h"
#import "MerchantSearchViewController.h"
#import "MerchantSearchResultViewController.h"


@interface MerchantListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,BasenavigationDelegate,MerchantSearchViewDelegate>

@property (nonatomic, strong)NSMutableArray *sortDataSouceArray;

@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@property (nonatomic, assign)NSInteger page;
//当前选择行业
@property (nonatomic, strong)NSString *currentIndustry;

@property (nonatomic, strong)MerchantSearchViewController *searchVC;

@property (nonatomic, assign)BOOL isContinueRequest;

@end

@implementation MerchantListViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"商家";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.sortCollectionView.scrollEnabled = NO;
    self.sortCollectionView.backgroundColor = [UIColor whiteColor];
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.detailImage = [UIImage imageNamed:@"icon_mall_search"];
    self.naviBar.delegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isContinueRequest = YES;
        [self searchReqest:YES andCity:self.currentCity];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self searchReqest:NO andCity:self.currentCity];
    }];
    [self.tableView addNoDatasouceWithCallback:^{
        [self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有数据" andErrorImage:@"pic_2" andRefreshBtnHiden:YES];
    //行业类别的网络请求
    [self sortRequest];

    [self addChildViewController:self.searchVC];
}

- (MerchantSearchViewController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [[MerchantSearchViewController alloc]init];
        _searchVC.delegate = self;
        _searchVC.view.frame = CGRectMake(0, 0, TWitdh, THeight);
    }
    return _searchVC;
}


- (void)backBtnClick
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"chooseSort" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailBtnClick
{
    self.searchVC.isSerach = YES;
    [self.view addSubview:self.searchVC.view];

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
    cell.dataModel = self.sortDataSouceArray[indexPath.item];
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
    
    ((MerchantSort *)self.sortDataSouceArray[indexPath.item]).isSelect = YES;
    [self.sortCollectionView reloadData];
    self.currentIndustry = ((MerchantSort *)self.sortDataSouceArray[indexPath.item]).sortName;
    [self.tableView.mj_header beginRefreshing];
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sortDataSouceArray.count < 5) {
        return CGSizeMake(TWitdh/self.sortDataSouceArray.count, 50);
    }
    return CGSizeMake(TWitdh/4, 50);
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

#pragma mark - 商家类别的请求
- (void)sortRequest
{
    [HttpClient GET:@"mch/trades" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.sortDataSouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                [self.sortDataSouceArray addObject:[MerchantSort modelWithDic:dic]];
            }
            NSDictionary *alldic = @{@"name":@"全部分类",
                                  @"isSelect":@0};
            MerchantSort *allsort =[MerchantSort modelWithDic:alldic];
            NSDictionary *dic = @{@"name":@"更多分类",
                                   @"isSelect":@0};
            MerchantSort *sort =[MerchantSort modelWithDic:dic];
            [self.sortDataSouceArray insertObject:allsort atIndex:0];
            if (self.sortDataSouceArray.count > 4) {
                [self.sortDataSouceArray insertObject:sort atIndex:3];
            }else{
                [self.sortDataSouceArray addObject:sort];
            }
            
            ((MerchantSort*)self.sortDataSouceArray[0]).isSelect = YES;
            self.currentIndustry = ((MerchantSort*)self.sortDataSouceArray[0]).sortName;
            [self.sortCollectionView reloadData];
            [self.tableView.mj_header beginRefreshing];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}


#pragma mark - 请求商家列表的网络请求
- (void)searchReqest:(BOOL)isHeader andCity:(NSString *)city
{
//    if (!isHeader && !self.isContinueRequest) {
//        [self.tableView.mj_footer endRefreshing];
//        return;
//    }
    NSString *searchcity = [self.currentCity substringToIndex:2];
    if ([self.currentIndustry isEqualToString:@"全部分类"]) {
        self.currentIndustry = @"";
    }
    NSDictionary *parms = @{@"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount,
                            @"trade":NullToSpace(self.currentIndustry),
                            @"mchCity":searchcity,
                            @"keyword":NullToSpace(self.keyWord),
                            @"longitude":@([TTXUserInfo shareUserInfos].locationCoordinate.longitude),
                            @"latitude":@([TTXUserInfo shareUserInfos].locationCoordinate.latitude)};
    [HttpClient GET:@"mch/search" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            if (self.page == [NullToNumber(jsonObject[@"data"][@"totalPage"]) integerValue]) {
                self.isContinueRequest= NO;
            }
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
                HomeBusinessList *model = [HomeBusinessList modelWithDic:dic];
                model.isSearchResult = YES;
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
    MerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MerchantTableViewCell indentify]];
    if (!cell) {
        cell = [MerchantTableViewCell newCell];
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
    return TWitdh*(220/750.);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MerchantDetailViewController *merchantDVC = [[MerchantDetailViewController alloc]init];
    HomeBusinessList *model = self.dataSouceArray[indexPath.row];
    merchantDVC.merchantCode = model.code;
    [self.navigationController pushViewController:merchantDVC animated:YES];
}


#pragma mark - MerchantSearchViewDelegate
- (void)cancelSearch
{
    [self.searchVC.view removeFromSuperview];
}


- (void)sureSearch:(NSString *)keyWord city:(NSString *)cityName
{
    [self.searchVC.view removeFromSuperview];
    MerchantSearchResultViewController *resultVC = [[MerchantSearchResultViewController alloc]init];
    resultVC.currentIndustry = @"";
    resultVC.keyWord = keyWord;
    resultVC.currentCity = cityName;
    [self.navigationController pushViewController:resultVC animated:YES];
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
