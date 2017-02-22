//
//  WinnerListHeaderTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/22.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "WinnerListHeaderTableViewCell.h"
#import "DiscoveryDeatailModel.h"

@implementation WinnerListHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = MacoGrayColor;
    self.goodsName.textColor = MacoTitleColor;
    self.winnerNameLabel.textColor = MacoDetailColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDataModel:(DiscoveryDeatailModel *)dataModel
{
    _dataModel = dataModel;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImg] placeholderImage:LoadingErrorImage];
    self.goodsName.text = _dataModel.productName;
}

@end
