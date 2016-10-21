//
//  MerchantCommentListViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/30.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface MerchantCommentListViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;

//当前商家的code
@property (nonatomic, strong)NSString *code;

@end
