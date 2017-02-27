//
//  FlagshipCollectionViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/23.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FlagShipDataModel : BaseModel

@property (nonatomic, strong)NSString *flagShipId;

@property (nonatomic, strong)NSString *name;
/**
 * 跳转方式（1：APP商户详情 2：APP产品详情 3：网页）
 */
@property (nonatomic, strong)NSString *jumpWay;
/**
 * 跳转参数值
 */
@property (nonatomic, strong)NSString *jumpValue;

@property (nonatomic, strong)NSString *pic;


@end

@interface FlagshipCollectionViewCell : BaseCollectionViewCell


@property (nonatomic, strong)FlagShipDataModel *dataModel;
@property (weak, nonatomic) IBOutlet UILabel *shipName;

@property (weak, nonatomic) IBOutlet UIImageView *shipImageView;




@end
