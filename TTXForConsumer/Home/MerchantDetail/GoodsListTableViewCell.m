//
//  GoodsListTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/20.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsListTableViewCell.h"

@implementation GoodsListModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    GoodsListModel *model = [[GoodsListModel alloc]init];
    model.coverImage = NullToSpace(dic[@"coverImage"]);
    model.goodsId = NullToSpace(dic[@"id"]);
    model.name = NullToSpace(dic[@"name"]);
    model.salenum = NullToNumber(dic[@"salenum"]);
    model.price = NullToNumber(dic[@"price"]);
    return model;
}


@end


@implementation GoodsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.goodsName.textColor = MacoTitleColor;
    self.price.textColor = MacoColor;
    self.salenum.textColor = MacoIntrodouceColor;
    
}

- (void)setDataModel:(GoodsListModel *)dataModel
{
    _dataModel = dataModel;
    self.goodsName.text = _dataModel.name;
    self.salenum.text =[NSString stringWithFormat:@"已售%@",_dataModel.salenum];
    self.price.text = [NSString stringWithFormat:@"￥%.2f",[_dataModel.price doubleValue]];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImage] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
