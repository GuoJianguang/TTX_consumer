//
//  OrderTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MallOrderModel;

@interface OrderTableViewCell : BaseTableViewCell


@property (nonatomic, strong)MallOrderModel *dataModel;

#pragma mark - 订单类型
@property (weak, nonatomic) IBOutlet UIImageView *orderTypeImage;

@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


#pragma mark - 订单详情

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *storeName;

@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

- (IBAction)actionBtn:(UIButton *)sender;

#pragma mark - 进度标识
@property (weak, nonatomic) IBOutlet UIImageView *progressImage;

@property (weak, nonatomic) IBOutlet UIButton *checkLogistics;

- (IBAction)checkLogistics:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;


@end
