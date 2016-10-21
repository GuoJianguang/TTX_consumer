//
//  PayResultView.h
//  tiantianxin
//
//  Created by ttx on 16/4/5.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoView.h"



@interface PayResultView : UIView

@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (weak, nonatomic) IBOutlet UIView *itemsView;

@property (weak, nonatomic) IBOutlet UIView *resultView;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

- (IBAction)continueBtn:(UIButton *)sender;
- (IBAction)checkBtn:(UIButton *)sender;

@property (nonatomic, strong)MoView *anmintionView;

- (void)buttonActionsuccess;
- (void)buttonActionFail;

#pragma mark - 订单详情

//该订单的信息
@property (nonatomic, strong)NSDictionary *orderInfoDic;

@property (weak, nonatomic) IBOutlet UILabel *payWay;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *paytime;
@property (weak, nonatomic) IBOutlet UILabel *machantInfo;


@property (weak, nonatomic) IBOutlet UILabel *showpayWay;
@property (weak, nonatomic) IBOutlet UILabel *showmoney;
@property (weak, nonatomic) IBOutlet UILabel *showpaytime;
@property (weak, nonatomic) IBOutlet UILabel *showmachantInfo;


@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


@end
