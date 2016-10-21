//
//  RewardRecordTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "RewardRecordTableViewCell.h"


@implementation Rewardmodel
+ (id)modelWithDic:(NSDictionary *)dic
{
    Rewardmodel *model = [[Rewardmodel alloc]init];
    model.time = NullToSpace(dic[@"time"]);
    model.reward = NullToSpace(dic[@"reward"]);
    return model;
}


@end

@implementation RewardRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setDataModel:(Rewardmodel *)dataModel
{
    _dataModel = dataModel;
    self.reward.text = _dataModel.reward;
    self.timeLabel.text = _dataModel.time;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
