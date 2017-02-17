//
//  DiscoveryDeatailModel.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/17.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "BaseModel.h"

@interface DiscoveryDeatailModel : BaseModel

/**
 * 奖品id
 */
@property (nonatomic, copy)NSString *detailId;
/**
 * 奖品名称
 */

@property (nonatomic, copy)NSString *productName;
/**
 * 单价
 */

@property (nonatomic, copy)NSString *payAmount;
/**
 * 1余额奖品  2待回馈金额奖品
 */

@property (nonatomic, copy)NSString *zoneFlag;

//0待开奖（可购买）1待开奖（不可购买）  2已开奖
@property (nonatomic, copy)NSString *state;
/**
 * 最大购买抽奖数量
 */

@property (nonatomic, copy)NSString *endCountNum;
/**
 * 可购买抽奖次数
 */

@property (nonatomic, copy)NSString *countNum;
/**
 * 抽奖次数购买截止时间
 */

@property (nonatomic, copy)NSString *endTime;
/**
 * 封面图
 */
@property (nonatomic, copy)NSString *coverImg;

//是否是第一个已结束的商品
@property (nonatomic, assign)BOOL isFirstEnd;

//系统当前时间

@property (nonatomic, assign)NSUInteger systmTime;

@end
