//
//  MchAllCommentViewController.m
//  tiantianxin
//
//  Created by ttx on 16/4/14.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MchAllCommentViewController.h"
#import "MchcommentDetailTableViewCell.h"

@interface MchAllCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *dataSouceArray;
@property (nonatomic, assign)NSInteger page;


@end

@implementation MchAllCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.title = @"所有评论";
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 74, TWitdh, THeight-74);
    self.tableView.hidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];

    __weak MchAllCommentViewController *weak_self = self;
    //优质商家的数据请求
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [weak_self commentReqest:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weak_self commentReqest:NO];
    }];
    [self.tableView.mj_header beginRefreshing];
    [self.tableView addNoDatasouceWithCallback:^{
        [weak_self.tableView.mj_header beginRefreshing];
    } andAlertSting:@"暂时没有评论" andErrorImage:@"pic_2" andRefreshBtnHiden:YES];
    self.tableView.layer.cornerRadius = 8;
    self.tableView.layer.masksToBounds = YES;

}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
    }
    return _tableView;
}

//每页条数
static NSInteger pangeCount = 20;



- (void)commentReqest:(BOOL)isHeader
{
    NSDictionary *parms = @{@"id":self.mchId,
                            @"pageNo":@(self.page),
                            @"pageSize":@(pangeCount)};
    
    [HttpClient POST:@"shop/goodsComment/get" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
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
                MchComment *comment = [MchComment modelWithDic:dic];
                [self.dataSouceArray addObject:comment];
            }
            
            MchComment *comment1 = [[MchComment alloc]init];
            comment1.content = @"点击当会计课佳节快到家 记得哦我就到家当空间看大家快点放假啊姐姐地久服务看到就卡即可大家分开健康大家分开撒娇发的空间打开了减肥的空间当空间的空间打开垃圾的空间当空间疯狂啦时间的疯狂减肥的空间疯狂啦手机发的空间放的开减肥的空间发的快乐手机发的哭了说减肥的了空间打开减肥的空间fdklj";
            comment1.commentId = @"12";
            comment1.userNickName= @"222";
            comment1.commentTime = @"2016.2.3";
            comment1.userNickName = @"by 但都没看到";
            comment1.specStr = @"白色、35码";
//            [self.dataSouceArray addObject:comment1];
            //判断数据源有无数据
            [self.tableView judgeIsHaveDataSouce:self.dataSouceArray];
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView showRereshBtnwithALerString:@"网络连接不好"];
        if (isHeader) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
}


- (NSMutableArray *)dataSouceArray
{
    if(!_dataSouceArray){
        _dataSouceArray = [NSMutableArray array];
    }
    
    return _dataSouceArray;
}

#pragma mark - UITableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSouceArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSouceArray.count > 0) {
        MchComment *comment = self.dataSouceArray[indexPath.row];
        return 70 +[self cellHeight:comment.content];
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MchcommentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MchcommentDetailTableViewCell indentify]];
    
    if (!cell) {
        cell = [MchcommentDetailTableViewCell newCell];
    }
    if (self.dataSouceArray.count > 0) {
        cell.dataModel = self.dataSouceArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)cellHeight:(NSString *)textSting
{
    CGSize size = [textSting boundingRectWithSize:CGSizeMake(TWitdh  - 30, 0) font:[UIFont systemFontOfSize:14]];
    return size.height;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
