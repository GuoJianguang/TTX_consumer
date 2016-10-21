//
//  AboutUsTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)backBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
- (IBAction)companyWebsite:(UIButton *)sender;

- (IBAction)callBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *guanwangLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *weichantLabel;

@property (weak, nonatomic) IBOutlet UILabel *aboutUsLabel;

@end
