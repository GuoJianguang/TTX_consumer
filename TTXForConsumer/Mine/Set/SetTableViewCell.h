//
//  SetTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/23.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTableViewCell : BaseTableViewCell


- (IBAction)editNickname:(UIButton *)sender;

- (IBAction)editPassword:(UIButton *)sender;

- (IBAction)editAddrdss:(UIButton *)sender;

- (IBAction)cleanCache:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;

- (IBAction)exitBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *shimingLabel;

@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *huanclabel;


@property (weak, nonatomic) IBOutlet UILabel *detailHuancLabel;



@end
