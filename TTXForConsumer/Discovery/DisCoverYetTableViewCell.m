//
//  DisCoverYetTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/17.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DisCoverYetTableViewCell.h"
#import "DiscoveryWinnersListViewController.h"


@implementation DisCoverYetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.endLabel.textColor = MacoDetailColor;
    self.nameLabel.textColor = MacoTitleColor;
    self.detailLabel.textColor = MacoDetailColor;
    self.detailBtn.backgroundColor = [UIColor whiteColor];
    self.detailBtn.layer.cornerRadius = 5;
    self.detailBtn.layer.borderWidth = 1;
    self.detailBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.detailBtn.layer.borderColor = MacoColor.CGColor;
    [self.detailBtn setTitleColor:MacoColor forState:UIControlStateNormal];
    self.detailBtn.layer.masksToBounds = YES;
    
}

- (void)setDataModel:(DiscoveryDeatailModel *)dataModel
{
    _dataModel = dataModel;
    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImg] placeholderImage:LoadingErrorImage];
    self.nameLabel.text = _dataModel.productName;
    switch ([_dataModel.zoneFlag integerValue]) {
        case 1:
            self.detailLabel.text = [NSString stringWithFormat:@"余额%@元/次",_dataModel.payAmount];
            break;
        case 2:
            self.detailLabel.text = [NSString stringWithFormat:@"待回馈金额%@元/次",_dataModel.payAmount];
            break;
            
        default:
            break;
    }
    
    switch ([_dataModel.state integerValue]) {
        case 1:
            [self.detailBtn setTitle:@"待开奖" forState:UIControlStateNormal];
            self.detailBtn.enabled = NO;
            break;
        case 2:
            [self.detailBtn setTitle:@"中奖名单" forState:UIControlStateNormal];
            self.detailBtn.enabled = YES;
            break;
            
        default:
            break;
    }
    
    if (!_dataModel.isFirstEnd) {
        self.endViewHeight.constant = 0;
        self.endView.hidden= YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 中奖名单

- (IBAction)detailBtn:(id)sender {
    DiscoveryWinnersListViewController *detailVC = [[DiscoveryWinnersListViewController alloc]init];
    detailVC.dataModel = self.dataModel;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];

    
}
@end
