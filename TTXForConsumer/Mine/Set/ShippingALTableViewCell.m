//
//  ShippingALTableViewCell.m
//  天添薪
//
//  Created by ttx on 16/1/8.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "ShippingALTableViewCell.h"
#import "ShippingAddressViewController.h"

@implementation ShippingAddressModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    ShippingAddressModel *model = [[ShippingAddressModel alloc]init];
    model.addressId = NullToSpace(dic[@"id"]);
    model.addressDetail = NullToSpace(dic[@"addressDetail"]);
    model.name = NullToSpace(dic[@"name"]);
    model.phone = NullToSpace(dic[@"phone"]);
    model.address = NullToSpace(dic[@"address"]);
    model.province = NullToSpace(dic[@"province"]);
    model.defaultFlag = NullToSpace(dic[@"defaultFlag"]);
    model.zipCode = NullToSpace(dic[@"zipCode"]);
    model.city = NullToSpace(dic[@"city"]);
    model.zone = NullToSpace(dic[@"zone"]);
    model.createTime = NullToSpace(dic[@"createTime"]);
    model.modifyTime = NullToSpace(dic[@"modifyTime"]);
    
    return model;
}

@end

@interface ShippingALTableViewCell()<UIAlertViewDelegate>


@end

@implementation ShippingALTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.shippingAddress.textColor = MacoDetailColor;
    self.shippingPerson.textColor = MacoTitleColor;
    
    [self.select_btn setImage:[UIImage imageNamed:@"icon_default"] forState:UIControlStateSelected];
    [self.select_btn setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];


}

//返回重用标示
+ (NSString *)indentify
{
    return @"ShippingALTableViewCell";
}
//创建cell
+ (id)newCell
{
    NSArray *array  = [[NSBundle mainBundle]loadNibNamed:@"ShippingALTableViewCell" owner:nil options:nil];
    return array[0];
}


- (void)setDataModel:(ShippingAddressModel *)dataModel
{
    _dataModel = dataModel;
    self.shippingPerson.text = _dataModel.name;
    self.shippingAddress.text = _dataModel.addressDetail;
    if ([_dataModel.defaultFlag isEqualToString:@"1"]) {
        self.select_btn.selected = YES;
    }else{
        self.select_btn.selected = NO;
    }
}


- (IBAction)select_btn:(UIButton *)sender {
    
    if (!sender.selected) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您确认要修改默认收货地址吗？" delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"确认", nil];
        [alerView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [HttpClient POST:@"user/userInfo/address/update" parameters:@{@"id":self.dataModel.addressId,@"defaultFlag":@"1",@"token":[TTXUserInfo shareUserInfos].token,@"userId":[TTXUserInfo shareUserInfos].userid} success:^(NSURLSessionDataTask *operation, id jsonObject) {
            if (IsRequestTrue) {
                [((ShippingAddressViewController *)self.viewController) addressRequest];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
    }
}

@end
