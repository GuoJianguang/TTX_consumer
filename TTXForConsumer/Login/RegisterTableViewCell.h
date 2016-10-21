//
//  RegisterTableViewCell.h
//  tiantianxin
//
//  Created by ttx on 16/5/30.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *graphBtn;

- (IBAction)graphBtn:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UITextField *graphCodeTF;



@property (weak, nonatomic) IBOutlet UIView *phone_num_view;

@property (weak, nonatomic) IBOutlet UITextField *phone_num_tf;

@property (weak, nonatomic) IBOutlet UIView *verifiCode_view;

@property (weak, nonatomic) IBOutlet UITextField *verifi_tf;


@property (weak, nonatomic) IBOutlet UIButton *verifi_btn;

- (IBAction)verifi_btn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *password_view;

@property (weak, nonatomic) IBOutlet UITextField *password_tf;

@property (weak, nonatomic) IBOutlet UIView *surePassword_view;

@property (weak, nonatomic) IBOutlet UITextField *surePassword_tf;

- (IBAction)login_btn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;

@end
