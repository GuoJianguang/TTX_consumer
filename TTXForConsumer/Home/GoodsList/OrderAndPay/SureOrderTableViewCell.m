//
//  SureOrderTableViewCell.m
//  tiantianxin
//
//  Created by ttx on 16/4/5.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "SureOrderTableViewCell.h"
#import "MallSelectShippingAddressViewController.h"
#import "Watch.h"

@interface SureOrderTableViewCell()<UITextFieldDelegate>

@end

@implementation SureOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = MacoGrayColor;
    self.shippingPerson.textColor = MacoTitleColor;
    self.phoneLabel.textColor = MacoTitleColor;
    self.detailAddressLabel.textColor = MacoDetailColor;
    self.alerAddressLabel.textColor = MacoTitleColor;

    self.showAddressLabel.textColor = MacoTitleColor;
    self.alerAddressLabel.hidden = YES;
    self.payWayLabel.textColor = MacoTitleColor;
    self.mchInfoLabel.textColor = MacoTitleColor;

//    self.mchName.adjustsFontSizeToFitWidth = YES;
    
    self.mchName.textColor = MacoTitleColor;
    self.guigeLabel.textColor = MacoDetailColor;
    self.priceLabel.textColor = MacoColor;
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    
    self.shippingView.backgroundColor = [UIColor whiteColor];

    self.numberLabel.textColor = MacoTitleColor;
    self.buyNumberLabel.textColor = MacoTitleColor;
    self.peisongLabel.textColor = MacoTitleColor;
    self.maijialiuyanLabel.textColor = MacoTitleColor;
    self.liuyanTF.textColor = MacoDetailColor;
    self.totalLabel.textColor = MacoColor;
    self.balancePayLabel.textColor = MacoIntrodouceColor;
    self.wexinPayLabel.textColor = MacoIntrodouceColor;
    self.kuaidiLabel.textColor = MacoDetailColor;
    
    self.detailView.backgroundColor = [UIColor whiteColor];
    
    self.payView.backgroundColor = [UIColor whiteColor];

    
    self.numberTF.layer.borderWidth = 1;
    self.numberTF.layer.borderColor = MacoDetailColor.CGColor;
    self.addBtn.layer.borderWidth = 1;
    [self.addBtn setTitleColor:MacoDetailColor forState:UIControlStateNormal];
    self.addBtn.layer.borderColor = MacoDetailColor.CGColor;
    self.minusBtn.layer.borderWidth = 1;
    self.minusBtn.layer.borderColor = MacoDetailColor.CGColor;
    [self.minusBtn setTitleColor:MacoIntrodouceColor forState:UIControlStateNormal];
    self.numberTF.text = @"1";
    self.numberTF.textColor = MacoDetailColor;
    self.balancePayBtn.selected = YES;
    self.balancePayLabel.textColor = MacoColor;
    self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_sel"];

    
    
    self.numberTF.enabled = NO;
    
    self.liuyanTF.delegate = self;
    
}

- (void)setDataModel:(Watch *)dataModel
{
    _dataModel = dataModel;
    [self.mchImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImage] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
//    if (self.dataModel.changePrice == 0) {
//        self.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",[_dataModel.price doubleValue]];
//    }else{
//        self.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",_dataModel.changePrice];
//    }
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",_dataModel.actualPrice];

    self.mchName.text = [NSString stringWithFormat:@"%@",_dataModel.name];

    self.kuaidiLabel.text = [NSString stringWithFormat:@"快递:%@元",_dataModel.freight];
    if ([_dataModel.freight isEqualToString:@"0"]) {
        self.kuaidiLabel.text = @"邮费: 包邮";
    }
}
- (void)setSelectDetailDic:(NSDictionary *)selectDetailDic
{
    _selectDetailDic = selectDetailDic;
    self.numberTF.text = NullToNumber(_selectDetailDic[@"number"]);
    self.numberLabel.text = NullToNumber(_selectDetailDic[@"number"]);
    self.guigeLabel.text= NullToSpace(_selectDetailDic[@"yetSelcetPre"]);
    if ([NullToSpace(_selectDetailDic[@"yetSelcetPre"]) isEqualToString:@""]) {
        self.guigeLabel.text = @"已选:--";
    }
//    if (self.dataModel.changePrice == 0) {
//        CGFloat totalMoney = [self.numberTF.text integerValue]* [self.dataModel.price doubleValue] + [_dataModel.freight doubleValue];
//        self.totalLabel.text = [NSString stringWithFormat:@"共%@件,总计: %.2f元",self.numberTF.text,totalMoney];
//        return;
//    }
    CGFloat totalMoney = [self.numberTF.text integerValue]* self.dataModel.actualPrice + [_dataModel.freight doubleValue];
    self.totalLabel.text = [NSString stringWithFormat:@"共%@件,总计: %.2f元",self.numberTF.text,totalMoney];
    
    if ([self.numberTF.text integerValue]== 1) {
        self.minusBtn.layer.borderColor = [UIColor colorFromHexString:@"c8c8c8"].CGColor;
        [self.minusBtn setTitleColor:[UIColor colorFromHexString:@"c8c8c8"] forState:UIControlStateNormal];
    }
}



- (IBAction)addBtn:(UIButton *)sender {
    self.minusBtn.layer.borderColor = MacoIntrodouceColor.CGColor;
    [self.minusBtn setTitleColor:MacoIntrodouceColor forState:UIControlStateNormal];
    self.numberTF.text =[NSString stringWithFormat:@"%ld",[self.numberTF.text integerValue]+1];
    self.numberLabel.text = self.numberTF.text;
    
    CGFloat totalMoney = [self.numberTF.text integerValue]* self.dataModel.actualPrice + [_dataModel.freight doubleValue];
    self.totalLabel.text = [NSString stringWithFormat:@"共%@件,总计: %.2f元",self.numberTF.text,totalMoney];
    if ([self.delegate respondsToSelector:@selector(selectGoodsAndSurePrice:)]) {
        [self.delegate selectGoodsAndSurePrice:totalMoney];
    }

}

- (IBAction)minusBtn:(UIButton *)sender {
    if ([self.numberTF.text integerValue]== 2) {
        self.minusBtn.layer.borderColor = [UIColor colorFromHexString:@"c8c8c8"].CGColor;
        [self.minusBtn setTitleColor:[UIColor colorFromHexString:@"c8c8c8"] forState:UIControlStateNormal];
    }
    if ([self.numberTF.text integerValue] < 2 ) {
        return;
    }
    self.numberTF.text =[NSString stringWithFormat:@"%ld",[self.numberTF.text integerValue]-1];
    self.numberLabel.text = self.numberTF.text;

    CGFloat totalMoney = [self.numberTF.text integerValue]* self.dataModel.actualPrice + [_dataModel.freight doubleValue];
    self.totalLabel.text = [NSString stringWithFormat:@"共%@件,总计: %.2f元",self.numberTF.text,totalMoney];
    if ([self.delegate respondsToSelector:@selector(selectGoodsAndSurePrice:)]) {
        [self.delegate selectGoodsAndSurePrice:totalMoney];
    }
    
}

- (IBAction)balancePayBtn:(UIButton *)sender {
    self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_sel"];
    self.wechatImage.image = [UIImage imageNamed:@"icon_scan_weixin_payment_nor"];
    self.wexinPayBtn.selected = NO;
    self.balancePayLabel.textColor = MacoColor;
    self.wexinPayLabel.textColor = MacoIntrodouceColor;
    self.balancePayBtn.selected = YES;

}


- (IBAction)wexinPayBtn:(UIButton *)sender {
    self.balancePayBtn.selected = NO;
    self.yueImage.image = [UIImage imageNamed:@"icon_scan_balance_payment_nor"];
    self.wechatImage.image = [UIImage imageNamed:@"icon_scan_weixin_payment_sel"];
    self.wexinPayLabel.textColor = MacoColor;
    self.balancePayLabel.textColor = MacoIntrodouceColor;
    self.wexinPayBtn.selected = YES;

}



- (void)setAddressModel:(MallShippingAddressModel *)addressModel
{
    _addressModel = addressModel;
    if (!_addressModel.addressId) {
       self.detailAddressLabel.hidden = YES;
        self.shippingPerson.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.alerAddressLabel.hidden = NO;
    }else{
        self.shippingPerson.hidden = NO;
        self.phoneLabel.hidden = NO;
        self.alerAddressLabel.hidden = YES;
        self.detailAddressLabel.hidden = NO;
        self.shippingPerson.text = [NSString stringWithFormat:@"收货人:%@",NullToSpace(_addressModel.name)];
        self.phoneLabel.text = [NSString stringWithFormat:@"电话:%@",NullToSpace(_addressModel.phone)];
        self.detailAddressLabel.text = [NSString stringWithFormat:@"收货地址:%@",NullToSpace(_addressModel.addressDetail)];
    }
}


- (IBAction)selectShippingBtn:(UIButton *)sender {
    
    MallSelectShippingAddressViewController *mallVC = [[MallSelectShippingAddressViewController alloc]init];
    [self.viewController.navigationController pushViewController:mallVC animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.liuyanTF) {
        if (self.liuyanTF.text.length > 49 &&  ![string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;

}

@end
