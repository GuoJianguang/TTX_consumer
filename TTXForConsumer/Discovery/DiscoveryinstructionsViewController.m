//
//  DiscoveryinstructionsViewController.m
//  TTXForConsumer
//
//  Created by Guo on 2017/3/3.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryinstructionsViewController.h"

@interface DiscoveryinstructionsViewController ()

@end

@implementation DiscoveryinstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"幸运购说明";
    self.titleLabel.textColor = MacoTitleColor;
    self.detialLabel.textColor = MacoDetailColor;
    self.statementLabel.textColor = [UIColor redColor];
    
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
