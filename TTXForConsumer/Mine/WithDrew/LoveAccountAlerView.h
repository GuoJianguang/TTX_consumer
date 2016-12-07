//
//  LoveAccountAlerView.h
//  TTXForConsumer
//
//  Created by Guo on 16/12/7.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithDrewSuccessView.h"

@interface LoveAccountAlerView : UIView

@property (weak, nonatomic) IBOutlet UILabel *alerTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

- (IBAction)joinBtn:(UIButton *)sender;

- (IBAction)protcolBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)surebtn:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *joinLabel;

@property (weak, nonatomic) IBOutlet UIButton *protcolBtn;

@property (weak, nonatomic) IBOutlet UIView *itemView;


@property (nonatomic, strong)NSMutableDictionary *dataModelDic;


@property (nonatomic, strong)WithDrewSuccessView *successView;


@end
