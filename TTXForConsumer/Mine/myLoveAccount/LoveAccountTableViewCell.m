//
//  LoveAccountTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 16/11/10.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "LoveAccountTableViewCell.h"

@implementation LoveAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.explainTextView.text = @"账户说明：\nXCode工程目录里面,有时你会发现2个不同颜色的文件夹,一种是蓝色的,一种是黄色的,最常见的是黄色的,我也是最近学习html5的时候,发现还有蓝色的文件夹呢, 来上...";
    self.explainTextView.textColor = MacoTitleColor;
    self.explainTextView.editable = NO;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)backBtn:(id)sender {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}
@end
