//
//  MerchantListViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/20.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface MerchantListViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *sortCollectionView;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong)NSString *currentCity;

@property (nonatomic, strong)NSString *keyWord;


@end
