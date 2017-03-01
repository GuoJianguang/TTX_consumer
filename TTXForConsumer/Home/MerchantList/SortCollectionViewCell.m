//
//  SortCollectionViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/20.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "SortCollectionViewCell.h"

@implementation MerchantSort

+ (id)modelWithDic:(NSDictionary *)dic
{
    MerchantSort *model = [[MerchantSort alloc]init];
    model.sortName = NullToSpace(dic[@"name"]);
    model.isSelect = [dic[@"isSelect"] isEqual:@1];
    
    model.icon = [model.icon stringByReplacingOccurrencesOfString:@"," withString:@" "];
    /*处理空格*/
    
    NSCharacterSet *characterSet2 = [NSCharacterSet whitespaceCharacterSet];
    
    // 将string1按characterSet1中的元素分割成数组
    NSArray *array2 = [model.icon componentsSeparatedByCharactersInSet:characterSet2];
    
    NSLog(@"\narray = %@",array2);
    
    model.icon = array2[0];
    return model;
}

@end

@implementation GoodsSort

+ (id)modelWithDic:(NSDictionary *)dic
{
    GoodsSort *model = [[GoodsSort alloc]init];
    model.sortId = NullToSpace(dic[@"id"]);
    model.pic = NullToSpace(dic[@"pic"]);
    model.icon = NullToSpace(dic[@"icon"]);
    model.name = NullToSpace(dic[@"name"]);
    return model;
}


@end


@implementation SortCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.markView.backgroundColor = [UIColor colorFromHexString:@"#ffd862"];
    self.pointView.layer.masksToBounds = YES;
    self.pointView.layer.cornerRadius = 3;
    self.pointView.backgroundColor = MacoColor;
    self.pointView.hidden = YES;
    [self.contentView bringSubviewToFront:self.markView];

}



- (void)setDataModel:(MerchantSort *)dataModel
{
    _dataModel = dataModel;
    self.sortLabel.text = _dataModel.sortName;
    self.markView.hidden = !_dataModel.isSelect;
    if (self.markView.hidden) {
        self.sortLabel.textColor = MacoDetailColor;
    }else{
        self.sortLabel.textColor = MacoTitleColor;
    }
    self.sortLabel.numberOfLines = 2;
//    self.sortLabel.adjustsFontSizeToFitWidth = YES;
    self.pointView.hidden =  !_dataModel.isShowRedPoint;
}


- (void)setGoodsModel:(GoodsSort *)goodsModel
{
    _goodsModel = goodsModel;
    self.sortLabel.text = _goodsModel.name;
    self.markView.hidden = !_goodsModel.isSelect;
    if (self.markView.hidden) {
        self.sortLabel.textColor = MacoIntrodouceColor;
    }else{
        self.sortLabel.textColor = MacoTitleColor;
    }
}

@end
