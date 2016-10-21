//
//  OrderModel.m
//  天添薪
//
//  Created by ttx on 16/1/13.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    OrderModel *model = [[OrderModel alloc]init];
    model.orderId = NullToSpace(dic[@"orderId"]);
    model.totalAmount = NullToSpace(dic[@"totalAmount"]);
    model.balanceAmount = NullToSpace(dic[@"balanceAmount"]);
    model.cashAmount = NullToSpace(dic[@"cashAmount"]);
    model.pic = NullToSpace(dic[@"pic"]);
    model.tranTime = NullToSpace(dic[@"tranTime"]);
    model.mchCode = NullToSpace(dic[@"mchCode"]);
    model.mchName = NullToSpace(dic[@"mchName"]);
    model.channel = NullToSpace(dic[@"channel"]);
    model.state = NullToSpace(dic[@"state"]);
    return model;
}


@end
