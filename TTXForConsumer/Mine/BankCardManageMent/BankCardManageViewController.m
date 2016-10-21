//
//  BankCardManageViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/22.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BankCardManageViewController.h"
#import "BankCardTableViewCell.h"


@interface BankCardManageViewController ()<UITableViewDelegate,UITableViewDataSource,BasenavigationDelegate>

@end

@implementation BankCardManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"管理银行卡";
    if (self.isYetBingdingCard) {
        self.naviBar.hiddenDetailBtn = NO;
        self.naviBar.detailTitle = @"编辑";
    }
    
    self.naviBar.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - 编辑按钮点击事件
- (void)detailBtnClick
{
    self.naviBar.hiddenDetailBtn = YES;
    BankCardTableViewCell *cell = self.tableView.visibleCells[0];
    cell.isEdit = YES;
    
}


- (NSDictionary *)bankcardInfo
{
    if (!_bankcardInfo) {
        _bankcardInfo = [NSDictionary dictionary];
    }
    return _bankcardInfo;
}

- (NSDictionary *)realnameAuDic
{
    if (!_realnameAuDic) {
        _realnameAuDic = [NSDictionary dictionary];
    }
    return _realnameAuDic;
}


#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BankCardTableViewCell indentify]];
    if (!cell) {
        cell = [BankCardTableViewCell newCell];
    }
    cell.isYetBingdingCard = self.isYetBingdingCard;
    if (self.isYetBingdingCard) {
        cell.bankcardinfo = self.bankcardInfo;
    }
    if (self.isYetRealnameAuthentication) {
        cell.realnameAuDic = self.realnameAuDic;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return THeight *1.3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
