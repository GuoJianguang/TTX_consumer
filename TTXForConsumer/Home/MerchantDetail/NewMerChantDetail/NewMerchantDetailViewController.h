//
//  NewMerchantDetailViewController.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/20.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "BaseViewController.h"
@class BussessDetailModel;

@interface NewMerchantDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
- (IBAction)buyBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *buyBtnView;

@property (nonatomic, strong)BussessDetailModel *dataModel;


@property (nonatomic, copy)NSString *merchantCode;

@end
