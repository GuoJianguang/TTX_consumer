//
//  RealNameAutViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/29.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface RealNameAutViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UILabel *yetAutLabel;

@property (weak, nonatomic) IBOutlet UIView *nameView;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;


@property (weak, nonatomic) IBOutlet UIView *idCardNumView;

@property (weak, nonatomic) IBOutlet UITextField *idCardNumTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)sureBtn:(UIButton *)sender;

@property (nonatomic, assign)BOOL isYetAut;

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *alerLabel;

//手动认证
@property (weak, nonatomic) IBOutlet UIButton *ManualCerBtn;

- (IBAction)ManualCerBtn:(UIButton *)sender;





@end
