//
//  ShippingAddressViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface ShippingAddressViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;

//地址的列表请求
- (void)addressRequest;

@end
