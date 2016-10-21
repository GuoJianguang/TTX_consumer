//
//  LogisticsViewController.h
//  tiantianxin
//
//  Created by ttx on 16/4/18.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"
@class MallOrderModel;

@interface LogisticsViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)MallOrderModel *dataModel;


@end
