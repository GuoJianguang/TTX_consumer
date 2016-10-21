//
//  MallOrderModel.m
//  tiantianxin
//
//  Created by ttx on 16/4/15.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MallOrderModel.h"

@implementation MallOrderModel


+ (id)modelWithDic:(NSDictionary *)dic
{
    MallOrderModel *model = [[MallOrderModel alloc]init];
    model.orderId = NullToSpace(dic[@"orderId"]);
    model.tranAmount = NullToNumber(dic[@"tranAmount"]);
    model.pic = NullToSpace(dic[@"pic"]);
    model.tranTime = NullToSpace(dic[@"tranTime"]);
    model.mchCode = NullToSpace(dic[@"mchCode"]);
    model.mchName = NullToSpace(dic[@"mchName"]);
    model.channel = NullToNumber(dic[@"channel"]);
    model.status = NullToNumber(dic[@"status"]);
    model.freight = NullToNumber(dic[@"freight"]);
    model.goodsId = NullToSpace(dic[@"goodsId"]);
    model.goodsName = NullToSpace(dic[@"goodsName"]);

    model.specStr = NullToSpace(dic[@"spec"]);
    model.quantity = NullToNumber(dic[@"quantity"]);
    model.commentId = NullToNumber(dic[@"commentId"]);
    
    model.logisticsNumber = NullToSpace(dic[@"logisticsNumber"]);
    model.logisticsCompany = NullToSpace(dic[@"logisticsCompany"]);
    model.logisticsCompanyCode = NullToSpace(dic[@"logisticsCompanyCode"]);
    
    return model;
}


@end
