//
//  MerchantIntroduceView.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/20.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BussessDetailModel;

@interface MerchantIntroduceView : UIView

@property(nonatomic, strong)BussessDetailModel *dataModel;


@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
- (IBAction)phoneBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (weak, nonatomic) IBOutlet UILabel *address;

- (IBAction)address:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *jisaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIView *introdouceView;

@end
