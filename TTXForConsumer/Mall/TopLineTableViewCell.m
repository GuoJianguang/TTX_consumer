//
//  TopLineTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/28.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "TopLineTableViewCell.h"

@implementation TopLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topTitle.textColor = MacoTitleColor;
    self.timeLabel.textColor = MacoDetailColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDataModel:(TopLineModel *)dataModel
{
    _dataModel = dataModel;
    self.topTitle.text = _dataModel.name;
    self.timeLabel.text = _dataModel.createTime;
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:_dataModel.pic] placeholderImage:LoadingErrorImage];
}

@end
