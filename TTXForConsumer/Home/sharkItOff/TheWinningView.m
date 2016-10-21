//
//  TheWinningView.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "TheWinningView.h"

@implementation TheWinningView

- (instancetype)init
{
    self =[super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"TheWinningView" owner:nil options:nil][0];
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [self bringSubviewToFront:self.itemView];
    self.itemView.layer.cornerRadius = 3;
    self.itemView.layer.masksToBounds = YES;
    
    self.checkBtn.backgroundColor = MacoColor;
    self.checkBtn.layer.cornerRadius = 5;
    self.checkBtn.layer.masksToBounds = YES;
}

- (IBAction)deletBtn:(UIButton *)sender {
    [self removeFromSuperview];
}


- (IBAction)checkBtn:(UIButton *)sender {
    
    
}
@end
