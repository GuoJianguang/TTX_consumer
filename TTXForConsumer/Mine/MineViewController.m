//
//  MineViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/21.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MineViewController.h"
#import "MessageViewController.h"
#import "MineTableViewCell.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,BasenavigationDelegate>

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviBar.title = @"个人中心";
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.detailImage = [UIImage imageNamed:@"icon_mine_message"];
    self.naviBar.hiddenBackBtn = YES;
    self.naviBar.delegate = self;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = MacoGrayColor;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout:) name:LogOutNSNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changImageSuccess) name:ChangeHeadImageSuccess object:nil];
    [self.tableView reloadData];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 64, TWitdh, THeight - 64 - 49);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MineTableViewCell *cell = self.tableView.visibleCells[0];
    [cell loadingHeadImage];
    [cell searchUserInfor];
    [cell getMyGrade];}


- (void)detailBtnClick
{
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark - UITalbeView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MineTableViewCell indentify]];
    if (!cell) {
        cell = [MineTableViewCell newCell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.masksToBounds = YES;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TWitdh*(963/750.) + 385;
}


#pragma mark - 退出登录的操作
- (void)logout:(NSNotification *)notification
{
    self.tabBarController.selectedIndex = 0;
}

#pragma mark - 头像修改成功
- (void)changImageSuccess
{
    MineTableViewCell *cell = self.tableView.visibleCells[0];
    [cell loadingHeadImage];
    [cell searchUserInfor];
    [cell getMyGrade];
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
