//
//  WatchBannerModel.m
//  Tourguide
//
//  Created by 郭建光 on 15/3/24.
//  Copyright (c) 2015年 inphase. All rights reserved.
//
#import "Watch.h"
@implementation Watch

+ (id)modelWithDic:(NSDictionary *)dic
{
    Watch *model = [[Watch alloc]init];
    model.mch_id = NullToSpace(dic[@"id"]);
    model.name = NullToSpace(dic[@"name"]);
    model.mch_id = NullToSpace(dic[@"id"]);
    model.price = NullToNumber(dic[@"price"]);
    model.coverImage = NullToSpace(dic[@"coverImage"]);
    model.totalCommentCount = NullToNumber(dic[@"totalCommentCount"]);
    if ([dic[@"slideImage"] isKindOfClass:[NSArray class]]) {
        model.slideImage = dic[@"slideImage"];
    }else{
        model.slideImage = @[@""];
    }
    model.inventory = NullToSpace(dic[@"inventory"]);
    model.freight = NullToNumber(dic[@"freight"]);
    model.salenum = NullToNumber(dic[@"salenum"]);
    
    if ([dic[@"picDesc"] isKindOfClass:[NSArray class]]) {
        model.picDesc = dic[@"picDesc"];
    }else{
        model.picDesc = @[@{@"url":@"",
                            @"width":@"0",
                            @"height":@"0"}];
    }
    model.width = [NullToNumber(dic[@"width"]) floatValue];
    model.height = [NullToNumber(dic[@"height"]) floatValue];
    model.recommend = NullToNumber(dic[@"recommend"]);
    if ([NullToNumber(dic[@"isMine"]) integerValue] == 0) {
        model.isMine = YES;
    }else{
        model.isMine = NO;
    }
    
    if ([NullToNumber(dic[@"inventoryFlag"]) integerValue] == 0) {
        model.inventoryFlag = NO;
    }else{
        model.inventoryFlag = YES;
    }
    
    model.mchCode = NullToSpace(dic[@"mchCode"]);
    
    return model;
    
}

- (NSArray *)slideImage
{
    if (!_slideImage) {
        _slideImage = [NSArray array];
    }
    return _slideImage;
}

- (NSArray *)picDesc
{
    if (!_picDesc) {
        _picDesc = [NSArray array];
    }
    return _picDesc;
}



@end
