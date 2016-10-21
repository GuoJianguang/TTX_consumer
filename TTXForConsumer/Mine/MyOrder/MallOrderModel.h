//
//  MallOrderModel.h
//  tiantianxin
//
//  Created by ttx on 16/4/15.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseModel.h"

@interface MallOrderModel : BaseModel
/**
 * 订单id
 */
@property (nonatomic, copy)NSString *orderId;
/**
 * 商品id
 */
@property (nonatomic, copy)NSString *goodsId;
/**
 * 商户名称
 */

@property (nonatomic, copy)NSString *mchName;
/**
 * 商品名称
 */

@property (nonatomic, copy)NSString *goodsName;

/**
 * 商品封面图
 */

@property (nonatomic, copy)NSString *pic;
/**
 * 总金额
 */

@property (nonatomic, copy)NSString *tranAmount;

/**
 * 渠道  1线下现金消费  2在线消费 3线下余额现金消费(1或3为到店支付,2为商城订单)
 */

@property (nonatomic, copy)NSString *channel;

/**
 * 订单状态 1未发货  2已发货  3已确认收货  4已付款  5已完成 6商家未打款  7退款中  8退款成功 9已支付
 */


@property (nonatomic, copy)NSString *status;
/**
 * 时间 yyy.MM.dd HH:mm
 */
@property (nonatomic, copy)NSString *tranTime;


/**
 * 物流单号
 */

@property (nonatomic, copy)NSString *logisticsNumber;

/**
 * 物流公司
 */
@property (nonatomic, copy)NSString *logisticsCompany;

/**
 * 物流公司编号
 */
@property (nonatomic, copy)NSString *logisticsCompanyCode;

/**
 * 运费
 */

@property (nonatomic, copy)NSString *freight;

/**
 * 商户号
 */

@property (nonatomic, copy)NSString *mchCode;
//规格
@property (nonatomic, copy)NSString *specStr;
//数量
@property (nonatomic, copy)NSString *quantity;
//评论的id
@property (nonatomic, copy)NSString *commentId;

@end
