//
//  OnlinePayViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"
#import "BussessDetailModel.h"


typedef NS_ENUM(NSInteger,Online_Payway_type){
    Online_Payway_type_banlance = 1,//余额支付
    Online_Payway_type_wechat = 2,//微信支付

};

@interface OnlinePayViewController : BaseViewController

//商户号码
@property (nonatomic, strong)BussessDetailModel *dataModel;

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;

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

//支付方式
@property (nonatomic, assign)Online_Payway_type payWay_type;





@end
