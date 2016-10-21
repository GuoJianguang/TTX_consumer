//
//  RegisterViewController.m
//  天添薪
//
//  Created by ttx on 16/1/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterTableViewCell.h"


@interface RegisterViewController ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation RegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviBar.title_label.text = @"注册";
    self.tableView.backgroundColor = [UIColor clearColor];
   }
#pragma mark - UITalbeViewDataSouce


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62 + 64 +((TWitdh-76)*(168/849.)) * 5 + 14*4 + ((TWitdh-50)*(235/927.)) + 60 + 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RegisterTableViewCell
                                                                                      indentify]];
    if (!cell) {
        cell = [RegisterTableViewCell newCell];
    }
    return cell;
}




@end
