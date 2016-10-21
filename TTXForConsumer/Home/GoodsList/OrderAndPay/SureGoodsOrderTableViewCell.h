//
//  SureOrderTableViewCell.h
//  tiantianxin
//
//  Created by ttx on 16/4/5.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallShippingALTableViewCell.h"

@class Watch;


@protocol SureOrderDelegate <NSObject>

- (void)selectGoodsAndSurePrice:(CGFloat )totalPrice;

@end


@interface SureGoodsOrderTableViewCell : BaseTableViewCell

//下单详情
@property (nonatomic, strong)Watch *dataModel;
//选择详情
@property (nonatomic, strong)NSDictionary *selectDetailDic;


@property (nonatomic, assign)id<SureOrderDelegate> delegate;


@property (weak, nonatomic) IBOutlet UILabel *shippingPerson;

- (IBAction)selectShippingBtn:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *shippingView;


@property (weak, nonatomic) IBOutlet UIView *detailView;


@property (weak, nonatomic) IBOutlet UILabel *mchInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;


@property (weak, nonatomic) IBOutlet UIImageView *mchImage;

@property (weak, nonatomic) IBOutlet UILabel *mchName;
@property (weak, nonatomic) IBOutlet UILabel *alerAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *buyNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

- (IBAction)addBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;

- (IBAction)minusBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;

@property (weak, nonatomic) IBOutlet UILabel *showAddressLabel;


@property (weak, nonatomic) IBOutlet UILabel *peisongLabel;

@property (weak, nonatomic) IBOutlet UILabel *kuaidiLabel;
@property (weak, nonatomic) IBOutlet UILabel *maijialiuyanLabel;
@property (weak, nonatomic) IBOutlet UITextField *liuyanTF;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *balancePayLabel;

@property (weak, nonatomic) IBOutlet UILabel *wexinPayLabel;

@property (weak, nonatomic) IBOutlet UIButton *balancePayBtn;

- (IBAction)balancePayBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *wexinPayBtn;

- (IBAction)wexinPayBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *payView;


//收货地址的model
@property (nonatomic, strong)MallShippingAddressModel *addressModel;

@property (weak, nonatomic) IBOutlet UIImageView *yueImage;

@property (weak, nonatomic) IBOutlet UIImageView *wechatImage;


@end
