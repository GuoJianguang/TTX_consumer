//
//  MessageViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/29.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageDetailViewController.h"


@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,BasenavigationDelegate>

@property (nonatomic, strong)NSMutableArray *datasouceArray;

@property (nonatomic, assign)NSInteger page;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.backgroundColor = [UIColor clearColor];
    self.naviBar.title = @"消息";
    self.naviBar.hiddenDetailBtn= NO;
    self.naviBar.detailTitle = @"全部已读";
    self.naviBar.delegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self alldetailReqest:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self alldetailReqest:NO];
    }];
    [self.tableView addNoDatasouceWithCallback:^{
        [self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂无历史记录" andErrorImage:@"pic_2" andRefreshBtnHiden:YES];
    
    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark - BasenavigationDelegate
- (void)detailBtnClick
{
    NSDictionary *dic = @{@"id":@"",
                          @"token":[TTXUserInfo shareUserInfos].token};
    [HttpClient POST:@"user/message/update" parameters:dic success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.tableView.mj_header beginRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"网络连接不好，请稍后重试" duration:2.];
    }];
}

- (void)alldetailReqest:(BOOL)isHeader
{
    NSDictionary *parms = @{@"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount,
                            @"token":[TTXUserInfo shareUserInfos].token};
    [HttpClient GET:@"user/message/get" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
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
                [self.datasouceArray addObject:[MessafeModel modelWithDic:dic]];
            }
            //判断数据源有无数据
            [self.tableView judgeIsHaveDataSouce:self.datasouceArray];
            [self.tableView reloadData];
            return ;
        }
        if (isHeader) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView showRereshBtnwithALerString:@"网络连接不好"];
        
    }];
}

#pragma mark - UITableView
- (NSMutableArray *)datasouceArray
{
    if (!_datasouceArray) {
        _datasouceArray = [NSMutableArray array];
    }
    return _datasouceArray;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasouceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return TWitdh*(200/750.);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = (MessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[MessageTableViewCell indentify]];
    if (!cell) {
        cell = [MessageTableViewCell newCell];
    }
    if (self.datasouceArray.count > 0) {
        cell.dataModel = self.datasouceArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageid = ((MessafeModel*)self.datasouceArray[indexPath.row]).messageid;
    NSDictionary *dic = @{@"id":messageid,
                          @"token":[TTXUserInfo shareUserInfos].token};
    [HttpClient POST:@"user/message/update" parameters:dic success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.tableView.mj_header beginRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
    MessageDetailViewController *detailVC = [[MessageDetailViewController alloc]init];
    detailVC.dataModel = self.datasouceArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
