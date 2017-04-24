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
    self.mchName.textColor = self.wexiPayLabel.textColor = self.ttxMoneyPayLabel.textColor =MacoTitleColor;
    self.kuaidi.textColor = MacoDetailColor;
    self.oldprice.textColor = MacoDetailColor;
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
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@",_dataModel.originalPrice] attributes:attribtDic];
    self.oldprice.attributedText = attribtStr;
    if ([self.dataModel.goods_type isEqualToString:@"2"]) {
        self.oldprice.hidden = NO;
    }else{
        self.oldprice.hidden= YES;
    }
    
    switch ([_dataModel.payTyp integerValue]) {
        case 0://自由支付
        {
            self.wexiPayLabel.hidden=self.ttxMoneyPayLabel.hidden = YES;
            
        }
            break;
        case 1://现金
        {
            self.wexiPayLabel.hidden = YES;
            self.ttxMoneyPayLabel.hidden = NO;
            self.ttxMoneyPayLabel.text = [NSString stringWithFormat:@"银联支付¥%.2f",[_dataModel.price doubleValue]];
        }
            
            break;
        case 2://现金余额
        {
            self.wexiPayLabel.hidden = NO;
            self.ttxMoneyPayLabel.hidden = NO;
            self.ttxMoneyPayLabel.text = [NSString stringWithFormat:@"余额支付¥%.2f",[_dataModel.balanceAmount doubleValue]];
            self.wexiPayLabel.text = [NSString stringWithFormat:@"银联支付¥%.2f",[_dataModel.cashAmount doubleValue]];
        }
            break;
        case 3://现金待回馈
        {
            self.wexiPayLabel.hidden = NO;
            self.ttxMoneyPayLabel.hidden = NO;
            self.ttxMoneyPayLabel.text = [NSString stringWithFormat:@"待回馈金额支付¥%.2f",[_dataModel.expectAmount doubleValue]];
            self.wexiPayLabel.text = [NSString stringWithFormat:@"银联支付¥%.2f",[_dataModel.cashAmount doubleValue]];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 查看店铺
- (IBAction)checkStoreBtn:(UIButton *)sender {
    NewMerchantDetailViewController *detailVC = [[NewMerchantDetailViewController alloc]init];
    detailVC.merchantCode = self.dataModel.mchCode;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}


@end
