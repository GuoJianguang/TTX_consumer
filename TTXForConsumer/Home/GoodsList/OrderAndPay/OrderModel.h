//
//  OrderModel.h
//  天添薪
//
//  Created by ttx on 16/1/13.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseModel.h"

@interface OrderModel : BaseModel
/**
 * 订单号
 */
@property (nonatomic,copy)NSString *orderId;
/**
 * 订单金额
 */
@property (nonatomic,copy)NSString *totalAmount;
/**
 * 余额支付金额
 */
@property (nonatomic,copy)NSString *balanceAmount;
/**
 * 现金支付金额
 */
@property (nonatomic,copy)NSString *cashAmount;

/**
 * 商户头像
 */
@property (nonatomic,copy)NSString *pic;
//订单时间
@property (nonatomic,copy)NSString *tranTime;
/**
 * 商户号
 */
@property (nonatomic,copy)NSString *mchCode;
/**
 * 商户名称
 */
@property (nonatomic,copy)NSString *mchName;
/**
 * 渠道  1线下现金消费  2在线消费 3线下余额现金消费
 */
@property (nonatomic,copy)NSString *channel;
/**
 * 订单状态  0 未支付 1正常 2已经累积应返金额 3冻结 4人工审核 5取消
 */
@property (nonatomic,copy)NSString *state;



@end
