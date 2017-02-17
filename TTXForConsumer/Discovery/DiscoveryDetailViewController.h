//
//  DiscoveryDetailViewController.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/17.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "BaseViewController.h"
#import "DiscoveryHomeTableViewCell.h"

@interface DiscoveryDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)DiscoverHome *model;

@end
