//
//  GoodsMoreIntroduceView.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  Watch;

@interface GoodsMoreIntroduceView : UIView

@property (weak, nonatomic) IBOutlet UILabel *comment;


@property (weak, nonatomic) IBOutlet UILabel *sales;
@property (weak, nonatomic) IBOutlet UILabel *kucun;

@property (nonatomic, strong)Watch *dataModel;

- (IBAction)checkAllComment:(UIButton *)sender;



@end
