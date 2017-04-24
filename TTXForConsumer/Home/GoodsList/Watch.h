//
//  WatchBannerModel.h
//  Tourguide
//
//  Created by 郭建光 on 15/3/24.
//  Copyright (c) 2015年 inphase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Watch : BaseModel

/**
 * 商品id
 */

@property (nonatomic, copy)NSString *mch_id;
/**
 * 商品名称
 */

@property (nonatomic, copy)NSString *name;
/**
 * 商品类型
 */

@property (nonatomic, copy)NSString *typeId;
/**
 * 价格
 */

@property (nonatomic, copy)NSString *price;
/**
 * 封面图
 */

@property (nonatomic, copy)NSString *coverImage;
/**
 * 轮播图
 */

@property (nonatomic, strong)NSArray *slideImage;
/**
 * 库存
 */

@property (nonatomic, copy)NSString *inventory;
/**
 * 运费
 */

@property (nonatomic, copy)NSString *freight;
/**
 * 销量
 */

@property (nonatomic, copy)NSString *salenum;
/**
 * 商品图片介绍
 */
@property (nonatomic, strong)NSArray *picDesc;
/**
 * 封面图宽
 */

@property (nonatomic, assign)CGFloat width;
/**
 * 封面图高
 */

@property (nonatomic, assign)CGFloat height;
/**
 * 是否推荐
 */

@property (nonatomic, copy)NSString *recommend;

/**
 * 是否有库存
 */
@property (nonatomic, assign)BOOL inventoryFlag;


@property (nonatomic, assign)BOOL isMine;


//图片的高度
@property (nonatomic, assign)CGFloat h;

//所属店铺的code
@property (nonatomic, copy)NSString *mchCode;


//改变规格之后的实际价格
@property (nonatomic, assign)CGFloat actualPrice;

//总评论数量

@property (nonatomic, copy)NSString *totalCommentCount;


@property (nonatomic, strong)NSString *priceId;

/**
 * 折扣限时开始时间
 */

@property (nonatomic, strong)NSString *startTime;
/**
 * 折扣限时结束时间
 */

@property (nonatomic, strong)NSString *endTime;

@property (nonatomic, strong)NSString *nowTime;
/**
 * 原价
 */


@property (nonatomic, strong)NSString *originalPrice;

//0普通商品  1分销商品 2限时折扣',
@property (nonatomic, strong)NSString *goods_type;




#pragma mark - 在线支付的新需求改变
//（0自由支付 1现金 2现金余额 3现金待回馈）
@property (nonatomic, copy)NSString *payTyp;
//现金金额
@property (nonatomic, copy)NSString *cashAmount;
//余额金额
@property (nonatomic, copy)NSString *balanceAmount;
//待回馈金额
@property (nonatomic, copy)NSString *expectAmount;

@end
