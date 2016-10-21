//
//  MyWallectCollectionViewCell.h
//  天添薪
//
//  Created by ttx on 16/1/11.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - 邀请的Model
/**
 * 时间
 */

@interface InnitationModel : BaseModel

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
 * 收益金额
 */
@property (nonatomic,copy)NSString *tranAmount;
/**
 * 商户营业额
 */
@property (nonatomic,copy)NSString *totalAmount;
/**
 * 总收益金额
 */
@property (nonatomic,copy)NSString *totalqueryAmount;



@end


#pragma mark - 消费的model
@interface XiaofeiModel : BaseModel
//订单号
@property (nonatomic,copy)NSString *orderId;
//订单金额
@property (nonatomic,copy)NSString *totalAmount;
//余额支付金额
@property (nonatomic,copy)NSString *balanceAmount;
//现金支付金额
@property (nonatomic,copy)NSString *cashAmount;
//商户头像
@property (nonatomic,copy)NSString *pic;
//订单时间
@property (nonatomic,copy)NSString *tranTime;
//商户号
@property (nonatomic,copy)NSString *mchCode;
//商户名称
@property (nonatomic,copy)NSString *mchName;

//判断是什么类型的订单
//'渠道（1线下现金消费  2在线消费 3线下余额现金消费）',
@property (nonatomic,copy)NSString *channel;
//'0余额支付 1微信支付',
@property (nonatomic, copy)NSString *pay_type;

@end



@interface MyWallectCollectionViewCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *detail_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;


@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UILabel *stauts_label;

//消费的model
@property (nonatomic, strong)XiaofeiModel *xiaofeiDataModel;
////返现的model
//@property (nonatomic, strong)FanXianModel *fanXianDataModel;
//提现的model
//@property (nonatomic, strong)TixianModel *tixianDataModel;

//邀请的model
@property (nonatomic, strong)InnitationModel *inviteDataModel;


@end
