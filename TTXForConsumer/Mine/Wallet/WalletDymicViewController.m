//
//  WalletDymicViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/23.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "WalletDymicViewController.h"
#import "SortCollectionViewCell.h"
#import "WalletTableViewCell.h"
#import "MyWallectCollectionViewCell.h"



@interface WalletDymicViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *sortDataSouceArray;

@property (nonatomic, strong)NSMutableArray *datasouceArray;

@property (nonatomic, assign)NSInteger page;

@end

@implementation WalletDymicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"钱包动态";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self RequestIsHeader:YES withType:self.walletType];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self RequestIsHeader:NO withType:self.walletType];
        
    }];
    
    //添加无数据提醒
    [self.tableView addNoDatasouceWithCallback:^{
        [self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"亲，暂无历史记录" andErrorImage:@"pic_2" andRefreshBtnHiden:YES];
    
    [self.tableView.mj_header beginRefreshing];

    NSDictionary *dic2 = @{@"name":@"余额支付",
                           @"isSelect":@0};
    MerchantSort *sort2 =[MerchantSort modelWithDic:dic2];
    NSDictionary *dic3 = @{@"name":@"推荐收益",
                           @"isSelect":@0};
    MerchantSort *sort3 =[MerchantSort modelWithDic:dic3];
    NSDictionary *dic4 = @{@"name":@"每日让利回馈",
                           @"isSelect":@0};
    MerchantSort *sort4 =[MerchantSort modelWithDic:dic4];
    if ([[TTXUserInfo shareUserInfos].feedbackCount integerValue] > 0) {
        sort4.isShowRedPoint = YES;
    }
    NSDictionary *dic5 = @{@"name":@"提现",
                           @"isSelect":@0};
    MerchantSort *sort5 =[MerchantSort modelWithDic:dic5];
    if ([[TTXUserInfo shareUserInfos].withdrawCount integerValue] > 0) {
        sort5.isShowRedPoint = YES;
    }
    switch (self.walletType) {
        case WalletDymic_type_yuE:
            sort2.isSelect = YES;

            break;
        case WalletDymic_type_tuiJian:
            sort3.isSelect = YES;

            break;
        case WalletDymic_type_fanXian:
            sort4.isSelect = YES;
            break;
        case WalletDymic_type_Tixian:
            sort5.isSelect = YES;
            break;
        default:
            break;
    }
    

    self.sortDataSouceArray = [NSMutableArray arrayWithArray:@[sort2,sort3,sort4,sort5]];
    [self.sortCollectionView reloadData];
    
}

#pragma mark- 懒加载

- (NSMutableArray *)sortDataSouceArray
{
    if (!_sortDataSouceArray) {
        _sortDataSouceArray = [NSMutableArray array];
    }
    return _sortDataSouceArray;
}

- (NSMutableArray *)datasouceArray
{
    if (!_datasouceArray) {
        _datasouceArray = [NSMutableArray array];
    }
    return _datasouceArray;
}

#pragma mark - 网络数据请求
//每日让利回馈
- (void)RequestIsHeader:(BOOL)isHeader withType:(WalletDymic_type)type
{
    
    
    NSDictionary *parms = @{@"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount,
                            @"token":[TTXUserInfo shareUserInfos].token};
    NSString *urlstirng = [NSString string];
    switch (type) {
        case WalletDymic_type_yuE:
            urlstirng = @"user/wallet/balancePay/get";
            break;
        case WalletDymic_type_tuiJian:
            urlstirng = @"user/recommendProfit/get";
            parms = @{@"pageNo":@(self.page),
                      @"pageSize":MacoRequestPageCount,
                      @"token":[TTXUserInfo shareUserInfos].token,
                      @"targetMchCode":@""};
            break;
        case WalletDymic_type_fanXian:
            urlstirng = @"user/wallet/feedback/get";
            break;
        case WalletDymic_type_Tixian:
            urlstirng = @"user/wallet/withdraw/get";
            break;
        default:
            break;
    }
    
    [HttpClient POST:urlstirng parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            if (isHeader) {
                [self.datasouceArray removeAllObjects];
                [self.tableView.mj_header  endRefreshing];
            }
            [self.tableView.mj_footer endRefreshing];
            NSArray *array = jsonObject[@"data"][@"data"];
            if (array.count > 0) {
                self.page ++;
            }
            switch (type) {
                case WalletDymic_type_yuE:
                    for (NSDictionary *dic in array) {
                        [self.datasouceArray addObject:[YuEPayModel modelWithDic:dic]];
                    }                    break;
                case WalletDymic_type_tuiJian:
                    for (NSDictionary *dic in array) {
                        [self.datasouceArray addObject:[InnitationModel modelWithDic:dic]];
                    }                    break;
                case WalletDymic_type_fanXian:
                    for (NSDictionary *dic in array) {
                        [self.datasouceArray addObject:[FanXianModel modelWithDic:dic]];
                    }                    break;
                case WalletDymic_type_Tixian:
                    for (NSDictionary *dic in array) {
                        [self.datasouceArray addObject:[TixianModel modelWithDic:dic]];
                    }
                    break;
                    
                default:
                    break;
            }

            //判断数据源有无数据
            [self.tableView judgeIsHaveDataSouce:self.datasouceArray];
            [self.tableView reloadData];
            return;
        }
        if (isHeader) {
            [self.tableView.mj_header  endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (isHeader) {
            [self.tableView.mj_header  endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView showRereshBtnwithALerString:@"网络连接不好"];
    }];
}

#pragma mark - 分类
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sortDataSouceArray.count;
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
    if (self.tableView.mj_header.isRefreshing || self.tableView.mj_footer.isRefreshing) {
        return;
    }
    for (MerchantSort *sort in self.sortDataSouceArray) {
        sort.isSelect = NO;
    }
    ((MerchantSort *)self.sortDataSouceArray[indexPath.item]).isSelect = YES;
    ((MerchantSort *)self.sortDataSouceArray[indexPath.item]).isShowRedPoint = NO;
    [self.sortCollectionView reloadData];
    
    self.walletType = indexPath.item + 1;
    [self.tableView.mj_header beginRefreshing];
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(TWitdh/self.sortDataSouceArray.count, 50);
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
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[WalletTableViewCell indentify]];
    if (!cell) {
        cell = [WalletTableViewCell newCell];
    }
    if (self.datasouceArray.count > 0) {
        
        switch (self.walletType) {
            case WalletDymic_type_yuE:
                if ([self.datasouceArray[indexPath.row] isKindOfClass:[YuEPayModel class]]) {
                    cell.yuEModel = self.datasouceArray[indexPath.row];
                }
                break;
            case WalletDymic_type_tuiJian:
                if ([self.datasouceArray[indexPath.row] isKindOfClass:[InnitationModel class]]) {
                    cell.tuijianModel = self.datasouceArray[indexPath.row];
                }
                break;
            case WalletDymic_type_fanXian:
                if ([self.datasouceArray[indexPath.row] isKindOfClass:[FanXianModel class]]) {
                    cell.fanxianModel = self.datasouceArray[indexPath.row];
                }
                break;
            case WalletDymic_type_Tixian:
                if ([self.datasouceArray[indexPath.row] isKindOfClass:[TixianModel class]]) {
                    cell.tixianModel = self.datasouceArray[indexPath.row];
                }
                break;
            default:
                break;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasouceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (TWitdh == 320) {
        return TWitdh* (150/750.);
    }
    return TWitdh* (140/750.);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
