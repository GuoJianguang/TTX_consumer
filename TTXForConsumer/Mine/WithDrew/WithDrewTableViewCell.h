//
//  WithDrewTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/22.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithDrewSuccessView.h"
#import "LoveAccountAlerView.h"


@interface WithDrewTableViewCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UIView *showMoneyView;

@property (nonatomic, strong)WithDrewSuccessView *successView;


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *withDrewMoenyView;
@property (weak, nonatomic) IBOutlet UITextField *editMoneyTF;

@property (weak, nonatomic) IBOutlet UIView *verCodeView;


@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
- (IBAction)sendCodeBtn:(UIButton *)sender;

- (IBAction)commitBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

- (IBAction)backBtn:(UIButton *)sender;

- (IBAction)tixianAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tixianLabel;

@property (weak, nonatomic) IBOutlet UILabel *alerLabel;

@property (weak, nonatomic) IBOutlet UILabel *alerGradeLabel;

@property (weak, nonatomic) IBOutlet UILabel *actualAmount;

@property (weak, nonatomic) IBOutlet UILabel *alerLabel1;

@property (nonatomic, strong)LoveAccountAlerView *loveAccountView;



@end
