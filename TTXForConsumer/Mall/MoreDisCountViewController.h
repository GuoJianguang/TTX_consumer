//
//  MoreDisCountViewController.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/28.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreDisCountViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//类型id
@property (nonatomic, strong)NSString *typeId;
//搜索的商品名称
@property (nonatomic, strong)NSString *searchName;



@end
