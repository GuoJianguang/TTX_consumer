//
//  DiscoveryPayView.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/20.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoveryPayView : UIView



@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (weak, nonatomic) IBOutlet UITextField *numberTF;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;

- (IBAction)addBtn:(UIButton *)sender;
- (IBAction)minusBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)sureBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *deletBtn;
- (IBAction)deletBtn:(id)sender;


@property (nonatomic, copy)NSString *detailId;


@end
