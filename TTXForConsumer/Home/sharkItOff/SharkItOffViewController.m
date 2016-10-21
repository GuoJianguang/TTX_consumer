//
//  SharkItOffViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "SharkItOffViewController.h"
#import "RewardRecordViewController.h"
#import "ShakRecordView.h"
#import "TheWinningView.h"
#import "SharkResultView.h"





@interface SharkItOffViewController ()

@property (nonatomic, strong)ShakRecordView *shakView;

@property (nonatomic, strong)SharkResultView *resultView;

@property (nonatomic, strong)TheWinningView *winningView;


@end

@implementation SharkItOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"摇一摇";
    self.rewardRecord.layer.cornerRadius = 38/2.;
    self.rewardRecord.layer.masksToBounds = YES;
    self.rewardRecord.backgroundColor = [UIColor colorFromHexString:@"#ffd862"];
    
    self.rewardExplain.layer.cornerRadius = 38/2.;
    self.rewardExplain.layer.masksToBounds = YES;
    self.rewardExplain.backgroundColor = [UIColor colorFromHexString:@"#ffd862"];
    
}

- (ShakRecordView *)shakView
{
    if (!_shakView) {
        _shakView = [[ShakRecordView alloc]init];
        _shakView.frame = CGRectMake(0, 64, TWitdh, THeight - 64);
    }
    return _shakView;
}

- (SharkResultView *)resultView
{
    if (!_resultView) {
        _resultView = [[SharkResultView alloc]init];
        _resultView.frame = CGRectMake(0, 64, TWitdh, THeight - 64);
    }
    return _resultView;
}

- (TheWinningView *)winningView
{
    if (!_winningView) {
        _winningView = [[TheWinningView alloc]init];
        _winningView.frame = CGRectMake(0, 64, TWitdh, THeight - 64);
    }
    return _winningView;
}

#pragma mark - 说明
- (IBAction)rewardExplain:(UIButton *)sender {
    
    [self.view addSubview:self.shakView];
    
}
#pragma mark - 中奖记录
- (IBAction)rewardRecord:(UIButton *)sender {
    RewardRecordViewController *rewardVC = [[RewardRecordViewController alloc]init];
    [self.navigationController pushViewController:rewardVC animated:YES];
    
}


#pragma mark - 摇动

/**
 *  摇动开始
 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"开始摇了");
    }
}

/** 摇一摇结束（需要在这里处理结束后的代码） */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // 不是摇一摇运动事件
    if (motion != UIEventSubtypeMotionShake) return;
    [self.view addSubview:self.winningView];
    
    
}

/** 摇一摇取消（被中断，比如突然来电） */
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
