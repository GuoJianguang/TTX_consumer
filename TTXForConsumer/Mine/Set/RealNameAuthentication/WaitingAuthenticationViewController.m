//
//  WaitingAuthenticationViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/8/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "WaitingAuthenticationViewController.h"

@interface WaitingAuthenticationViewController ()<BasenavigationDelegate>

@end

@implementation WaitingAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"实名认证";
    self.naviBar.delegate = self;
}


- (void)backBtnClick
{
//    NSLog(@"------%@-----%d",self.navigationController.viewControllers,self.navigationController.viewControllers.count);
//

    if (self.isHandmoveAu) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
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
