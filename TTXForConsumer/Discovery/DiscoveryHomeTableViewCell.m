//
//  DiscoveryHomeTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/16.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryHomeTableViewCell.h"


@implementation DiscoverHome

+ (id)modelWithDic:(NSDictionary *)dic
{
    DiscoverHome *model = [[DiscoverHome alloc]init];
    model.name = NullToSpace(dic[@"name"]);
    model.discoverId = NullToSpace(dic[@"id"]);
    model.jumpWay = NullToNumber(dic[@"jumpWay"]);
    model.jumpValue = NullToSpace(dic[@"jumpValue"]);
    model.pic = NullToSpace(dic[@"pic"]);
    return model;
}

@end

@implementation DiscoveryHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.activityImage.layer.masksToBounds = YES;
}


- (void)setDataModel:(DiscoverHome *)dataModel
{
    _dataModel = dataModel;
    [self.activityImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.pic] placeholderImage:LoadingErrorImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
