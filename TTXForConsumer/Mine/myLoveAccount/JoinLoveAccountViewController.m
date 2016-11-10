//
//  JoinLoveAccountViewController.m
//  TTXForConsumer
//
//  Created by Guo on 16/11/10.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "JoinLoveAccountViewController.h"

@interface JoinLoveAccountViewController ()

@end

@implementation JoinLoveAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"爱心账户";
    
    self.joinBtn.layer.cornerRadius = 25;
    self.joinBtn.layer.masksToBounds = YES;
    self.joinBtn.backgroundColor = MacoColor;
    
    self.expainTextView.text = @"账户说明：\nXCode工程目录里面,有时你会发现2个不同颜色的文件夹,一种是蓝色的,一种是黄色的,最常见的是黄色的,我也是最近学习html5的时候,发现还有蓝色的文件夹呢, 来上...";
    self.expainTextView.textColor = MacoTitleColor;
    self.expainTextView.editable = NO;
    self.expainTextView.backgroundColor = [UIColor clearColor];
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

- (IBAction)joinBtn:(id)sender {
    
}
@end
