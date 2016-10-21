//
//  ShippingALTableViewCell.h
//  天添薪
//
//  Created by ttx on 16/1/8.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingAddressModel : BaseModel
//地址id
@property (nonatomic, copy)NSString *addressId;
//详细地址
@property (nonatomic, copy)NSString *addressDetail;
//收货人姓名
@property (nonatomic, copy)NSString *name;
//手机号
@property (nonatomic, copy)NSString *phone;
//地址
@property (nonatomic, copy)NSString *address;
//省
@property (nonatomic, copy)NSString *province;
//是否是默认收货地址
@property (nonatomic, copy)NSString *defaultFlag;
//邮政编码
@property (nonatomic, copy)NSString *zipCode;

@property (nonatomic, copy)NSString *city;

@property (nonatomic, copy)NSString *zone;

@property (nonatomic, copy)NSString *createTime;

@property (nonatomic, copy)NSString *modifyTime;

@property (nonatomic, copy)NSString *state;




@end

@interface ShippingALTableViewCell : UITableViewCell

//返回重用标示
+ (NSString *)indentify;
//创建xib中的cell
+ (id)newCell;

@property (weak, nonatomic) IBOutlet UIView *item_view;

@property (weak, nonatomic) IBOutlet UIButton *select_btn;

- (IBAction)select_btn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *shippingPerson;

@property (weak, nonatomic) IBOutlet UILabel *shippingAddress;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;


@property (weak, nonatomic) IBOutlet UILabel *editLabel;


@property (nonatomic, strong)ShippingAddressModel *dataModel;

@property (weak, nonatomic) IBOutlet UIView *lineView;


@end
