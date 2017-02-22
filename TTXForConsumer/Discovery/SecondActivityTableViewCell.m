//
//  SecondActivityTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/22.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "SecondActivityTableViewCell.h"

@implementation SecondACtivityModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    SecondACtivityModel *model = [[SecondACtivityModel alloc]init];
    model.seqId = NullToSpace(dic[@"seqId"]);
    model.name = NullToSpace(dic[@"name"]);
    model.coverImg = NullToSpace(dic[@"coverImg"]);
    model.jumpWay = NullToSpace(dic[@"jumpWay"]);
    model.jumpValue = NullToSpace(dic[@"jumpValue"]);
    model.remark = NullToSpace(dic[@"remark"]);
    return model;
}

@end


@implementation SecondActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goodsName.textColor = MacoTitleColor;
    self.goodsImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataModel:(SecondACtivityModel *)dataModel
{
    _dataModel = dataModel;
    self.goodsName.text = _dataModel.name;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImg] placeholderImage:LoadingErrorImage];
    
}


@end
