//
//  NewHomeTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/13.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewHomeModel: BaseModel
/**
 * id
 */
@property (nonatomic, copy)NSString  *bannerId;
/**
 * 跳转方式（1：APP商户详情 2：APP产品详情 3：网页）
 */
@property (nonatomic, copy)NSString  *jumpWay;
/**
 * 跳转参数值
 */
@property (nonatomic, copy)NSString  *jumpValue;
/**
 * 图片
 */
@property (nonatomic, copy)NSString  *pic;

/*
 名称
 */
@property (nonatomic, copy)NSString  *name;

//是否有跳转
@property (nonatomic, assign)BOOL isJump;

@end


@interface NewHomeTableViewCell : BaseTableViewCell


//banner轮播
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
//轮播滚动
@property (weak, nonatomic) IBOutlet TTXPageContrl *pageView;

//不让每次都刷新
@property (nonatomic, assign)BOOL isAlreadyRefrefsh;

//banner的数据源
@property (nonatomic, strong)NSMutableArray *bannerArray;

@property (weak, nonatomic) IBOutlet UICollectionView *industryCollectionView;
//分类数据源
@property (nonatomic, strong)NSMutableArray *sortDataSouceArray;




@end
