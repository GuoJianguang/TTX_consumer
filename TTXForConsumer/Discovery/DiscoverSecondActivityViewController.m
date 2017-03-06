//
//  DiscoverSecondActivityViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/22.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoverSecondActivityViewController.h"
#import "SecondActivityTableViewCell.h"

@interface DiscoverSecondActivityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@end

@implementation DiscoverSecondActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.title = @"添客圈";
    __weak DiscoverSecondActivityViewController *weak_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self getRequest];
    }];
    [self.tableView addNoDatasouceWithCallback:^{
        [weak_self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有数据或者网络连接不好" andErrorImage:@"pic_4" andRefreshBtnHiden:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [NSMutableArray array];
    }
    return _dataSouceArray;
}

#pragma mark - 网络请求

- (void)getRequest{
    [HttpClient POST:@"find/mch/list" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.dataSouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                [self.dataSouceArray addObject:[SecondACtivityModel modelWithDic:dic]];
            }
            if (self.dataSouceArray.count == 0) {
                [self.tableView showNoDataSouce];
            }else{
                [self.tableView hiddenNoDataSouce];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (self.dataSouceArray.count == 0) {
            [self.tableView showNoDataSouce];
        }else{
            [self.tableView hiddenNoDataSouce];
        }
        [self.tableView.mj_header endRefreshing];

    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSouceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondActivityTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:[SecondActivityTableViewCell indentify]];
    if (!cell) {
        cell = [SecondActivityTableViewCell newCell];
    }
    cell.dataModel = self.dataSouceArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (TWitdh -16)*(400/750.) + 50 + 8;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondACtivityModel *model = self.dataSouceArray[indexPath.row];
    switch ([model.jumpWay integerValue]) {
        case 3:
        {
            BaseHtmlViewController *htmlVC = [[BaseHtmlViewController alloc]init];
            htmlVC.htmlUrl = model.jumpValue;
            if ([model.remark isEqualToString:@""] ) {
                htmlVC.isAboutMerChant = NO;
            }else{
                htmlVC.isAboutMerChant = YES;
                htmlVC.merchantCode = model.remark;
            }
            htmlVC.htmlTitle = model.name;
            [self.navigationController pushViewController:htmlVC animated:YES];
        }
            
            break;
            
        default:
            break;
    }
    
    

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
