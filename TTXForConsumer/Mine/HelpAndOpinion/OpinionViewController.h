//
//  OpinionViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface OpinionViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *alerLabel;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commitBtn:(UIButton *)sender;

@end
