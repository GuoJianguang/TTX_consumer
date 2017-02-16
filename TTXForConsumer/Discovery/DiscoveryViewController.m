//
//  DiscoveryViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/16.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DiscoveryHomeTableViewCell.h"

@interface DiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *datasouceArray;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviBar.title = @"发现";
    self.naviBar.hiddenBackBtn = YES;
    self.tableView.backgroundColor = [UIColor clearColor];

}


- (NSMutableArray *)datasouceArray
{
    if (!_datasouceArray) {
        _datasouceArray = [NSMutableArray array];
    }
    return _datasouceArray;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    return self.datasouceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoveryHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DiscoveryHomeTableViewCell indentify]];
    if (!cell) {
        cell = [DiscoveryHomeTableViewCell newCell];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
