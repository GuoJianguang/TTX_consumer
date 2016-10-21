//
//  LogisticsCompanyTableViewCell.h
//  tiantianxin
//
//  Created by ttx on 16/4/18.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MallOrderModel;



@interface LogisticsCompanyTableViewCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (weak, nonatomic) IBOutlet UIImageView *companyLogImage;


@property (weak, nonatomic) IBOutlet UILabel *logisticsCLabel;

@property (weak, nonatomic) IBOutlet UILabel *logistics;
@property (weak, nonatomic) IBOutlet UILabel *awbLabel;

@property (weak, nonatomic) IBOutlet UILabel *awbNum;

@property (nonatomic, strong)MallOrderModel *dataModel;


@end
