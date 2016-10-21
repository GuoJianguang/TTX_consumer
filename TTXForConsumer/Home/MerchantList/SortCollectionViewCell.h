//
//  SortCollectionViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/20.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantSort : BaseModel
@property (nonatomic,copy)NSString *sortId;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic, copy)NSString *sortName;


@property (nonatomic, assign)BOOL isShowRedPoint;

@property (nonatomic, assign)BOOL isSelect;

@end


@interface GoodsSort : BaseModel

/**
 * 类别id
 */

@property (nonatomic, copy)NSString *sortId;
/**
 * 类别名称
 */
@property (nonatomic, copy)NSString *name;
/*
 图标
 */
@property (nonatomic, copy)NSString *icon;
/*

 类别图片
 */

@property (nonatomic, copy)NSString *pic;
@property (nonatomic, assign)BOOL isSelect;


@end


@interface SortCollectionViewCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *sortLabel;

@property (nonatomic, strong)GoodsSort *goodsModel;

@property (weak, nonatomic) IBOutlet UIView *markView;


@property (nonatomic,strong)MerchantSort *dataModel;

@property (weak, nonatomic) IBOutlet UIView *pointView;


@end
