//
//  PayView.m
//  天添薪
//
//  Created by ttx on 16/1/11.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "PayView.h"
//#import "WaitPayViewController.h"

@implementation PayView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"PayView" owner:nil options:nil][0];
        [self sendSubviewToBack:self.backView];
        self.item_view.backgroundColor = [UIColor whiteColor];
        self.pleaseLael.textColor = MacoTitleColor;
        [self.sureBtn setTitleColor:MacoColor forState:UIControlStateNormal];
        self.backView.backgroundColor = [UIColor colorFromHexString:@"#ccd8e2"];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.password_view.layer.cornerRadius = CGRectGetHeight(self.password_view.bounds)/2;
    self.password_view.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.password_view.layer.borderWidth = 1;
    //        self.password_view.layer.borderColor = MacoColor.CGColor;
    
    self.anmintionView = [[MoView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.successView addSubview:self.anmintionView];
    self.anmintionView.center = CGPointMake(CGRectGetWidth(self.successView.frame)/2, CGRectGetHeight(self.successView.frame)/2);
    self.anmintionView.backgroundColor = [UIColor orangeColor];
    self.anmintionView.layer.cornerRadius = CGRectGetHeight(self.anmintionView.bounds)/2;
    self.anmintionView.layer.masksToBounds = YES;
    
    self.successView.hidden = YES;
    self.successLabel.hidden = YES;

    
    self.password_view.hidden = NO;
    self.passorError.hidden = YES;
    self.forgetBtn.hidden = YES;
    self.password_view.layer.borderColor = [UIColor whitegrayColor].CGColor;
    self.password_tf.text = @"";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.backView addGestureRecognizer:tap];

}

- (void)tap
{

    [UIView animateWithDuration:0.5 animations:^{
        self.item_view.frame = CGRectMake(0, THeight, TWitdh, TWitdh*(11/10.));
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];

}

- (IBAction)cancel_btn:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.item_view.frame = CGRectMake(0, THeight, TWitdh, TWitdh*(11/10.));
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
- (IBAction)forgetBtn:(UIButton *)sender {
    

    
}

- (NSMutableDictionary *)mallOrderParms
{
    if (!_mallOrderParms) {
        _mallOrderParms = [NSMutableDictionary dictionary];
    }
    return _mallOrderParms;
}
- (IBAction)sureBtn:(UIButton *)sender {
    
    if ([self.password_tf.text isEqualToString:@""] || !self.password_tf.text) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请先输入密码" duration:1.5];
        return;
    }
    sender.enabled = NO;
    NSString *password = [[NSString stringWithFormat:@"%@%@",self.password_tf.text,PasswordKey]md5_32];
    [self.password_tf resignFirstResponder];
    if (self.payType == PayType_mallOrder) {//商品我的余额支付
        [self.mallOrderParms setObject:password forKey:@"password"];
        [HttpClient POST:@"pay/balance" parameters:self.mallOrderParms success:^(NSURLSessionDataTask *operation, id jsonObject) {
            sender.enabled = YES;
            if (IsRequestTrue) {
                if ([self.delegate respondsToSelector:@selector(paysuccess:)]) {
                    [self.delegate paysuccess:@"余额支付"];
                }
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            sender.enabled = YES;
            if ([self.delegate respondsToSelector:@selector(payfail)]) {
                [self.delegate payfail];
            }
        }];
        
    }else if(self.payType == PayType_mineOder){//我的订单
        NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token,
                                @"orderId":self.dataModel.orderId,
                                @"flag":@"true",
                                @"password":password};
        [HttpClient POST:@"user/order/confirm" parameters:prams success:^(NSURLSessionDataTask *operation, id jsonObject) {
            sender.enabled = YES;
            if (IsRequestTrue) {
                self.password_view.hidden = YES;
                self.passorError.hidden = YES;
                self.forgetBtn.hidden = YES;
                
                self.successView.hidden = NO;
                if (self.anmintionView) {
                    [self.anmintionView startLoading];
                    [self.anmintionView success:^{
                        self.successLabel.hidden = NO;
                        [self removeFromSuperview];
                    }];
                }
                if ([self.delegate respondsToSelector:@selector(paysuccess:)]) {
                    [self.delegate paysuccess:@"余额支付"];
                }
            }else if([NullToNumber(jsonObject[@"code"]) isEqualToString:@"-1"]){
                self.password_view.layer.borderColor = MacoColor.CGColor;
                self.password_view.hidden = NO;
                self.passorError.hidden = NO;
                //            self.forgetBtn.hidden = NO;
                self.successView.hidden = YES;
                self.successLabel.hidden = YES;
            }else if([NullToNumber(jsonObject[@"code"]) isEqualToString:@"-2"]){
                [self removeFromSuperview];
                if ([self.delegate respondsToSelector:@selector(paysuccess:)]) {
                    [self.delegate paysuccess:@"余额支付"];
                }
            }
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            sender.enabled = YES;
        }];
    }else if (self.payType == PayType_OnlineMchantOrder){
        [self.mallOrderParms setObject:password forKey:@"password"];
        [HttpClient POST:@"pay/mch/balance" parameters:self.mallOrderParms success:^(NSURLSessionDataTask *operation, id jsonObject) {
            sender.enabled = YES;
            if (IsRequestTrue) {
                if ([self.delegate respondsToSelector:@selector(paysuccess:)]) {
                    [self.delegate paysuccess:@"余额支付"];
                }
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            sender.enabled = YES;
            if ([self.delegate respondsToSelector:@selector(payfail)]) {
                [self.delegate payfail];
            }
        }];
    }
}





@end
