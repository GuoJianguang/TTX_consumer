//
//  ShippingALTableViewCell.m
//  天添薪
//
//  Created by ttx on 16/1/8.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MallShippingALTableViewCell.h"
#import "MallSelectShippingAddressViewController.h"

@implementation MallShippingAddressModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    MallShippingAddressModel *model = [[MallShippingAddressModel alloc]init];
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

@interface MallShippingALTableViewCell()<UIAlertViewDelegate>


@end

@implementation MallShippingALTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.item_view.layer.cornerRadius = 8;
    self.item_view.layer.masksToBounds = YES;
//    self.shippingAddress.adjustsFontSizeToFitWidth = YES;
    
    self.shippingAddress.textColor = MacoDetailColor;
    self.phoneLabel.textColor = MacoTitleColor;
    self.shippingPerson.textColor = MacoTitleColor;
    self.editLabel.textColor = MacoDetailColor;
    
    [self.select_btn setImage:[UIImage imageNamed:@"icon_default"] forState:UIControlStateSelected];
    [self.select_btn setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];

}


- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    self.editLabel.hidden = !_isEdit;
}

- (void)setDataModel:(MallShippingAddressModel *)dataModel
{
    _dataModel = dataModel;
    self.shippingPerson.text = _dataModel.name;
    self.shippingAddress.text = _dataModel.addressDetail;
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",_dataModel.phone];
    
    if ([_dataModel.defaultFlag isEqualToString:@"1"]) {
        self.select_btn.selected = YES;
    }else{
        self.select_btn.selected = NO;
    }
    
}


- (IBAction)select_btn:(UIButton *)sender {
    
    if (!sender.selected) {
      
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您确认要修改默认收货地址吗？" delegate:self cancelButtonTitle:@"不要了" otherButtonTitles:@"确认", nil];
        [alerView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [HttpClient POST:@"user/userInfo/address/update" parameters:@{@"id":self.dataModel.addressId,@"defaultFlag":@"1",@"token":[TTXUserInfo shareUserInfos].token,@"userId":[TTXUserInfo shareUserInfos].userid} success:^(AFHTTPRequestOperation *operation, id jsonObject) {
            if (IsRequestTrue) {
                [((MallSelectShippingAddressViewController *)self.viewController) addressRequest];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

@end
