//
//  DiscoveryHomeTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/16.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryHomeTableViewCell.h"

@implementation DiscoveryHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.activityImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
