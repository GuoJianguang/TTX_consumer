//
//  RewardRecordTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Rewardmodel : BaseModel

@property (nonatomic, copy)NSString *reward;
@property (nonatomic, copy)NSString *time;

@end


@interface RewardRecordTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reward;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong)Rewardmodel *dataModel;

@end
