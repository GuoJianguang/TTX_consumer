//
//  DiscoveryViewController.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/16.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface DiscoveryViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)firstBtn:(id)sender;


- (IBAction)secondBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;

@property (weak, nonatomic) IBOutlet TTXPageContrl *pageContrlView;

@end
