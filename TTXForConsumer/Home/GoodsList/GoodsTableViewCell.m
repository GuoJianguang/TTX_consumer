//
//  GoodsListTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/21.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsTableViewCell.h"
#import "Watch.h"

@implementation GoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.fanMark.layer.cornerRadius = 3;
    self.fanMark.layer.masksToBounds = YES;
    self.fanMark.backgroundColor = self.jianMark.backgroundColor = MacoColor;
    
    self.jianMark.layer.cornerRadius = 3;
    self.jianMark.layer.masksToBounds = YES;
    
    self.price.textColor = MacoPriceColor;
    self.goodsName.textColor = MacoTitleColor;
    self.freight.textColor = MacoDetailColor;
    self.salesVolume.textColor = MacoDetailColor;
    
    self.jianMark.backgroundColor = self.fanMark.backgroundColor = MacoColor;
    self.fanMark.hidden = YES;
    
    self.goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImage.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDataModel:(Watch *)dataModel
{
    _dataModel = dataModel;
    self.fanMark.hidden = YES;
    self.goodsName.text = _dataModel.name;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImage] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
    self.freight.text = [NSString stringWithFormat:@"运费:￥%.2f",[_dataModel.freight doubleValue]];
    self.salesVolume.text = [NSString stringWithFormat:@"销量:%@件",_dataModel.salenum];
    self.price.text = [NSString stringWithFormat:@"￥ %.2f",[_dataModel.price doubleValue]];
    if ([_dataModel.recommend isEqualToString:@"1"]) {
        self.jianMark.hidden = NO;
    }else{
        self.jianMark.hidden = YES;
        self.jianWidth.constant = 1;
        self.fanLeading.constant = 0;
    }
    
}

@end
