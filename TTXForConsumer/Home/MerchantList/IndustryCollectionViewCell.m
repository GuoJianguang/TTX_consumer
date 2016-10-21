//
//  IndustryCollectionViewCell.m
//  天添薪
//
//  Created by ttx on 16/1/7.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "IndustryCollectionViewCell.h"


@implementation SortModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    SortModel *model = [[SortModel alloc]init];
    model.sortId = NullToSpace(dic[@"id"]);
    model.name = NullToSpace(dic[@"name"]);
    model.icon = NullToSpace(dic[@"icon"]);
    
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

@implementation IndustryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor colorFromHexString:@"#cfdbe4"];
//    self.item_view.backgroundColor = [UIColor colorWithRed:231/255. green:230/255. blue:221/255. alpha:1.];
    
    self.name_label.textColor = MacoTitleColor;
    self.industry_image.layer.masksToBounds = YES;
    
    self.imagWidth.constant = TWitdh*(80/750.);
    
}


//返回重用标示
+ (NSString *)indentify
{
    return @"IndustryCollectionViewCell";
}
//创建cell
+ (UINib *)newCell
{
     UINib *nib = [UINib nibWithNibName:@"IndustryCollectionViewCell"bundle:nil];
    return nib;
}

- (void)setDataModel:(SortModel *)dataModel
{
    _dataModel = dataModel;
    self.name_label.text = _dataModel.name;
    [self.industry_image sd_setImageWithURL:[NSURL URLWithString:_dataModel.icon] placeholderImage:[UIImage imageNamed:@"icon_list_default"]];
}

- (void)setGoodsSortModel:(GoodsSort *)goodsSortModel
{
    _goodsSortModel = goodsSortModel;
    
    self.name_label.text = _goodsSortModel.name;
    [self.industry_image sd_setImageWithURL:[NSURL URLWithString:_goodsSortModel.icon] placeholderImage:[UIImage imageNamed:@"icon_list_default"]];
}

@end
