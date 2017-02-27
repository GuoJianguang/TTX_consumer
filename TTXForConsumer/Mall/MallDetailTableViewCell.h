//
//  MallDetailTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/23.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountModel : BaseModel
@property (nonatomic, copy)NSString *disCountId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *pic;
/**
 * 跳转参数值
 */

@property (nonatomic, copy)NSString *jumpValue;
/**
 * 跳转方式（1：APP商户详情 2：APP产品详情 3：网页）
 */

@property (nonatomic, copy)NSString *jumpWay;


@end

@interface MallDetailTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong)NSMutableArray *flagShipArray;;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagShipHeight;


@property (nonatomic, strong)NSMutableArray *disCountArray;

@property (nonatomic, strong)NSMutableArray *topLineArray;

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet TTXPageContrl *pageView;

@property (weak, nonatomic) IBOutlet UILabel *topLineLabel;


- (IBAction)moreTopShip:(id)sender;




@end
