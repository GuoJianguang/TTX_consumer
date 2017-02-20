//
//  NewMerchantDetailViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/20.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "NewMerchantDetailViewController.h"
#import "OnlinePayViewController.h"
#import "BussessDetailModel.h"
#import "NewMerchantDetailTableViewCell.h"
#import "GoodsListTableViewCell.h"

@interface NewMerchantDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *commentArray;
@property (nonatomic, strong)NSMutableArray *goodsArray;

@end

@implementation NewMerchantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view bringSubviewToFront:self.buyBtnView];
    self.buyBtn.backgroundColor = MacoColor;
    self.buyBtn.layer.cornerRadius = 35/2.;
    self.buyBtn.layer.masksToBounds = YES;
    
    self.naviBar.title = @"商家详情";
    
    __weak NewMerchantDetailViewController *weak_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self detailRequest:self.merchantCode];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


- (IBAction)buyBtn:(UIButton *)sender
{
    OnlinePayViewController *onlineVC = [[OnlinePayViewController alloc]init];
    onlineVC.dataModel = self.dataModel;
    [self.navigationController pushViewController:onlineVC animated:YES];
}


- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (NSMutableArray *)goodsArray
{
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

#pragma mark - 商户详情接口请求
- (void)detailRequest:(NSString *)mchCode
{
    NSDictionary *parms = @{@"code":mchCode};
    [HttpClient GET:@"mch/get" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [self.tableView.mj_header endRefreshing];
        if (IsRequestTrue) {
            self.dataModel = [BussessDetailModel modelWithDic:jsonObject[@"data"]];
            [self getGoodsRequest:self.merchantCode];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];

    }];
}

- (void)getGoodsRequest:(NSString *)mchCode
{
    NSDictionary *prams = @{@"mchCode":mchCode,
                            @"pageNo":@(1),
                            @"pageSize":@(2)};
    [HttpClient POST:@"mch/goods/get" parameters:prams success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.goodsArray removeAllObjects];
            NSArray *array = jsonObject[@"data"][@"data"];
            for (NSDictionary *dic in array) {
                [self.goodsArray addObject:[GoodsListModel modelWithDic:dic]];
            }
            [self.tableView reloadData];
            //            [self.goodsArray removeLastObject];
//            [self commentRequest:self.merchantCode];
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        
    }];
}

//#pragma mark - 商户评论接口请求
//- (void)commentRequest:(NSString *)mchCode
//{
//    NSDictionary *parms = @{@"mchCode":mchCode,
//                            @"pageNo":@"1",
//                            @"pageSize":@"5"};
//    [HttpClient POST:@"mch/comment" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
//        if (IsRequestTrue) {
//            NSArray *array = jsonObject[@"data"][@"data"];
//            [self.commentArray removeAllObjects];
//            for (NSDictionary *dic in array) {
//                [self.commentArray addObject:[BussessComment modelWithDic:dic]];
//            }
//            if (self.commentArray.count !=0) {
//                CGFloat commentHeight = 0;
//                for (BussessComment *comment in self.commentArray) {
//                    if (comment.replyFlag) {
//                        commentHeight += 120;
//                    }else{
//                        commentHeight += 70;
//                    }
//                }
//                self.height = self.height + 38 + commentHeight;
//            }
//            self.height += 80;
//            [self.tableView reloadData];
//        }
//    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        
//    }];
//}

#pragma mark - TalbeView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMerchantDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewMerchantDetailTableViewCell indentify]];
    if (!cell) {
        cell = [NewMerchantDetailTableViewCell newCell];
    }
    if (self.dataModel) {
        cell.dataModel = self.dataModel;
    }
    cell.goodsArray = self.goodsArray;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return THeight - 64- 60;
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
