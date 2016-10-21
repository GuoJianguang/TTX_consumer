//
//  BussessDetailModel.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/30.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BussessDetailModel.h"

@implementation BussessDetailModel
+ (id)modelWithDic:(NSDictionary *)dic
{
    BussessDetailModel *model = [[BussessDetailModel alloc]init];
    model.address = NullToSpace(dic[@"address"]);
    model.code = NullToSpace(dic[@"code"]);
    model.desc = NullToSpace(dic[@"desc"]);
    model.highQuality = NullToSpace(dic[@"highQuality"]);
    model.longitude = NullToSpace(dic[@"longitude"]);
    model.name = NullToSpace(dic[@"name"]);
    model.phone = NullToSpace(dic[@"phone"]);
    model.pic = NullToSpace(dic[@"pic"]);
    model.latitude = NullToSpace(dic[@"latitude"]);
    model.recommend = NullToSpace(dic[@"recommend"]);
    //    model.slidePic = NullToSpace(dic[@"slidePic"]);
    model.trade = NullToSpace(dic[@"trade"]);
    model.keyword = NullToSpace(dic[@"keyword"]);
    
    if ([dic[@"slidePic"] isKindOfClass:[NSArray class]]) {
        model.slidePic = dic[@"slidePic"];
    }else{
        model.slidePic = [NSArray array];
    }
    
    if ([dic[@"morePic"] isKindOfClass:[NSArray class]]) {
        model.morePic = dic[@"morePic"];
    }else{
        model.morePic = [NSArray array];
    }
    
    
    return model;
}

- (NSArray *)morePic
{
    if (!_morePic) {
        _morePic = [NSArray array];
    }
    return _morePic;
}

- (NSArray *)slidePic
{
    if (!_slidePic) {
        _slidePic  = [NSArray array];
    }
    return _slidePic;
}
@end
