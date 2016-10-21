//
//  OderListViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "OderListViewController.h"
#import "SortCollectionViewCell.h"
#import "OrderTableViewCell.h"
#import "MallOrderModel.h"

@interface OderListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,BasenavigationDelegate>

@property (nonatomic, strong)NSMutableArray *sortDataSouceArray;
@property (nonatomic, strong)NSMutableArray *datasouceArray;

@property (nonatomic, assign)NSInteger page;
@end

@implementation OderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"我的订单";
    self.naviBar.delegate = self;
    __weak OderListViewController *weak_self = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getRequest:YES withType:self.orderType];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getRequest:NO withType:self.orderType];
        
    }];
    
    //添加无数据提醒
    [self.tableView addNoDatasouceWithCallback:^{
        [weak_self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"亲，暂无历史记录" andErrorImage:@"pic_2" andRefreshBtnHiden:YES];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentSuccess) name:@"commentSuccess" object:nil];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    NSDictionary *dic1 = @{@"name":@"全部",
                           @"isSelect":@0};
    MerchantSort *sort1 =[MerchantSort modelWithDic:dic1];
    NSDictionary *dic2 = @{@"name":@"已完成",
                           @"isSelect":@0};
    MerchantSort *sort2 =[MerchantSort modelWithDic:dic2];
    NSDictionary *dic3 = @{@"name":@"待收货",
                           @"isSelect":@0};
    MerchantSort *sort3 =[MerchantSort modelWithDic:dic3];
    NSDictionary *dic4 = @{@"name":@"待评价",
                           @"isSelect":@0};
    MerchantSort *sort4 =[MerchantSort modelWithDic:dic4];

    switch (self.orderType) {
        case Order_type_all:
            sort1.isSelect = YES;
            break;
        case Order_type_yetComplet:
            sort2.isSelect = YES;
            break;
        case Order_type_waitShipp:
            sort3.isSelect = YES;
            break;
        case Order_type_waitComment:
            sort4.isSelect = YES;
            break;
        default:
            break;
    }
    self.sortDataSouceArray = [NSMutableArray arrayWithArray:@[sort1,sort2,sort3]];
    [self.sortCollectionView reloadData];
}

#pragma mark - 评论成功

- (void)commentSuccess
{
    [self.tableView.mj_header beginRefreshing];

}


- (void)backBtnClick
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"commentSuccess" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络数据请求

- (void)getRequest:(BOOL)isHeader withType:(Order_type)type
{
    
    NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token,
                            @"searchFlag":@(type),
                            @"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount};
    
    [HttpClient POST:@"user/order/get" parameters:prams success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            if (isHeader) {
                [self.datasouceArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            }
            [self.tableView.mj_footer endRefreshing];
            NSArray *array = jsonObject[@"data"][@"data"];
            if (array.count > 0) {
                self.page ++;
            }
            for (NSDictionary *dic in array) {
                [self.datasouceArray addObject:[MallOrderModel modelWithDic:dic]];
            }
            //判断数据源有无数据
            [self.tableView judgeIsHaveDataSouce:self.datasouceArray];
            [self.tableView reloadData];
            return;
        }
        if (isHeader) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (isHeader) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView showRereshBtnwithALerString:@"点击刷新"];
        
    }];

}



#pragma mark- 懒加载

- (NSMutableArray *)datasouceArray
{
    if (!_datasouceArray) {
        _datasouceArray = [NSMutableArray array];
    }
    return _datasouceArray;
}
- (NSMutableArray *)sortDataSouceArray
{
    if (!_sortDataSouceArray) {
        _sortDataSouceArray = [NSMutableArray array];
    }
    return _sortDataSouceArray;
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
    [self.sortCollectionView reloadData];
    self.orderType = indexPath.item + 1;
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
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderTableViewCell indentify]];
    if (!cell) {
        cell = [OrderTableViewCell newCell];
    }
    if (self.datasouceArray.count > 0) {
        cell.dataModel = self.datasouceArray[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasouceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TWitdh/8. + 110 + 40. + 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
