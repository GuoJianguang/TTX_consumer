//
//  TopLineModel.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/28.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "BaseModel.h"

@interface TopLineModel : BaseModel

@property (nonatomic, strong)NSString *topLineId;

@property (nonatomic, strong)NSString *name;
/**
 * 跳转方式（1：APP商户详情 2：APP产品详情 3：网页）
 */
@property (nonatomic, strong)NSString *jumpWay;
/**
 * 跳转参数值
 */
@property (nonatomic, strong)NSString *jumpValue;

@property (nonatomic, strong)NSString *pic;

@property (nonatomic, strong)NSString *createTime;

@end
