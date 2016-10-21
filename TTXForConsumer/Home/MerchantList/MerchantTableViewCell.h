//
//  MerchantTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/20.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeBusinessList;


@interface MerchantTableViewCell : BaseTableViewCell

@property (nonatomic, strong)HomeBusinessList *dataModel;

@property (weak, nonatomic) IBOutlet UILabel *reLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bussessImage;

@property (weak, nonatomic) IBOutlet UILabel *kimter_label;
@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UILabel *detail_label;


@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (weak, nonatomic) IBOutlet UIImageView *kmiterImage;

@end
