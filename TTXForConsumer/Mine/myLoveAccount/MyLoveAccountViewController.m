//
//  MyLoveAccountViewController.m
//  TTXForConsumer
//
//  Created by Guo on 16/11/10.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MyLoveAccountViewController.h"
#import "LoveAccountTableViewCell.h"

@interface MyLoveAccountViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyLoveAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.hidden = YES;
    
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoveAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LoveAccountTableViewCell indentify]];
    if (!cell) {
        cell = [LoveAccountTableViewCell newCell];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
