//
//  RevisePasswordViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface RevisePasswordViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UIView *oldPassword_view;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword_tf;

@property (weak, nonatomic) IBOutlet UIView *password_view;
@property (weak, nonatomic) IBOutlet UITextField *pasword_tf;
@property (weak, nonatomic) IBOutlet UIView *surePassword_view;


@property (weak, nonatomic) IBOutlet UITextField *surePassword_tf;

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;

@end
