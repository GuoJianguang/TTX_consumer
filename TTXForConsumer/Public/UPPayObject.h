//
//  UPPayObject.h
//  TTXForConsumer
//
//  Created by Guo on 2017/4/24.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPPayObject : NSObject


+ (UPPayObject *)shareWexinPayObject;

//商城购买商品的时候发起的支付请求
+ (void)startWexinPay:(NSDictionary *)parms withController:(UIViewController *)controller;

//商家在线支付的时候发起的支付请求
+ (void)srarMachantWexinPay:(NSDictionary *)parms;


//商城购买商品的时候发起的支付请求(混合支付)
+ (void)startMallMixedPayment:(NSDictionary *)parms withController:(UIViewController *)controller;

@end
