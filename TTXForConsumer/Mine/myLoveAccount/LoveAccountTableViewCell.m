//
//  LoveAccountTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 16/11/10.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "LoveAccountTableViewCell.h"
#import "WeXinPayObject.h"

@implementation LoveAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.explainTextView.text = @"账户说明：\nXCode工程目录里面,有时你会发现2个不同颜色的文件夹,一种是蓝色的,一种是黄色的,最常见的是黄色的,我也是最近学习html5的时候,发现还有蓝色的文件夹呢, 来上...";
    self.explainTextView.textColor = MacoTitleColor;
    self.explainTextView.editable = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weixinPayResult:) name:WeixinPayResult object:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataModel:(NSDictionary *)dataModel
{
    _dataModel = dataModel;
    if ([NullToNumber(_dataModel[@"recharge"]) isEqualToString:@"0"]) {
        self.rechargeBtn.hidden = NO;
    }else{
        self.rechargeBtn.hidden = YES;
    }
    self.loveAccountMoeny.text = [NSString stringWithFormat:@"%.2f",[NullToNumber(_dataModel[@"amount"]) doubleValue]];
}

- (IBAction)backBtn:(id)sender {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WeixinPayResult object:nil];
    [self.viewController.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 充值爱心账户
- (IBAction)rechargeBtn:(id)sender {
    NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token};
    [WeXinPayObject loveAcountWexinPay:parms];
}

#pragma mark - 微信支付结果回调
- (void)weixinPayResult:(NSNotification *)notification
{
    //    WXSuccess           = 0,    /**< 成功    */
    //    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    //    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    //    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    //    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    //    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    NSString *code = notification.userInfo[@"resultcode"];
    switch ([code intValue]) {
        case WXSuccess:
        {
            __weak LoveAccountTableViewCell *weak_self = self;
            NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token};
            [HttpClient POST:@"user/donate/get" parameters:prams success:^(NSURLSessionDataTask *operation, id jsonObject) {
                if ([jsonObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                    self.dataModel = jsonObject[@"data"];
                }else{
                    [[NSNotificationCenter defaultCenter]removeObserver:self name:WeixinPayResult object:nil];
                    [weak_self.viewController.navigationController popToRootViewControllerAnimated:YES];
                }
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [[NSNotificationCenter defaultCenter]removeObserver:self name:WeixinPayResult object:nil];
                [weak_self.viewController.navigationController popToRootViewControllerAnimated:YES];
            }];

        }
            break;
        case WXErrCodeCommon:
            [[JAlertViewHelper shareAlterHelper]showTint:@"充值失败" duration:2.];
            
            break;
        case WXErrCodeUserCancel:
            [[JAlertViewHelper shareAlterHelper]showTint:@"您已取消支付" duration:2.];
            
            break;
        case WXErrCodeSentFail:
            [[JAlertViewHelper shareAlterHelper]showTint:@"发起支付请求失败" duration:2.];
            
            break;
        case WXErrCodeAuthDeny:
            [[JAlertViewHelper shareAlterHelper]showTint:@"微信支付授权失败" duration:2.];
            break;
        case WXErrCodeUnsupport:
            [[JAlertViewHelper shareAlterHelper]showTint:@"您未安装微信客户端,请先安装" duration:2.];
            break;
        default:
            break;
    }
}



@end
