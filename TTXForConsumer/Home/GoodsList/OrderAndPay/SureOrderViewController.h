//
//  SureOrderViewController.h
//  tiantianxin
//
//  Created by ttx on 16/4/5.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@class Watch;

@interface SureOrderViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong)Watch *mch_model;

@property (nonatomic, strong)NSDictionary *goosPramsDic;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
- (IBAction)sureBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end
