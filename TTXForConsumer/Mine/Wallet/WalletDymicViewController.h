//
//  WalletDymicViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/23.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,WalletDymic_type){
    WalletDymic_type_yuE = 1,//余额
    WalletDymic_type_tuiJian = 2,//推荐收益
    WalletDymic_type_fanXian = 3,//每日让利回馈
    WalletDymic_type_Tixian = 4,//提现
};

@interface WalletDymicViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UICollectionView *sortCollectionView;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)WalletDymic_type walletType;



@end
