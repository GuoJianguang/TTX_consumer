//
//  ScanPayViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/19.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"
#import "OnlinePayViewController.h"

@interface ScanPayViewController : BaseViewController

//商户号码
@property (weak, nonatomic) IBOutlet UILabel *mchInfo;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *yueImage;

@property (weak, nonatomic) IBOutlet UIImageView *wechatImage;
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;
@property (weak, nonatomic) IBOutlet UIButton *yueBtn;
- (IBAction)yueBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

- (IBAction)wechatBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtn:(UIButton *)sender;

@property (nonatomic, copy)NSString *mchCode;
@property (nonatomic, copy)NSString *mchName;
@property (nonatomic, copy)NSString *money;

//支付方式
@property (nonatomic, assign)Online_Payway_type payWay_type;

@end
