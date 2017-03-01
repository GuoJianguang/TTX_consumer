//
//  DiscoveryDetailViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/17.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryDetailViewController.h"
#import "DiscoveryWaitTableViewCell.h"
#import "DisCoverYetTableViewCell.h"
#import "DiscoveryDeatailModel.h"
#import "DiscoveryPayView.h"

@interface DiscoveryDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BasenavigationDelegate>


@property (nonatomic, assign)NSInteger page;

@property (nonatomic, strong)NSMutableArray *dataSocueArray;

@property (nonatomic, assign)BOOL isFirstEnd;

//支付的view
@property (nonatomic, strong)DiscoveryPayView *payView;

@property (nonatomic, strong)NSString *htmlUrl;


@end

@implementation DiscoveryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.detailImage = [UIImage imageNamed:@"icon_explain"];
    self.naviBar.delegate = self;
    self.naviBar.title = self.model.name;
    if (!self.model) {
        self.naviBar.title = @"活动";
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.isFirstEnd = YES;
    
    __weak DiscoveryDetailViewController * weak_self = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self getDetailRequest:YES];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weak_self getDetailRequest:NO];
    }];
    
    [self.tableView addNoDatasouceWithCallback:^{
        [weak_self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"网络连接不好，请重试" andErrorImage:@"pic_2" andRefreshBtnHiden:NO];
    [weak_self.tableView.mj_header beginRefreshing];
    
}


- (NSMutableArray *)dataSocueArray
{
    if (!_dataSocueArray) {
        _dataSocueArray = [NSMutableArray array];
    }
    return _dataSocueArray;
}

- (DiscoveryPayView *)payView
{
    if (!_payView) {
        _payView = [[DiscoveryPayView alloc]init];
//        _payView.delegate = self;
    }
    return _payView;
}

- (NSString *)htmlUrl
{
    if (!_htmlUrl) {
        _htmlUrl = [NSString string];
    }
    return _htmlUrl;
}

#pragma mark - 帮助
- (void)detailBtnClick{
    
    BaseHtmlViewController *htmlVC = [[BaseHtmlViewController alloc]init];
    htmlVC.htmlTitle = @"活动说明";
    htmlVC.htmlUrl = self.htmlUrl;
    [self.navigationController pushViewController:htmlVC animated:YES];
    
}


#pragma mark - 网络请求

- (void)getDetailRequest:(BOOL)isHeader{
    NSDictionary *prams = @{@"pageNo":@(self.page),
                            @"pageSize":MacoRequestPageCount};
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:3];
    [HttpClient POST:@"find/draw/detail" parameters:prams success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [SVProgressHUD dismiss];
        if (IsRequestTrue) {
            self.htmlUrl = NullToSpace(jsonObject[@"data"][@"description"]);
            [self.tableView hiddenNoDataSouce];
            if (isHeader) {
                self.isFirstEnd = YES;
                [self.dataSocueArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            }else{
                self.isFirstEnd = NO;
                [self.tableView.mj_footer endRefreshing];
            }
            NSArray *array = jsonObject[@"data"][@"pageData"][@"data"];
            if (array.count > 0) {
                self.page ++;
            }
            for (int i = 0; i < array.count ; i ++) {
                DiscoveryDeatailModel *model = [DiscoveryDeatailModel modelWithDic:array[i]];
                if (![model.state isEqualToString:@"0"] && self.isFirstEnd) {
                    model.isFirstEnd = YES;
                    self.isFirstEnd = NO;
                }else if(![model.state isEqualToString:@"0"] && !self.isFirstEnd){
                    model.isFirstEnd = NO;
                }else{
                    self.isFirstEnd = YES;
                }
                model.systmTime = [NullToNumber(jsonObject[@"data"][@"sysTime"]) longLongValue];
                [self.dataSocueArray addObject:model];
            }
            [self.tableView judgeIsHaveDataSouce:self.dataSocueArray];
            [self.tableView reloadData];
        }
        if (isHeader) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [SVProgressHUD dismiss];
        if (isHeader) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView showNoDataSouce];
    }];

}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSocueArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoveryDeatailModel *model = self.dataSocueArray[indexPath.row];
    if ([model.state isEqualToString:@"0"]) {
        DiscoveryWaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DiscoveryWaitTableViewCell indentify]];
        if (!cell) {
            cell = [DiscoveryWaitTableViewCell newCell];
        }
        cell.dataModel = self.dataSocueArray[indexPath.row];
        return cell;
    }else{
        DisCoverYetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DisCoverYetTableViewCell indentify]];
        if (!cell) {
            cell = [DisCoverYetTableViewCell newCell];
        }
        cell.dataModel = self.dataSocueArray[indexPath.row];
        return cell;
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoveryDeatailModel *model = self.dataSocueArray[indexPath.row];

    if ([model.state isEqualToString:@"0"]) {
        return TWitdh*(40/75.) + 135;
    }else if(![model.state isEqualToString:@"0"] && model.isFirstEnd){
        return TWitdh*(280/750.);
    }else{
        return TWitdh*(196/750.);
    }
}


#pragma mark - 参加抽奖
- (void)buyLuckyDarw:(NSString *)detailId
{
    [self.view addSubview:self.payView];
    self.payView.detailId = detailId;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(insets);
    }];
    [self PayViewanimation];

}

- (void)PayViewanimation
{
    self.payView.itemView.frame = CGRectMake(0, THeight , TWitdh, TWitdh*(11/10.));
    [UIView animateWithDuration:0.5 animations:^{
        self.payView.itemView.frame = CGRectMake(0, THeight - (TWitdh*(11/10.)), TWitdh, TWitdh*(11/10.));
    }];
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
