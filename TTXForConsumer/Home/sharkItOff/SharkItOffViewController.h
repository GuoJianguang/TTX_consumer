//
//  SharkItOffViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface SharkItOffViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *remainingNum;

@property (weak, nonatomic) IBOutlet UIButton *rewardExplain;

- (IBAction)rewardExplain:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *rewardRecord;

- (IBAction)rewardRecord:(UIButton *)sender;


@end
