//
//  WalletTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/23.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWallectCollectionViewCell.h"


#pragma mark - 返现的Model
@interface FanXianModel :BaseModel

/**
 * 返现记录单号
 */
@property (nonatomic,copy)NSString *fanxianId;
/**
 * 返现时间
 */
@property (nonatomic,copy)NSString *tranTime;
/**
 * 返现金额
 */
@property (nonatomic,copy)NSString *amount;


@end


#pragma mark - 提现记录的model
@interface TixianModel : BaseModel
/**
 * 提现单号
 */
@property (nonatomic,copy)NSString *tixianId;
/**
 * 提现金额
 */
@property (nonatomic,copy)NSString *withdrawAmout;
/**
 * 提现时间
 */
@property (nonatomic,copy)NSString *successTime;
/**
 * 提现状态 0待审核  1审核通过  2提现中   3提现成功  4提现失败
 */
@property (nonatomic,copy)NSString *state;


@end


@interface YuEPayModel : BaseModel
/**
 * id
 */

@property (nonatomic,copy)NSString *yuEId;
/**
 * 商户名称
 */
@property (nonatomic,copy)NSString *mchName;
/**
 * 金额
 */

@property (nonatomic,copy)NSString *balanceAmount;
/**
 * 时间
 */
@property (nonatomic,copy)NSString *tranTime;
/**
 *  渠道
 */
@property (nonatomic,copy)NSString *channel;
/**
 * 商品名称
 */
@property (nonatomic,copy)NSString *goodsName;
/**
 * 商品规格
 */
@property (nonatomic,copy)NSString *spec;
@end


@interface WalletTableViewCell : BaseTableViewCell

@property (nonatomic, strong)YuEPayModel *yuEModel;

@property (nonatomic, strong)InnitationModel *tuijianModel;

@property(nonatomic, strong)TixianModel *tixianModel;

@property(nonatomic, strong)FanXianModel *fanxianModel;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *money;


@property (weak, nonatomic) IBOutlet UILabel *time;


@end
