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
#import "CommentTableViewCell.h"

@interface NewMerchantDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *commentArray;
@property (nonatomic, strong)NSMutableArray *goodsArray;


@property (nonatomic, assign)CGFloat introduceHeight;


@property (nonatomic, assign)CGFloat goodsHeight;

@property (nonatomic, assign)CGFloat commentHeight;

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
        weak_self.introduceHeight = 0;
        weak_self.commentHeight = 0;
        weak_self.goodsHeight = 0;

        [weak_self detailRequest:self.merchantCode];
    }];
    
    [self.tableView addNoDatasouceWithCallback:^{
        self.tableView.scrollEnabled = YES;
        [self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"网络连接不好，请刷新重试！" andErrorImage:@"pic_4" andRefreshBtnHiden:YES];
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
            self.tableView.scrollEnabled = YES;
            [self.tableView hiddenNoDataSouce];
            self.dataModel = [BussessDetailModel modelWithDic:jsonObject[@"data"]];
            if (![self.dataModel.desc isEqualToString:@""]) {
                self.introduceHeight  = (TWitdh)*(19/30.)+TWitdh*(154/750.)+44+TWitdh*(88/750.)+TWitdh*(95/750.)*2+ [self cellHeight:_dataModel.desc]+ 55. + 55;
            }else{
                self.introduceHeight  = (TWitdh)*(19/30.)+TWitdh*(154/750.)+44+TWitdh*(88/750.)+TWitdh*(95/750.)*2;
                
            }
            [self getGoodsRequest:self.merchantCode];
            return ;
        }
        self.tableView.scrollEnabled = NO;
        [self.tableView showRereshBtnwithALerString:@"网络连接不好，请刷新重试"];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        self.tableView.scrollEnabled = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView showRereshBtnwithALerString:@"网络连接不好，请刷新重试"];
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
            self.goodsHeight = TWitdh*(19/30.)+TWitdh*(154/750.)+44+TWitdh*(88/750.) + 80*self.goodsArray.count + 38;

            [self commentRequest:self.merchantCode];
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        
    }];
}

#pragma mark - 商户评论接口请求
- (void)commentRequest:(NSString *)mchCode
{
    NSDictionary *parms = @{@"mchCode":mchCode,
                            @"pageNo":@"1",
                            @"pageSize":@"3"};
    [HttpClient POST:@"mch/comment" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            NSArray *array = jsonObject[@"data"][@"data"];
            [self.commentArray removeAllObjects];
            for (NSDictionary *dic in array) {
                [self.commentArray addObject:[BussessComment modelWithDic:dic]];
            }
            self.commentHeight = (TWitdh)*(19/30.)+TWitdh*(154/750.)+44+TWitdh*(88/750.);

            if (self.commentArray.count !=0) {
                CGFloat commentHeight = 0;
                for (BussessComment *comment in self.commentArray) {
                    if (comment.replyFlag) {
                        commentHeight += 120;
                    }else{
                        commentHeight += 70;
                    }
                }
                self.commentHeight = self.commentHeight + commentHeight;
            }
            self.commentHeight += 38;
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

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
    cell.commentArray = self.commentArray;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.introduceHeight>self.goodsHeight ? self.introduceHeight : self.goodsHeight;
    height = height > self.commentHeight ? height : self.commentHeight;
    return height;
}


#pragma mark - 计算cell的高度
- (CGFloat)cellHeight:(NSString *)textSting
{
    CGSize size = [textSting boundingRectWithSize:CGSizeMake(TWitdh  - 30, 0) font:[UIFont systemFontOfSize:13]];
    return size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
