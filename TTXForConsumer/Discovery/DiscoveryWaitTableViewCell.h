//
//  DiscoveryWaitTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/17.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DiscoveryDeatailModel.h"

@interface DiscoveryWaitTableViewCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@property (weak, nonatomic) IBOutlet UILabel *disCoveryName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *changeLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UIButton *luckyDrawBtn;

- (IBAction)luckyDrawBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong)DiscoveryDeatailModel *dataModel;



@end
