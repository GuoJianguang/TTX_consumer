//
//  MyWallectCollectionViewCell.m
//  天添薪
//
//  Created by ttx on 16/1/11.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MyWallectCollectionViewCell.h"


@implementation InnitationModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    InnitationModel *model = [[InnitationModel alloc]init];
    model.tranTime = NullToSpace(dic[@"tranTime"]);
    model.mchCode = NullToNumber(dic[@"mchCode"]);
    model.mchName = NullToSpace(dic[@"mchName"]);
    model.tranAmount = NullToNumber(dic[@"tranAmount"]);
    model.totalAmount = NullToNumber(dic[@"totalAmount"]);
    model.totalqueryAmount = NullToNumber(dic[@"totalqueryAmount"]);

    
    return model;
}

@end

@implementation XiaofeiModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    XiaofeiModel *model = [[XiaofeiModel alloc]init];
    model.orderId = NullToSpace(dic[@"orderId"]);
    model.totalAmount = NullToNumber(dic[@"totalAmount"]);
    model.balanceAmount = NullToNumber(dic[@"balanceAmount"]);
    model.cashAmount = NullToNumber(dic[@"cashAmount"]);
    model.pic = NullToSpace(dic[@"pic"]);
    model.tranTime = NullToSpace(dic[@"tranTime"]);
    model.mchCode = NullToSpace(dic[@"mchCode"]);
    model.mchName = NullToSpace(dic[@"mchName"]);
    //判断是什么类型的订单
    model.channel = NullToNumber(dic[@"channel"]);
    model.pay_type = NullToNumber(dic[@"payType"]);
    return model;
}


@end





@implementation MyWallectCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.name_label.textColor = MacoTitleColor;
    self.detail_label.textColor = MacoIntrodouceColor;
    self.stauts_label.textColor = MacoTitleColor;
    self.stauts_label.adjustsFontSizeToFitWidth = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
}


- (void)setXiaofeiDataModel:(XiaofeiModel *)xiaofeiDataModel
{
    _xiaofeiDataModel = xiaofeiDataModel;
    self.name_label.text = _xiaofeiDataModel.mchName;
    self.stauts_label.text = [NSString stringWithFormat:@"-%.2f",[_xiaofeiDataModel.totalAmount floatValue]];
    self.detail_label.text = [NSString stringWithFormat:@"%@\n订单金额%.2f元(账户扣除%.2f元+%.2f元现金)",_xiaofeiDataModel.tranTime,[_xiaofeiDataModel.totalAmount floatValue],[_xiaofeiDataModel.balanceAmount floatValue],[_xiaofeiDataModel.cashAmount floatValue]];
    if ([_xiaofeiDataModel.channel isEqualToString:@"2"]) {
        NSString *zhifuType = [NSString string];
        if ([_xiaofeiDataModel.pay_type isEqualToString:@"0"]) {
            zhifuType = @"余额支付";
        }else if([_xiaofeiDataModel.pay_type isEqualToString:@"1"]){
            zhifuType = @"微信支付";
        }
        self.detail_label.text = [NSString stringWithFormat:@"%@\n订单金额%.2f元(%@)",_xiaofeiDataModel.tranTime,[_xiaofeiDataModel.totalAmount floatValue],zhifuType];
    }
    
}


//- (void)setFanXianDataModel:(FanXianModel *)fanXianDataModel
//{
//    _fanXianDataModel = fanXianDataModel;
//    self.name_label.text = @"平台让利回馈";
//    self.stauts_label.text = [NSString stringWithFormat:@"+%.2f",[_fanXianDataModel.amount floatValue]];
//    self.detail_label.text = [NSString stringWithFormat:@"%@\n让利回馈%.2f元",_fanXianDataModel.tranTime ,[_fanXianDataModel.amount floatValue]];
//}

//- (void)setTixianDataModel:(TixianModel *)tixianDataModel
//{
//
//    _tixianDataModel = tixianDataModel;
//    self.name_label.text = @"账户提现";
//    int status = [_tixianDataModel.state intValue];
//    switch (status) {
//        case 0:
//            self.stauts_label.text = @"待审核";
//            self.stauts_label.textColor = MacoColor;
//            break;
//        case 1:
//            self.stauts_label.text = @"审核通过";
//            self.stauts_label.textColor = MacoColor;
//            break;
//        case 2:
//            self.stauts_label.text = @"提现中";
//            self.stauts_label.textColor = MacoColor;
//            break;
//        case 3:
////            self.stauts_label.text = @"提现成功";
//            self.stauts_label.text = [NSString stringWithFormat:@"+%.2f",[_tixianDataModel.withdrawAmout floatValue]];
//            self.stauts_label.textColor = MacoColor;
//            break;
//        case 4:
//            self.stauts_label.text = @"提现失败";
//            self.stauts_label.textColor = MacoDetailColor;
//
//            break;
//        default:
//            break;
//    }
//    
//    self.detail_label.text = [NSString stringWithFormat:@"%@\n提现%.2f元",_tixianDataModel.successTime,[_tixianDataModel.withdrawAmout floatValue]];
//}

- (void)setInviteDataModel:(InnitationModel *)inviteDataModel
{
    _inviteDataModel = inviteDataModel;
    self.name_label.text = _inviteDataModel.mchName;
    self.stauts_label.text = [NSString stringWithFormat:@"+%.2f",[_inviteDataModel.tranAmount floatValue]];
    self.time_label.text = _inviteDataModel.tranTime;
   
    
}


@end
