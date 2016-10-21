//
//  WithDrewMoneyViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/22.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "WithDrewMoneyViewController.h"
#import "WithDrewTableViewCell.h"

@interface WithDrewMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WithDrewMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.hidden = YES;
    self.naviBar.title = @"金额提现";
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.showJianbianColor = YES;
    
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithDrewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[WithDrewTableViewCell indentify]];
    if (!cell) {
        cell = [WithDrewTableViewCell newCell];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (THeight <500) {
        return THeight*1.2;
    }
    return THeight;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    WithDrewTableViewCell *cell = self.tableView.visibleCells[0];
    [cell.successView removeFromSuperview];
//    [self.view.subviews.lastObject removeFromSuperview];
    [SVProgressHUD dismiss];

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
