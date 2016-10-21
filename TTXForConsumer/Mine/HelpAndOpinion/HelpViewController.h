//
//  HelpViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface HelpViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UITableView *taleView;

@property (weak, nonatomic) IBOutlet UIButton *opinionBtn;

- (IBAction)opinionBtn:(UIButton *)sender;

@end
