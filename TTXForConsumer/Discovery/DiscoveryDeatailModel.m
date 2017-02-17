//
//  DiscoveryDeatailModel.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/17.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryDeatailModel.h"

@implementation DiscoveryDeatailModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    DiscoveryDeatailModel *model = [[DiscoveryDeatailModel alloc]init];
    model.detailId = NullToSpace(dic[@"id"]);
    model.productName = NullToSpace(dic[@"productName"]);
    model.payAmount = NullToNumber(dic[@"payAmount"]);
    model.zoneFlag = NullToNumber(dic[@"zoneFlag"]);
    model.state = NullToSpace(dic[@"state"]);
    model.endCountNum = NullToNumber(dic[@"endCountNum"]);
    model.countNum = NullToNumber(dic[@"countNum"]);
    model.endTime = NullToSpace(dic[@"endTime"]);
    model.coverImg = NullToSpace(dic[@"coverImg"]);
    model.isFirstEnd = YES;
    model.systmTime= 0;
    return model;
}



@end
