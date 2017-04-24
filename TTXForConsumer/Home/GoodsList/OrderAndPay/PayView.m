//
//  PayView.m
//  天添薪
//
//  Created by ttx on 16/1/11.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "PayView.h"
//#import "WaitPayViewController.h"
#import "WeXinPayObject.h"

@interface PayView()

@property (nonatomic, assign)double xiaofeiJinMoney;

@end

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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.backView addGestureRecognizer:tap];
    }

    return self;
}

- (void)setIsHavieWechatPay:(BOOL)isHavieWechatPay
{
    _isHavieWechatPay  = isHavieWechatPay;
    if (_isHavieWechatPay) {
        self.wechatLabel.text = @"微信支付";
        self.wechatImage.image = [UIImage imageNamed:@"icon_scan_weixin_payment_nor"];
    }else{
        self.wechatImage.image = [UIImage imageNamed:@"icon_unionpay_nor"];
        self.wechatLabel.text = @"银联支付";
    }
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

    
//    self.password_view.hidden = NO;
    self.passorError.hidden = YES;
    self.forgetBtn.hidden = YES;
    self.password_view.layer.borderColor = [UIColor whitegrayColor].CGColor;
    self.password_tf.text = @"";
    
    
    self.yueLabel.adjustsFontSizeToFitWidth = YES;
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


- (void)setMallOrderParms:(NSMutableDictionary *)mallOrderParms
{
    _mallOrderParms = mallOrderParms;
    
    //默认余额支付
    self.payWay_type = Payway_type_banlance;
    self.wechatBtn.selected = NO;
    self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_sel"];
    if (self.isHavieWechatPay) {
        self.wechatImage.image = [UIImage imageNamed:@"icon_scan_weixin_payment_nor"];
    }else{
        self.wechatImage.image = [UIImage imageNamed:@"icon_unionpay_nor"];
    }
    self.yueBtn.selected = YES;
    self.yueLabel.textColor = MacoColor;
    self.wechatLabel.textColor = MacoTitleColor;
    
    double xiaofeiJin = [[TTXUserInfo shareUserInfos].consumeBalance doubleValue];
    double payMoney = [NullToNumber(_mallOrderParms[@"tranAmount"]) doubleValue];
    double yuE = [[TTXUserInfo shareUserInfos].aviableBalance doubleValue];
    
    if (xiaofeiJin >= payMoney) {
        self.yueLabel.text = [NSString stringWithFormat:@"余额支付(消费金%.2f元)",payMoney];
        self.xiaofeiJinMoney = xiaofeiJin - payMoney;
    }else if (payMoney > xiaofeiJin && payMoney - xiaofeiJin < yuE && xiaofeiJin !=0){
        self.yueLabel.text = [NSString stringWithFormat:@"余额支付(消费金%.2f元+余额%.2f元)",xiaofeiJin,(payMoney - xiaofeiJin)];
        self.xiaofeiJinMoney = 0;
    }else if(xiaofeiJin==0 && payMoney < yuE){
        self.yueLabel.text = [NSString stringWithFormat:@"余额支付(余额%.2f元)",payMoney];
        self.xiaofeiJinMoney = 0;
    }else if(payMoney > yuE + xiaofeiJin){
        self.yueLabel.text = [NSString stringWithFormat:@"余额和消费金额不足，请用微信支付"];
        self.password_view.hidden = YES;

        self.payWay_type = Payway_type_wechat;
        self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_nor"];
        if (self.isHavieWechatPay) {
            self.wechatImage.image = [UIImage imageNamed:@"icon_scan_weixin_payment_sel"];
        }else{
            self.wechatImage.image = [UIImage imageNamed:@"icon_unionpay_sel"];
        }
        self.yueBtn.selected = NO;
        self.wechatBtn.selected = YES;
        self.wechatLabel.textColor = MacoColor;
        self.yueLabel.textColor = MacoTitleColor;
        self.yuEActionBtn.enabled = NO;
        self.yueBtn.enabled = NO;
        return;
    }
    
    self.password_view.hidden = NO;
    self.yuEActionBtn.enabled = YES;
    self.yueBtn.enabled = YES;
}


- (IBAction)sureBtn:(UIButton *)sender {
    
    if (self.payWay_type == Payway_type_wechat) {
        [self wechatPay:sender];
        
        return;
    }
    

    if ([self gotRealNameRu:@"在您用余额支付之前，请先进行实名认证"]) {
        return;
    }
 
    
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
                    [TTXUserInfo shareUserInfos].consumeBalance = [NSString stringWithFormat:@"%.2f",self.xiaofeiJinMoney];
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
                    [TTXUserInfo shareUserInfos].consumeBalance = [NSString stringWithFormat:@"%.2f",self.xiaofeiJinMoney];
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
                    [TTXUserInfo shareUserInfos].consumeBalance = [NSString stringWithFormat:@"%.2f",self.xiaofeiJinMoney];
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
                    [TTXUserInfo shareUserInfos].consumeBalance = [NSString stringWithFormat:@"%.2f",self.xiaofeiJinMoney];
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


#pragma mark - 选择支付方式
- (IBAction)yueBtn:(UIButton *)sender {
    
    self.password_view.hidden = NO;
    self.payWay_type = Payway_type_banlance;
    self.wechatBtn.selected = NO;
    self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_sel"];
    if (self.isHavieWechatPay) {
        self.wechatImage.image = [UIImage imageNamed:@"icon_scan_weixin_payment_nor"];
    }else{
        self.wechatImage.image = [UIImage imageNamed:@"icon_unionpay_nor"];
    }
    self.yueBtn.selected = YES;
    self.yueLabel.textColor = MacoColor;
    self.wechatLabel.textColor = MacoTitleColor;
    
}
- (IBAction)wechatBtn:(UIButton *)sender {
    self.password_view.hidden = YES;
    self.payWay_type = Payway_type_wechat;
    self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_nor"];
    if (self.isHavieWechatPay) {
        self.wechatImage.image = [UIImage imageNamed:@"icon_scan_weixin_payment_sel"];
    }else{
        self.wechatImage.image = [UIImage imageNamed:@"icon_unionpay_sel"];
    }
    self.yueBtn.selected = NO;
    self.wechatBtn.selected = YES;
    self.wechatLabel.textColor = MacoColor;
    self.yueLabel.textColor = MacoTitleColor;
    

}

#pragma mark - 微信支付

- (void)wechatPay:(UIButton *)button
{
    
    switch (self.payType) {
        case PayType_mallOrder:
        {
    
            //[WeXinPayObject startWexinPay:self.mallOrderParms];
            [UPPayObject startWexinPay:self.mallOrderParms withController:self.viewController];
            
        }
            break;
            
        case PayType_OnlineMchantOrder:
        {
            NSString *totalMoney = NullToNumber(self.mallOrderParms[@"tranAmount"]);
            NSString *md5Str = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]objectForKey:LoginUserPassword],PasswordKey];
            NSString *sign = [md5Str md5_32];
            
            NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token,
                                    @"mchCode":NullToNumber(self.mallOrderParms[@"mchCode"]),
                                    @"tranAmount":totalMoney,
                                    @"password":sign};
            [WeXinPayObject srarMachantWexinPay:prams];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 去进行实名认证
- (BOOL)gotRealNameRu:(NSString *)alerTitle
{
    if (![TTXUserInfo shareUserInfos].identityFlag) {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"重要提示" message:alerTitle preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //去进行实名认证
            RealNameAutViewController *realNVC = [[RealNameAutViewController alloc]init];
            realNVC.isYetAut = NO;
            [self.viewController.navigationController pushViewController:realNVC animated:YES];
        }];
        [alertcontroller addAction:cancelAction];
        [alertcontroller addAction:otherAction];
        [self.viewController presentViewController:alertcontroller animated:YES completion:NULL];
        return YES;
    }
    return NO;
}


@end
