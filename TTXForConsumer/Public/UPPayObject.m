//
//  UPPayObject.m
//  TTXForConsumer
//
//  Created by Guo on 2017/4/24.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "UPPayObject.h"

static UPPayObject *instance;

static NSString *testEnvironment = @"01";
static NSString *disEnvironment = @"00";

@interface UPPayObject()

@end

@implementation UPPayObject

+ (UPPayObject *)shareWexinPayObject
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UPPayObject alloc]init];
    });
    return instance;
}



+ (void)startWexinPay:(NSDictionary *)parms withController:(UIViewController *)controller;
{
    [SVProgressHUD showWithStatus:@"正在发送支付请求" maskType:SVProgressHUDMaskTypeBlack];
    [HttpClient POST:@"pay/unionpay" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [SVProgressHUD dismiss];
        if (IsRequestTrue) {
            //调起银联支付
            NSString* tn = NullToSpace(jsonObject[@"data"][@"tn"]);
            if (tn != nil && tn.length > 0)
            {
                [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"TTXForConsumer" mode:disEnvironment viewController:controller];
                
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[JAlertViewHelper shareAlterHelper]showTint:@"订单生成失败,请稍后重试" duration:1.];
    }];
}




+ (void)srarMachantWexinPay:(NSDictionary *)parms
{
    [SVProgressHUD showWithStatus:@"正在发送支付请求" maskType:SVProgressHUDMaskTypeBlack];
    [HttpClient POST:@"pay/mch/wxpay" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [SVProgressHUD dismiss];
        if (IsRequestTrue) {
            NSDictionary *dict = jsonObject[@"data"];
            //调起银联支付

        
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[JAlertViewHelper shareAlterHelper]showTint:@"订单生成失败,请稍后重试" duration:1.];
    }];
}

#pragma mark - 商城购买商品的时候发起的支付请求(混合支付)
+ (void)startMallMixedPayment:(NSDictionary *)parms withController:(UIViewController *)controller
{
    [SVProgressHUD showWithStatus:@"正在发送支付请求" maskType:SVProgressHUDMaskTypeBlack];
    [HttpClient POST:@"pay/blendPay" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [SVProgressHUD dismiss];
        if (IsRequestTrue) {
            //调起银联支付
            NSString* tn = NullToSpace(jsonObject[@"data"][@"tn"]);
            if (tn != nil && tn.length > 0)
            {
                [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"TTXForConsumer" mode:disEnvironment viewController:controller];
                
            }

        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[JAlertViewHelper shareAlterHelper]showTint:@"订单生成失败,请稍后重试" duration:1.];
    }];
    
    
}


@end
