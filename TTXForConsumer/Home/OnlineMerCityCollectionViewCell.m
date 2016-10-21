//
//  OnlineMerCityCollectionViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 16/10/18.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "OnlineMerCityCollectionViewCell.h"


@implementation VenceDataModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    VenceDataModel *model = [[VenceDataModel alloc]init];
    model.venceId = NullToSpace(dic[@"id"]);
    model.pic = NullToSpace(dic[@"pic"]);
    model.name = NullToSpace(dic[@"name"]);
    return model;
    
}

@end

@implementation OnlineMerCityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataModel:(VenceDataModel *)dataModel
{
    _dataModel = dataModel;
    [self.venceImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.pic] placeholderImage:LoadingErrorImage];
}


@end
