//
//  TTXUserInfo.h
//  天添薪
//
//  Created by ttx on 16/1/6.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>


//用于保存登录信息

@interface TTXUserInfo : NSObject

+ (TTXUserInfo *)shareUserInfos;

//是否处于登录状态
@property (nonatomic,assign) BOOL currentLogined;
//设备token
@property (nonatomic, copy)NSString *devicetoken;

//当前定位城市
@property (nonatomic, copy)NSString *locationCity;

//头像路径
@property (nonatomic, copy)NSString *avatar;

@property (nonatomic, copy)NSString *userid;
//昵称
@property (nonatomic, copy)NSString *nickName;
//省
@property (nonatomic, copy)NSString *province;
//会话标识，用于获取用户登录信息
@property (nonatomic, copy)NSString *token;
//余额
@property (nonatomic, copy)NSString *aviableBalance;
//总消费金额
@property (nonatomic, copy)NSString *totalConsumeAmount;
//待回馈金额
@property (nonatomic, copy)NSString *totalExpectAmount;
//未参与回馈金额
@property (nonatomic, copy)NSString *wiatJoinAmunt;
//区县
@property (nonatomic, copy)NSString *zone;
//市
@property (nonatomic, copy)NSString *city;
//是否绑定银行卡
@property (nonatomic, copy)NSString *bindingFlag;
//等级
@property (nonatomic, copy)NSString *grade;
//积分
@property (nonatomic, copy)NSString *integral;
//银行卡账户
@property (nonatomic, copy)NSString *bankAccount;
//银行卡所属姓名
@property (nonatomic, copy)NSString *bankAccountRealName;
/**
 * 我的消息
 */
@property (nonatomic, copy)NSString *messageCount;
/**
 * 我的提现
 */
@property (nonatomic, copy)NSString *withdrawCount;
/**
 * 我的回馈
 */
@property (nonatomic, copy)NSString *feedbackCount;

/**
 * 我的订单
 */
@property (nonatomic, copy)NSString *orderCount;

/**
 * 我的订单待付款
 */
@property (nonatomic, copy)NSString *unPayOrderCount ;

/**
 * 待发货订单数量
 */
@property (nonatomic, copy)NSString *waitDeleverCount;
/*
* 已完成订单数量
*/
@property (nonatomic, copy)NSString *completeCount;

/**
 * 待发货待确认收货订单数总和
 */
@property (nonatomic, copy)NSString *totalWaitCount;
/**
 * 待确认收货订单数量
 */
@property (nonatomic, copy)NSString *waitConfirmCount;

//（多少天没有消费） 登录里新增返回字段
@property (nonatomic, assign)NSInteger notConsumeDays;

//记录当前位置
@property (nonatomic, assign)CLLocationCoordinate2D locationCoordinate;

//1已经填写身份证号   2没有填写
@property (nonatomic, assign)BOOL identityFlag;
//身份证号码
@property (nonatomic, copy)NSString *idcard;
//真实姓名
@property (nonatomic, copy)NSString *idcardName;
//记录启动的时候有没有通知
@property (nonatomic, strong)NSDictionary *notificationParms;
@property (nonatomic, assign)BOOL islaunchFormNotifi;
/**
 * 实名认证申请标志(0无待审核请求   1有待审核请求  )
 */
@property (nonatomic, assign)BOOL idVerifyReqFlag;

/*
 所绑定银行卡的银行名字
 */
@property (nonatomic, strong)NSString *bankname;

//手机号
@property (nonatomic, copy)NSString *phone;

- (void)setUserinfoWithdic:(NSDictionary *)dic;

//设置渐变色
+ (void)setjianpianColorwithView:(UIView *)backView withWidth:(CGFloat )width withHeight:(CGFloat)height;

@end
