//
//  sharkResultView.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "SharkResultView.h"

@implementation SharkResultView

- (instancetype)init
{
    self =[super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SharkResultView" owner:nil options:nil][0];
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [self bringSubviewToFront:self.itemView];
    self.itemView.layer.cornerRadius = 3;
    self.itemView.layer.masksToBounds = YES;
    
    self.sureBtn.backgroundColor = MacoColor;
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    
}

- (IBAction)sureBtn:(UIButton *)sender {
    [self removeFromSuperview];
    
}
@end
