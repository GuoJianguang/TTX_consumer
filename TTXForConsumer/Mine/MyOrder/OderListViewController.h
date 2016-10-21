//
//  OderListViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,Order_type){
    Order_type_all = 1,//全部
    Order_type_yetComplet = 2,//已完成
    Order_type_waitShipp = 3,//待收货
    Order_type_waitComment = 4,//待评价
};


@interface OderListViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *sortCollectionView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign)Order_type orderType;


@end
