//
//  HomeBusinessListTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/16.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "HomeBusinessListTableViewCell.h"

@implementation HomeBusinessList

+ (id)modelWithDic:(NSDictionary *)dic
{
    HomeBusinessList *model = [[HomeBusinessList alloc]init];
    model.address = NullToSpace(dic[@"address"]);
    model.code = NullToSpace(dic[@"code"]);
    model.desc = NullToSpace(dic[@"desc"]);
    model.highQuality = NullToSpace(dic[@"highQuality"]);
    model.longitude = NullToSpace(dic[@"longitude"]);
    model.name = NullToSpace(dic[@"name"]);
    model.phone = NullToSpace(dic[@"phone"]);
    model.pic = NullToSpace(dic[@"pic"]);
    model.latitude = NullToSpace(dic[@"latitude"]);
    model.recommend = NullToNumber(dic[@"recommend"]);
    if ([dic[@"slidePic"] isKindOfClass:[NSArray class]]) {
        model.slidePic = dic[@"slidePic"];
    }else{
        model.slidePic = @[@""];
        
    }
    model.trade = NullToSpace(dic[@"trade"]);
    model.keyword = NullToSpace(dic[@"keyword"]);
    model.distance = NullToSpace(dic[@"distance"]);
    return model;
}

- (NSArray *)slidePic
{
    if (!_slidePic) {
        _slidePic = [NSArray array];
    }
    return _slidePic;
}

@end

@implementation HomeBusinessListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
    // Initialization code
    self.sort_label.layer.cornerRadius = 5;
    self.sort_label.layer.borderWidth = 1;
    self.sort_label.layer.borderColor = MacoColor.CGColor;
    self.sort_label.textColor = MacoColor;
    
    self.contentView.backgroundColor = MacoGrayColor;
//    self.itemView.layer.cornerRadius = 8;
//    self.itemView.layer.masksToBounds = YES;
    
//    self.bussessImage.layer.cornerRadius = 8;
    self.bussessImage.layer.masksToBounds = YES;
    self.bussessImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.name_label.textColor = MacoTitleColor;
    self.detail_label.textColor = MacoDetailColor;
//    self.itemView.layer.borderWidth = 1;
//    self.itemView.layer.borderColor  = MacoIntrodouceColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDataModel:(HomeBusinessList *)dataModel
{
    _dataModel = dataModel;
    [self.bussessImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.pic] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
    self.name_label.text = _dataModel.name;
    self.detail_label.text = _dataModel.desc;
    self.sort_label.adjustsFontSizeToFitWidth = YES;
    
    if ([_dataModel.highQuality isEqualToString:@"1"] && !_dataModel.isSearchResult) {
        self.sort_label.hidden = NO;
        
    }else{
        if ([_dataModel.trade isEqualToString:@""]) {
            self.sort_label.hidden = YES;
        }
        self.sort_label.text = _dataModel.trade;
    }
}

@end
