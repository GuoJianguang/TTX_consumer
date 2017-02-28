//
//  TopLineTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/28.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopLineModel.h"

@interface TopLineTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topTitle;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;


@property (nonatomic, strong)TopLineModel *dataModel;

@end
