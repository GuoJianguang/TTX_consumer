//
//  NewMerchantDetailTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/20.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussessDetailModel.h"
#import "SortButtonSwitchView.h"

@interface NewMerchantDetailTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;

@property (weak, nonatomic) IBOutlet TTXPageContrl *pageControl;


@property (weak, nonatomic) IBOutlet UILabel *mchantName;

@property(nonatomic, strong)BussessDetailModel *dataModel;

@property (weak, nonatomic) IBOutlet SortButtonSwitchView *sortView;


@property (weak, nonatomic) IBOutlet SwipeView *itemSwipeView;

@property (nonatomic, strong)NSMutableArray *goodsArray;



@end
