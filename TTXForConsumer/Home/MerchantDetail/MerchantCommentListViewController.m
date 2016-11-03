//
//  MerchantCommentListViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/30.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MerchantCommentListViewController.h"
#import "CommentTableViewCell.h"

@interface MerchantCommentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *dataSouceArray;

@property (nonatomic, assign)NSInteger page;


@end

@implementation MerchantCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"评论";
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.code = @"12015120610213001100003";
//    self.code = @"12015112313415101100026";
    
    [self.tableView addNoDatasouceWithCallback:^{
        [self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有评论" andErrorImage:@"pic_3" andRefreshBtnHiden:YES];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self commentReqest:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self commentReqest:NO];
    }];
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark - 数据请求

- (void)commentReqest:(BOOL)isHeader
{
    NSDictionary *parms = @{@"mchCode":self.code,
                            @"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount};
    
    [HttpClient GET:@"mch/comment" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            if (isHeader) {
                [self.dataSouceArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            }
            [self.tableView.mj_footer endRefreshing];
            NSArray *array = jsonObject[@"data"][@"data"];
            if (array.count > 0) {
                self.page ++;
            }
            CGFloat tableHeight = 0;
            for (NSDictionary *dic in array) {
                BussessComment *comment = [BussessComment modelWithDic:dic];
                [self.dataSouceArray addObject:comment];
            }
            
            BussessComment *comment1 = [[BussessComment alloc]init];
            comment1.content = @"点击当会计课佳节快到家 记得哦我就到家当空间看大家快点放假啊姐姐地久服务看到就卡即可大家分开健康大家分开撒娇发的空间打开了减肥的空间当空间的空间打开垃圾的空间当空间疯狂啦时间的疯狂减肥的空间疯狂啦手机发的空间放的开减肥的空间发的快乐手机发的哭了说减肥的了空间打开减肥的空间fdklj";
            comment1.commentId = @"12";
            comment1.mchName = @"222";
            comment1.createTime = @"2016.2.3";
            comment1.userNickName = @"但都没看到";
            //            [self.dataSouceArray addObject:comment1];
            //判断数据源有无数据
            [self.tableView judgeIsHaveDataSouce:self.dataSouceArray];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.tableView showRereshBtnwithALerString:@"网络连接不好"];
        if (isHeader) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
}

#pragma mark - 懒加载

- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}
#pragma mark - UItableView;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommentTableViewCell indentify]];
    if (!cell) {
        cell = [CommentTableViewCell newCell];
    }
    cell.replayLabel.numberOfLines = 0;
    if (self.dataSouceArray.count > 0) {
        cell.dataModel = self.dataSouceArray[indexPath.row];
    }
    cell.detail_label.numberOfLines = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSouceArray.count > 0) {
        BussessComment *comment = self.dataSouceArray[indexPath.row];
        if (comment.replyFlag) {
            return 54 +[self cellHeight:comment.content] + [self replayCellHeight:[NSString stringWithFormat:@"商家回复:%@",comment.replyContent]] + 25;

        }else{
            return 54 +[self cellHeight:comment.content];
        }
    }
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataSouceArray.count;
}


#pragma mark - 计算cell的高度
- (CGFloat)cellHeight:(NSString *)textSting
{
    CGSize size = [textSting boundingRectWithSize:CGSizeMake(TWitdh  - 30, 0) font:[UIFont systemFontOfSize:13]];
    return size.height;
}

- (CGFloat)replayCellHeight:(NSString *)textSting
{
    CGSize size = [textSting boundingRectWithSize:CGSizeMake(TWitdh  - 46, 0) font:[UIFont systemFontOfSize:13]];
    return size.height;
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
