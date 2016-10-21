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


@property (nonatomic, assign)PayType payType;

@property (nonatomic, strong)NSMutableDictionary *mallOrderParms;




@end
