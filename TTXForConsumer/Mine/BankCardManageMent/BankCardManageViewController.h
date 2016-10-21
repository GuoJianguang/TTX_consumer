//
//  BankCardManageViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/22.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface BankCardManageViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, assign)BOOL isYetBingdingCard;

@property (nonatomic, strong)NSDictionary *bankcardInfo;

//是否实名认证
@property (nonatomic, assign)BOOL isYetRealnameAuthentication;
@property (nonatomic, strong)NSDictionary *realnameAuDic;


@end
