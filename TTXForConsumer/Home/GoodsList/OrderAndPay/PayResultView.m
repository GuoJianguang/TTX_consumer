//
//  PayResultView.m
//  tiantianxin
//
//  Created by ttx on 16/4/5.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "PayResultView.h"
//#import "WaitSendMchViewController.h"
#import "OderListViewController.h"

@implementation PayResultView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"PayResultView" owner:nil options:nil][0];
        self.backgroundColor = MacoGrayColor;
        
        self.itemView.layer.borderWidth = 1;
        self.itemView.layer.borderColor = MacoGrayColor.CGColor;
//        self.itemsView.layer.borderWidth = 1;
//        self.itemsView.layer.borderColor = MacoGrayColor.CGColor;
        
        self.anmintionView = [[MoView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.resultView addSubview:self.anmintionView];
        self.anmintionView.center = CGPointMake(CGRectGetWidth(self.resultView.frame)/2, CGRectGetHeight(self.resultView.frame)/2);
        self.anmintionView.backgroundColor = [UIColor orangeColor];
        self.anmintionView.layer.cornerRadius = CGRectGetHeight(self.anmintionView.bounds)/2;
        self.anmintionView.layer.masksToBounds = YES;
        
        self.resultLabel.textColor = MacoDetailColor;
        self.checkBtn.layer.cornerRadius = 5;
        self.checkBtn.layer.borderWidth = 1;
        [self.checkBtn setTitleColor:MacoColor forState:UIControlStateNormal];
        self.checkBtn.layer.borderColor = MacoColor.CGColor;
        
        self.continueBtn.layer.cornerRadius = 5;
        self.continueBtn.layer.borderWidth = 1;
        [self.continueBtn setTitleColor:MacoColor forState:UIControlStateNormal];
        self.continueBtn.layer.borderColor = MacoColor.CGColor;
    }
    
    return self;
}


- (void)awakeFromNib
{
    self.resultLabel.textColor = MacoTitleColor;

    self.showmoney.textColor = MacoDetailColor;
    self.showpayWay.textColor = MacoDetailColor;
    self.showpaytime.textColor = MacoDetailColor;
    self.showmachantInfo.textColor = MacoDetailColor;
    self.money.textColor = MacoDetailColor;
    self.payWay.textColor = MacoDetailColor;
    self.machantInfo.textColor = MacoDetailColor;
    self.paytime.textColor = MacoDetailColor;
    
    UIImage *image = [UIImage imageNamed:@"bg_mine_certification_success"];
    image= [image resizableImageWithCapInsets:UIEdgeInsetsMake(100, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    self.bgImageView.image  = image;
}

#pragma mark - 订单信息

- (void)setOrderInfoDic:(NSDictionary *)orderInfoDic
{
    _orderInfoDic = orderInfoDic;
    self.payWay.text = _orderInfoDic[@"payWay"];
    self.money.text = _orderInfoDic[@"tranAmount"];
    self.paytime.text = _orderInfoDic[@"payTime"];
    self.machantInfo.text =_orderInfoDic[@"machantName"];
    
}


- (void)buttonActionsuccess
{
    if (self.anmintionView) {
        [self.anmintionView startLoading];
        [self.anmintionView success:^{
            self.resultLabel.text = @"支付成功";
        }];
    }
}

- (void)buttonActionFail
{
    if (self.anmintionView) {
        [self.anmintionView startLoading];
        [self.anmintionView error:^{
            self.resultLabel.text = @"支付失败";
        }];
    }
}


- (IBAction)continueBtn:(UIButton *)sender {
    //    WaitSendMchViewController *waitsendVC = [[WaitSendMchViewController alloc]init];
    //    waitsendVC.isFormPayView = YES;
    //    [self.viewController.navigationController pushViewController:waitsendVC animated:YES];
    [self.viewController.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 查看订单
- (IBAction)checkBtn:(UIButton *)sender {
    OderListViewController *orderVC = [[OderListViewController alloc]init];
    orderVC.orderType = Order_type_all;
    [self.viewController.navigationController pushViewController:orderVC animated:YES];

}
@end
