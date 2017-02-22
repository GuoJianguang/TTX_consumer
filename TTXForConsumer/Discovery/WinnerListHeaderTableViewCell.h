//
//  WinnerListHeaderTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/22.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiscoveryDeatailModel;


@interface WinnerListHeaderTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (weak, nonatomic) IBOutlet UILabel *winnerNameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong)DiscoveryDeatailModel *dataModel;

@end
