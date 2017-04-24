//
//  PayView.h
//  天添薪
//
//  Created by ttx on 16/1/11.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoView.h"
#import "OrderModel.h"



typedef NS_ENUM(NSInteger,Payway_type){
    Payway_type_banlance = 1,//余额支付
    Payway_type_wechat = 2,//微信支付
    
};


typedef NS_ENUM(NSInteger,PayType){
    PayType_mallOrder= 1,//商城余额支付
    PayType_mineOder = 2,//我的订单支付
    PayType_OnlineMchantOrder = 3//商户在线支付
    
};

@protocol PayViewDelegate <NSObject>

- (void)paysuccess:(NSString *)payWay;
- (void)payfail;

@end

@interface PayView : UIView
@property (nonatomic, strong)OrderModel *dataModel;

@property (weak, nonatomic) IBOutlet UILabel *pleaseLael;


- (IBAction)cancel_btn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *password_view;
@property (weak, nonatomic) IBOutlet UITextField *password_tf;
- (IBAction)forgetBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *passorError;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *successView;

@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@property (nonatomic, strong)MoView *anmintionView;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)sureBtn:(UIButton *)sender;

@property (nonatomic, assign)id<PayViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *item_view;

//订单来源
@property (nonatomic, assign)PayType payType;

@property (nonatomic, strong)NSMutableDictionary *mallOrderParms;




#pragma mark - 选择支付方式

@property (weak, nonatomic) IBOutlet UIImageView *yueImage;

@property (weak, nonatomic) IBOutlet UIImageView *wechatImage;
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;
@property (weak, nonatomic) IBOutlet UIButton *yueBtn;
- (IBAction)yueBtn:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

- (IBAction)wechatBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *yuEActionBtn;
 

//余额或者微信支付
@property (nonatomic, assign)Payway_type payWay_type;



@property (nonatomic, assign)BOOL isHavieWechatPay;



@end
