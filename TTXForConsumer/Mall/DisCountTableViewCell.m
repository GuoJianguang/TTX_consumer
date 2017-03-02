//
//  DisCountTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/28.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DisCountTableViewCell.h"
#import "Watch.h"
#import "GoodsDetailNewViewController.h"

@implementation DisCountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goodsName.textColor = MacoTitleColor;
    self.discountPrice.textColor = MacoColor;
    self.oldPrice.textColor = MacoDetailColor;
    self.progressView.layer.borderColor = [UIColor colorFromHexString:@"#ffd862"].CGColor;
    self.progressView.layer.borderWidth = 1;
    self.progressView.layer.cornerRadius = 3.;
    self.progressView.progressTintColor = [UIColor colorFromHexString:@"#ffd862"];
    self.progressView.trackTintColor = [UIColor whiteColor];
    self.butBtn.backgroundColor = MacoColor;
    self.butBtn.layer.cornerRadius = 5;
    self.butBtn.layer.masksToBounds = YES;
    [self.butBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.yetLabel.textColor = MacoDetailColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataModel:(Watch *)dataModel
{
    _dataModel = dataModel;
    self.goodsName.text = _dataModel.name;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImage] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
    
    self.discountPrice.text = [NSString stringWithFormat:@"¥ %@",_dataModel.price];
    self.progressView.progress = 1- [_dataModel.inventory doubleValue]/([_dataModel.inventory doubleValue]+[_dataModel.salenum doubleValue]);
    
    self.yetLabel.text = [NSString stringWithFormat:@"已抢%@件",_dataModel.salenum];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@",_dataModel.originalPrice] attributes:attribtDic];
    self.oldPrice.attributedText = attribtStr;
    
    NSUInteger endtime = [_dataModel.endTime longLongValue];
    NSUInteger nowTime = [_dataModel.nowTime longLongValue];
    NSUInteger startTime = [_dataModel.startTime longLongValue];
    if (nowTime > endtime) {
        [self.butBtn setTitle:@"已结束" forState:UIControlStateNormal];
    }else if (nowTime < endtime && nowTime < startTime){
        [self.butBtn setTitle:@"未开始" forState:UIControlStateNormal];
    }else{
        [self.butBtn setTitle:@"马上抢" forState:UIControlStateNormal];

    }

}

- (IBAction)buyBtn:(id)sender {
    GoodsDetailNewViewController *detailVC = [[GoodsDetailNewViewController alloc]init];
    detailVC.isDisCount = YES;
    detailVC.goodsID = self.dataModel.mch_id;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}
@end
