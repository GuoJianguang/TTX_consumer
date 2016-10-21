//
//  LogisticsCompanyTableViewCell.m
//  tiantianxin
//
//  Created by ttx on 16/4/18.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "LogisticsCompanyTableViewCell.h"
#import "MallOrderModel.h"

@implementation LogisticsCompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.contentView.backgroundColor = [UIColor whiteColor];
    self.itemView.backgroundColor = [UIColor whiteColor];
//    self.itemView.layer.cornerRadius = 5;
//    self.itemView.layer.masksToBounds = YES;
    
    self.logisticsCLabel.textColor = MacoTitleColor;
    self.awbLabel.textColor = MacoTitleColor;
    
    self.logistics.textColor = MacoTitleColor;
    self.logistics.adjustsFontSizeToFitWidth = YES;
    self.awbNum.textColor = MacoTitleColor;

}

- (void)setDataModel:(MallOrderModel *)dataModel
{
    _dataModel = dataModel;
    [self.companyLogImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.pic] placeholderImage:LoadingErrorImage];
    self.logistics.text = _dataModel.logisticsCompany;
    self.awbNum.text = _dataModel.logisticsNumber;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
