//
//  ShippingAlerTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "ShippingAlerTableViewCell.h"

@implementation ShippingAlerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.alerLabel.textColor = MacoDetailColor;
    self.contentView.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
