//
//  ScanPayViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/19.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "ScanPayViewController.h"
#import "PayView.h"
#import "PayResultView.h"
#import "WeXinPayObject.h"


@interface ScanPayViewController ()<UITextFieldDelegate,PayViewDelegate,BasenavigationDelegate>

//支付的view
@property (nonatomic, strong)PayView *payView;
//展示支付结果的view
@property (nonatomic, strong)PayResultView *resultView;

@end

@implementation ScanPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.backTitle = @"取消";
    self.naviBar.hiddenBackBtn = YES;
    self.naviBar.hiddenBackBtnImage = YES;
    
    self.naviBar.title = @"扫码支付";
    self.naviBar.delegate = self;
    self.sureBtn.layer.cornerRadius = (TWitdh- 120)/12;
    self.sureBtn.layer.masksToBounds = YES;
    self.yueBtn.selected = YES;
    self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_sel"];
    self.payWay_type = Online_Payway_type_banlance;
    
    self.sureBtn.backgroundColor = MacoColor;
    self.sureBtn.layer.cornerRadius = 20.;
    self.sureBtn.layer.masksToBounds = YES;
    self.mchInfo.textColor = MacoDetailColor;
    
    
    
    self.payWay_type = Online_Payway_type_wechat;
    self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_nor"];
    self.wechatImage.image = [UIImage imageNamed:@"icon_scan_weixin_payment_sel"];
    self.yueBtn.selected = NO;
    self.wechatBtn.selected = YES;
    self.wechatLabel.textColor = MacoColor;
    self.yueLabel.textColor = MacoTitleColor;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.money doubleValue]];
    [self detailRequest:self.mchCode];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weixinPayResult:) name:WeixinPayResult object:nil];
}



#pragma mark - 商户详情接口请求
- (void)detailRequest:(NSString *)code
{
    NSDictionary *parms = @{@"code":code};
    [HttpClient GET:@"mch/get" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            self.mchInfo.text = [NSString stringWithFormat:@"商家信息：%@",NullToSpace(jsonObject[@"data"][@"name"])] ;
            self.mchName = [NSString stringWithFormat:@"商家信息：%@",NullToSpace(jsonObject[@"data"][@"name"])];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (NSString *)mchName
{
    if (!_mchName) {
        _mchName = [NSString string];
    }
    return _mchName;
}

- (NSString *)mchCode
{
    if (!_mchCode) {
        _mchCode = [NSString string];
    }
    return _mchCode;
}

- (NSString *)money
{
    if (!_money) {
        _money = [NSString string];
    }
    return _money;
}


- (PayResultView *)resultView
{
    if (!_resultView) {
        _resultView = [[PayResultView alloc]init];
    }
    return _resultView;
}
- (PayView *)payView
{
    if (!_payView) {
        _payView = [[PayView alloc]init];
        _payView.delegate = self;
    }
    return _payView;
}
- (IBAction)yueBtn:(UIButton *)sender {
    self.payWay_type = Online_Payway_type_banlance;
    self.wechatBtn.selected = NO;
    self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_sel"];
    self.wechatImage.image = [UIImage imageNamed:@"icon_scan_weixin_payment_nor"];
    self.yueBtn.selected = YES;
    self.yueLabel.textColor = MacoColor;
    self.wechatLabel.textColor = MacoTitleColor;
    
}
- (IBAction)wechatBtn:(UIButton *)sender {
    self.payWay_type = Online_Payway_type_wechat;
    self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_nor"];
    self.wechatImage.image = [UIImage imageNamed:@"icon_scan_weixin_payment_sel"];
    self.yueBtn.selected = NO;
    self.wechatBtn.selected = YES;
    self.wechatLabel.textColor = MacoColor;
    self.yueLabel.textColor = MacoTitleColor;
}

#pragma mark - 确认支付
- (IBAction)sureBtn:(UIButton *)sender {
    
    if (![TTXUserInfo shareUserInfos].currentLogined) {
        //判断是否先登录
        UINavigationController *navc = [LoginViewController controller];
        [self presentViewController:navc animated:YES completion:NULL];
        return;
    }
    
    if (self.payWay_type == Online_Payway_type_banlance) {
        //        在用余额支付的时候必须先进行实名认证
        if ([self gotRealNameRu:@"在您用余额支付之前，请先进行实名认证"]) {
            return;
        }
    }
    if ([self.money doubleValue] < 20.) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"您消费的金额不能少于20元" duration:2.];
        return;
    }
    switch (self.payWay_type) {
        case Online_Payway_type_banlance://余额支付
        {
            
            [self balancePay];
        }
            break;
        case Online_Payway_type_wechat://微信支付
            [self weChatPay];
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark - 支付方式（微信支付或者余额支付）
- (void)balancePay
{
    NSString *totalMoney = [NSString stringWithFormat:@"%.2f",[self.money doubleValue]];
    [self.view addSubview:self.payView];
    self.payView.payType = PayType_OnlineMchantOrder;
    NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token,
                            @"mchCode":NullToSpace(self.mchCode),
                            @"tranAmount":totalMoney};
    self.payView.mallOrderParms = [NSMutableDictionary dictionaryWithDictionary:prams];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(insets);
    }];
    [self PayViewanimation];
    
}
- (void)weChatPay
{
    NSString *totalMoney = [NSString stringWithFormat:@"%.2f",[self.money doubleValue]];
    NSString *md5Str = [NSString stringWithFormat:@"%@%@",                [[NSUserDefaults standardUserDefaults]objectForKey:LoginUserPassword]
                        ,PasswordKey];
    NSString *sign = [md5Str md5_32];
    NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token,
                            @"mchCode":NullToSpace(self.mchCode),
                            @"tranAmount":totalMoney,
                            @"password":sign};
    [WeXinPayObject srarMachantWexinPay:prams];
    
}
#pragma mark - 支付结果的展示
//支付成功
- (void)paysuccess:(NSString *)payWay
{
    [self.payView removeFromSuperview];
    self.naviBar.title = @"支付成功";
    //获取总金额
    NSString *totalMoney = [NSString stringWithFormat:@"%.2f",[self.money doubleValue]];
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDictionary *prams = @{@"payWay":payWay,
                            @"tranAmount":totalMoney,
                            @"machantName":self.mchName,
                            @"payTime":dateString
                            };
    self.resultView.orderInfoDic = prams;
    [self.view addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.resultView buttonActionsuccess];
}
//支付成功
- (void)payfail
{
    [self.payView removeFromSuperview];
    self.naviBar.title = @"支付失败";
    [self.view addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.resultView buttonActionFail];
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
            [self paysuccess:@"微信支付"];
        }
            
            break;
        case WXErrCodeCommon:
            [[JAlertViewHelper shareAlterHelper]showTint:@"支付失败" duration:2.];
            
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

- (void)PayViewanimation
{
    self.payView.item_view.frame = CGRectMake(0, THeight , TWitdh, TWitdh*(11/10.));
    [UIView animateWithDuration:0.5 animations:^{
        self.payView.item_view.frame = CGRectMake(0, THeight - (TWitdh*(11/10.)), TWitdh, TWitdh*(11/10.));
    }];
}

- (void)backBtnClick
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WeixinPayResult object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
            [self.navigationController pushViewController:realNVC animated:YES];
        }];
        [alertcontroller addAction:cancelAction];
        [alertcontroller addAction:otherAction];
        [self presentViewController:alertcontroller animated:YES completion:NULL];
        return YES;
    }
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
