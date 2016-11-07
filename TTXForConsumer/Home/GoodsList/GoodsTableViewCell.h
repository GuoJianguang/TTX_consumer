//
//  GoodsListTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/21.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Watch;

@interface GoodsTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;

//邮费
@property (weak, nonatomic) IBOutlet UILabel *freight;
//销量
@property (weak, nonatomic) IBOutlet UILabel *salesVolume;
//价格
@property (weak, nonatomic) IBOutlet UILabel *price;

//回馈标记
@property (weak, nonatomic) IBOutlet UILabel *fanMark;
//推荐标记
@property (weak, nonatomic) IBOutlet UILabel *jianMark;

@property (weak, nonatomic) IBOutlet UIView *itemView;


@property (nonatomic, strong)Watch *dataModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jianWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fanLeading;



@end
