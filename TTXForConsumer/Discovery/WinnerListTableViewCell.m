//
//  WinnerListTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/22.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "WinnerListTableViewCell.h"

@implementation WinnerListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.winnerPhoneNumber.textColor = self.winnerName.textColor = MacoDetailColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
