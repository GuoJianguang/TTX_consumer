//
//  TheWinningView.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheWinningView : UIView

@property (weak, nonatomic) IBOutlet UIView *itemView;


@property (weak, nonatomic) IBOutlet UIButton *deletBtn;

- (IBAction)deletBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *winningImage;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)checkBtn:(UIButton *)sender;


@end
