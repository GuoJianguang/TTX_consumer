//
//  GoodsDetailView.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsDetailIntroduceView.h"
#import "Watch.h"
#import "NewMerchantDetailViewController.h"

@implementation GoodsDetailIntroduceView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.price.textColor = MacoPriceColor;
    self.mchName.textColor = MacoTitleColor;
    self.kuaidi.textColor = MacoDetailColor;
    [self.checkStoreBtn setTitleColor:MacoColor forState:UIControlStateNormal];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"GoodsDetailIntroduceView" owner:nil options:nil][0];
    }
    return self;
}

- (void)setDataModel:(Watch *)dataModel
{
    _dataModel = dataModel;
    self.mchName.text = _dataModel.name;
    self.kuaidi.text = [NSString stringWithFormat:@"快递:%.2f元",[_dataModel.freight doubleValue]];
    if ([_dataModel.freight isEqualToString:@"0"]) {
        self.kuaidi.text = @"快递:包邮";
    }
    self.price.text = [NSString stringWithFormat:@"￥%.2f",[_dataModel.price doubleValue]];
}

#pragma mark - 查看店铺
- (IBAction)checkStoreBtn:(UIButton *)sender {
    NewMerchantDetailViewController *detailVC = [[NewMerchantDetailViewController alloc]init];
    detailVC.merchantCode = self.dataModel.mchCode;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}



@end
