//
//  SureOrderViewController.m
//  tiantianxin
//
//  Created by ttx on 16/4/5.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "SureOrderViewController.h"
#import "SureGoodsOrderTableViewCell.h"
#import "PayView.h"
#import "PayResultView.h"
#import "MallShippingALTableViewCell.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "WeXinPayObject.h"
#import "Watch.h"


@interface SureOrderViewController ()<UITableViewDelegate,UITableViewDataSource,PayViewDelegate,BasenavigationDelegate,SureOrderDelegate>
@property (nonatomic, strong)PayView *payView;

@property (nonatomic, strong)PayResultView *resultView;

@property (nonatomic, strong)MallShippingAddressModel *addressmodel;

@end

@implementation SureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"确认订单";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.naviBar.delegate = self;
    [self addressRequest];
    
    CGFloat totalMoney = [NullToNumber(_goosPramsDic[@"number"]) integerValue]* self.mch_model.actualPrice + [_mch_model.freight doubleValue];
    self.totalLabel.text = [NSString stringWithFormat:@"￥ %.2f",totalMoney];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeShippingAddress:) name:@"selectAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weixinPayResult:) name:WeixinPayResult object:nil];
    self.sureBtn.backgroundColor = MacoColor;
    self.sureBtn.layer.cornerRadius = 35/2.;
    self.sureBtn.layer.masksToBounds = YES;
}


- (Watch *)mch_model
{
    if (!_mch_model) {
        _mch_model = [[Watch alloc]init];
    }
    return _mch_model;
}


- (NSDictionary *)goosPramsDic
{
    if (!_goosPramsDic) {
        _goosPramsDic = [NSDictionary dictionary];
    }
    return _goosPramsDic;
}


- (void)changeShippingAddress:(NSNotification *)notification
{
    self.addressmodel = notification.userInfo[@"model"];
    SureGoodsOrderTableViewCell *cell = self.tableView.visibleCells[0];
    cell.addressModel = self.addressmodel;
//    [self.tableView reloadData];
}


- (MallShippingAddressModel *)addressmodel
{
    if (!_addressmodel) {
        _addressmodel = [[MallShippingAddressModel alloc]init];
    }
    return _addressmodel;
}
- (PayView *)payView
{
    if (!_payView) {
        _payView = [[PayView alloc]init];
        _payView.delegate = self;
    }
    return _payView;
}

- (PayResultView *)resultView
{
    if (!_resultView) {
        _resultView = [[PayResultView alloc]init];
    }
    return _resultView;
}

#pragma mark - 请求收货地址列表
- (void)addressRequest
{
    NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token};
    [HttpClient POST:@"user/userInfo/address/get" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
              MallShippingAddressModel *model=  [MallShippingAddressModel modelWithDic:dic];
                if ([model.defaultFlag isEqualToString:@"1"]) {
                    self.addressmodel = model;
                }
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SureGoodsOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SureGoodsOrderTableViewCell indentify]];
    if (!cell) {
        cell = [SureGoodsOrderTableViewCell newCell];
    }
    cell.delegate = self;
    cell.addressModel = self.addressmodel;
    cell.dataModel = self.mch_model;
    cell.selectDetailDic = self.goosPramsDic;
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TWitdh/3.2 + 366 + 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)sureBtn:(UIButton *)sender {
//    SureGoodsOrderTableViewCell *cell = self.tableView.visibleCells[0];
//    if (cell.wexinPayBtn.selected) {
//        [self weixinPay];
//    }else{
////        在用余额支付的时候必须先进行实名认证
//        if ([self gotRealNameRu:@"在您用余额支付之前，请先进行实名认证"]) {
//            return;
//        } ;
//        [self balancePay];
//    }
//    
    [self balancePay];

}

- (void)weixinPay
{
    if (!self.addressmodel.addressId) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请选择或者填写收货地址" duration:2.];
        return;
    }
    SureGoodsOrderTableViewCell *cell = self.tableView.visibleCells[0];

    NSString *totalMoney = [NSString stringWithFormat:@"%.2f",[cell.numberTF.text integerValue]* self.mch_model.actualPrice+ [self.mch_model.freight doubleValue]];
    //    分别将商品ID、数量、交易金额、加密盐值(T2t0X16)等参数值拼接做md5加密，公式：md5(goodsId+price+ quantity+tranAmount+T2t0X16)
    
    NSString *md5Str = [NSString stringWithFormat:@"%@%@%@%@",self.mch_model.mch_id,cell.numberTF.text,totalMoney,OrderWithMd5Key];
    NSString *sign = [md5Str md5_32];
    //    NSString *password = [[NSString stringWithFormat:@"%@%@",self.password_tf.text,PasswordKey]md5_32];
    NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token,
                            @"priceId":NullToSpace(self.mch_model.priceId),
                            @"addrId":self.addressmodel.addressId,
                            @"goodsId":self.mch_model.mch_id,
                            @"spec":NullToSpace(self.goosPramsDic[@"yetSelcetPre"]),
                            @"price":@(self.mch_model.actualPrice),
                            @"quantity":NullToNumber(cell.numberTF.text),
                            @"freight":self.mch_model.freight,
                            @"tranAmount":totalMoney,
                            @"message":NullToSpace(cell.liuyanTF.text),
                            @"sign":sign
                            };
    
    [WeXinPayObject startWexinPay:prams];
}


- (void)balancePay
{
    if (!self.addressmodel.addressId) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请选择或者填写收货地址" duration:2.];
        return;
    }
    [self.view addSubview:self.payView];
    
    SureGoodsOrderTableViewCell *cell = self.tableView.visibleCells[0];
    NSString *totalMoney = [NSString stringWithFormat:@"%.2f",[cell.numberTF.text integerValue]* self.mch_model.actualPrice + [self.mch_model.freight doubleValue]];
    //    分别将商品ID、数量、交易金额、加密盐值(T2t0X16)等参数值拼接做md5加密，公式：md5(goodsId+price+ quantity+tranAmount+T2t0X16)
    NSString *md5Str = [NSString stringWithFormat:@"%@%@%@%@",self.mch_model.mch_id,cell.numberTF.text,totalMoney,OrderWithMd5Key];
    NSString *sign = [md5Str md5_32];
    
    //    NSString *password = [[NSString stringWithFormat:@"%@%@",self.password_tf.text,PasswordKey]md5_32];
    NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token,
                            @"priceId":NullToSpace(self.mch_model.priceId),
                            @"addrId":NullToSpace(self.addressmodel.addressId),
                            @"goodsId":self.mch_model.mch_id,
                            @"spec":NullToSpace(self.goosPramsDic[@"yetSelcetPre"]),
                            @"price":@(self.mch_model.actualPrice),
                            @"quantity":NullToNumber(cell.numberTF.text),
                            @"freight":self.mch_model.freight,
                            @"tranAmount":totalMoney,
                            @"message":NullToSpace(cell.liuyanTF.text),
                            @"sign":sign
                            };
    
    self.payView.mallOrderParms = [NSMutableDictionary dictionaryWithDictionary:prams];
    self.payView.payType = PayType_mallOrder;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(insets);
    }];
    [self PayViewanimation];
}

- (void)PayViewanimation
{
    self.payView.item_view.frame = CGRectMake(0, THeight , TWitdh, TWitdh*(11/10.));
    [UIView animateWithDuration:0.5 animations:^{
        self.payView.item_view.frame = CGRectMake(0, THeight - (TWitdh*(11/10.)), TWitdh, TWitdh*(11/10.));
    }];
}

#pragma mark - 实时改变总金额
- (void)selectGoodsAndSurePrice:(CGFloat)totalPrice
{
    self.totalLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",totalPrice];

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


- (void)paysuccess:(NSString *)payWay
{
    [self.payView removeFromSuperview];
    self.naviBar.title = @"支付成功";
    SureGoodsOrderTableViewCell *cell = self.tableView.visibleCells[0];
    //获取总金额
    NSString *totalMoney = [NSString stringWithFormat:@"%.2f",[cell.numberTF.text integerValue]* self.mch_model.actualPrice + [self.mch_model.freight doubleValue]];
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDictionary *prams = @{@"payWay":payWay,
                            @"tranAmount":totalMoney,
                            @"machantName":self.mch_model.name,
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


- (void)backBtnClick
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"selectAddress" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WeixinPayResult object:nil];
    [self.navigationController popViewControllerAnimated:YES];
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



@end
