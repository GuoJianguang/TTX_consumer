//
//  WalletTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/23.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "WalletTableViewCell.h"


@implementation FanXianModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    FanXianModel *model = [[FanXianModel alloc]init];
    model.fanxianId = NullToSpace(dic[@"id"]);
    model.tranTime = NullToSpace(dic[@"tranTime"]);
    model.amount = NullToNumber(dic[@"amount"]);
    return model;
}

@end

@implementation TixianModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    TixianModel *model = [[TixianModel alloc]init];
    model.tixianId = NullToSpace(dic[@"id"]);
    model.withdrawAmout = NullToNumber(dic[@"withdrawAmout"]);
    model.successTime = NullToSpace(dic[@"successTime"]);
    model.state = NullToNumber(dic[@"state"]);
    return model;
}

@end


@implementation YuEPayModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    YuEPayModel *model = [[YuEPayModel alloc]init];
    model.yuEId = NullToSpace(dic[@"id"]);
    model.mchName = NullToNumber(dic[@"mchName"]);
    model.balanceAmount = NullToNumber(dic[@"balanceAmount"]);
    model.tranTime = NullToSpace(dic[@"tranTime"]);
    model.channel = NullToNumber(dic[@"channel"]);
    model.goodsName = NullToSpace(dic[@"goodsName"]);
    model.spec = NullToSpace(dic[@"spec"]);
    return model;
}

@end

@implementation WalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.name.textColor = [UIColor colorFromHexString:@"#636363"];
    self.time.textColor = MacoDetailColor;
    self.money.textColor = MacoTitleColor;
    self.money.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setYuEModel:(YuEPayModel *)yuEModel
{
    _yuEModel = yuEModel;
    if ([_yuEModel.channel isEqualToString:@"2"]) {
        self.name.text = [NSString stringWithFormat:@"%@",_yuEModel.goodsName];
        self.typeImage.image = [UIImage imageNamed:@"icon_mine_merchandise_balance_payment"];
    }else{
        self.name.text = [NSString stringWithFormat:@"%@",_yuEModel.mchName];
        self.typeImage.image = [UIImage imageNamed:@"icon_mine_merchant_balance_payment"];
    }
    self.money.text = [NSString stringWithFormat:@"%.2f",[_yuEModel.balanceAmount doubleValue]] ;
    self.time.text = _yuEModel.tranTime;
    
}

- (void)setTuijianModel:(InnitationModel *)tuijianModel
{
    _tuijianModel = tuijianModel;
    self.name.text = [NSString stringWithFormat:@"%@",_tuijianModel.mchName];
    self.money.text = [NSString stringWithFormat:@"%.2f",[_tuijianModel.tranAmount doubleValue]] ;
    self.typeImage.image = [UIImage imageNamed:@"icon_mine_recommended-income"];
    self.time.text = _tuijianModel.tranTime;
    
}

- (void)setTixianModel:(TixianModel *)tixianModel
{
    _tixianModel = tixianModel;
    self.money.text =[NSString stringWithFormat:@"￥%.2f", [_tixianModel.withdrawAmout doubleValue]];
    int status = [_tixianModel.state intValue];
    self.time.text = _tixianModel.successTime;
    switch (status) {
        case 0:
            self.typeImage.image = [UIImage imageNamed:@"icon_mine_in_the_present"];
            self.name.text = @"余额提现-待审核";
            break;
        case 1:
            self.typeImage.image = [UIImage imageNamed:@"icon_mine_balance_cash_withdrawal_successful"];
            self.name.text = @"余额提现-审核通过";
            break;
        case 2:
            self.typeImage.image = [UIImage imageNamed:@"icon_mine_in_the_present"];
            self.name.text = @"余额提现-提现中";
            break;
        case 3:
            self.typeImage.image = [UIImage imageNamed:@"icon_mine_balance_cash_withdrawal_successful"];
            self.name.text = @"余额提现-提现成功";
            break;
        case 4:
            self.typeImage.image = [UIImage imageNamed:@"icon_mine_balance_cash_withdrawal_fail"];
            self.name.text = @"余额提现-提现失败";

            break;
        default:
            break;
    }
}


- (void)setFanxianModel:(FanXianModel *)fanxianModel
{
    _fanxianModel = fanxianModel;
    self.name.text = @"平台回馈";
    self.typeImage.image = [UIImage imageNamed:@"icon_mine_platform_return"];
    self.money.text = [NSString stringWithFormat:@"%.2f",[_fanxianModel.amount doubleValue]] ;
    self.time.text = _fanxianModel.tranTime;
    
}

@end
