//
//  MerchantDetailViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/17.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MerchantDetailViewController.h"
#import "MerchantDetailTableViewCell.h"
#import "CommentTableViewCell.h"
#import "BussessDetailModel.h"
#import "GoodsListTableViewCell.h"

@interface MerchantDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)CGFloat height;

//获取评论列表的数据源
@property (nonatomic, strong)NSMutableArray *commentArray;

@property (nonatomic, strong)BussessDetailModel *dataModel;

@property (nonatomic, strong)NSMutableArray *goodsArray;

@end

@implementation MerchantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"商家详情";
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];

    self.height = 0;
    [self detailRequest:self.merchantCode];
//    [self getGoodsRequest:self.merchantCode];
//    [self detailRequest:@"12016011213260401100004"];
//    self.height = THeight*1.5;

}

#pragma mark - 商户详情接口请求
- (void)detailRequest:(NSString *)mchCode
{
    NSDictionary *parms = @{@"code":mchCode};
    [HttpClient GET:@"mch/get" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
//            self.dataSouceDic = jsonObject[@"data"];
            self.dataModel = [BussessDetailModel modelWithDic:jsonObject[@"data"]];
//            self.naviBar.title = self.dataModel.name;
            [self getGoodsRequest:self.merchantCode];
            if (![self.dataModel.desc isEqualToString:@""]) {
                self.height  = (TWitdh- 24)*(388/750.)+TWitdh*(154/750.)+TWitdh*(95/750.)+TWitdh*(95/750.)+ [self cellHeight:_dataModel.desc]+ 55. + 55;
            }else{
                self.height  = (TWitdh- 24)*(388/750.)+TWitdh*(154/750.)+TWitdh*(95/750.)+TWitdh*(95/750.);

            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)getGoodsRequest:(NSString *)mchCode
{
    NSDictionary *prams = @{@"mchCode":mchCode,
                            @"pageNo":@(1),
                            @"pageSize":@(2)};
    [HttpClient POST:@"mch/goods/get" parameters:prams success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.goodsArray removeAllObjects];
            NSArray *array = jsonObject[@"data"][@"data"];
            for (NSDictionary *dic in array) {
                [self.goodsArray addObject:[GoodsListModel modelWithDic:dic]];
            }
//            [self.goodsArray removeLastObject];
            if (self.goodsArray.count !=0) {
                self.height = self.height + 36 + 38 + 80*self.goodsArray.count;
            }
            [self commentRequest:self.merchantCode];
          
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
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
#pragma mark - 商户评论接口请求
- (void)commentRequest:(NSString *)mchCode
{
    NSDictionary *parms = @{@"mchCode":mchCode,
                            @"pageNo":@"1",
                            @"pageSize":@"5"};
    [HttpClient POST:@"mch/comment" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            NSArray *array = jsonObject[@"data"][@"data"];
            [self.commentArray removeAllObjects];
            for (NSDictionary *dic in array) {
                [self.commentArray addObject:[BussessComment modelWithDic:dic]];
            }
            if (self.commentArray.count !=0) {
                CGFloat commentHeight = 0;
                for (BussessComment *comment in self.commentArray) {
                    if (comment.replyFlag) {
                        commentHeight += 120;
                    }else{
                        commentHeight += 70;
                    }
                }
                self.height = self.height + 38 + commentHeight;
            }
            self.height += 80;
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - UITalbeView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MerchantDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MerchantDetailTableViewCell indentify]];
    if (!cell) {
        cell = [MerchantDetailTableViewCell newCell];
    }
    if (self.dataModel) {
        cell.dataModel = self.dataModel;
    }
    if (self.commentArray) {
        cell.commentArray  = self.commentArray;
    }
    cell.goodsArray = self.goodsArray;
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.height;
}


//- (void)refreshTableViewOfIntroduceView
//{
//    self.height = THeight ;
//    [self.tableView reloadData];
//
//}


#pragma mark - 计算cell的高度
- (CGFloat)cellHeight:(NSString *)textSting
{
    CGSize size = [textSting boundingRectWithSize:CGSizeMake(TWitdh  - 30, 0) font:[UIFont systemFontOfSize:13]];
    return size.height;
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
