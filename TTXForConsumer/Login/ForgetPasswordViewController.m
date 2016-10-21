//
//  ForgetPasswordViewController.m
//  天添薪
//
//  Created by ttx on 16/1/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ForgetPassowrdTableViewCell.h"

@interface ForgetPasswordViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation ForgetPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviBar.title_label.text = @"找回密码";
    self.tableView.backgroundColor = [UIColor clearColor];
    


}

#pragma mark - UITalbeViewDataSouce


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62 + 64 +((TWitdh-76)*(168/849.)) * 5 + 14*4 + ((TWitdh-50)*(235/927.)) + 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForgetPassowrdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ForgetPassowrdTableViewCell
                                                                                  indentify]];
    if (!cell) {
        cell = [ForgetPassowrdTableViewCell newCell];
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
