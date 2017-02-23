//
//  GoodsIndustryTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/23.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GoodsIndrstryModel : BaseModel
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

@end

@interface GoodsIndustryTableViewCell : BaseTableViewCell


@property (nonatomic, strong)NSMutableArray *sortDataSouceArray;

@end
