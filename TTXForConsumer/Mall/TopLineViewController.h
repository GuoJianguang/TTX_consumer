//
//  TopLineViewController.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/28.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface TopLineViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSouceArray;


@end
