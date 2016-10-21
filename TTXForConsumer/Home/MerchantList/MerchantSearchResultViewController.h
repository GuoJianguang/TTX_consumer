//
//  MerchantSearchResultViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface MerchantSearchResultViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//当前城市
@property (nonatomic, strong)NSString *currentCity;
//关键字
@property (nonatomic, strong)NSString *keyWord;
//当前选择行业
@property (nonatomic, strong)NSString *currentIndustry;

//首页活动id
@property (nonatomic, strong)NSString *seqId;


@end
