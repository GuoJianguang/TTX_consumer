//
//  IndustryCollectionViewCell.h
//  天添薪
//
//  Created by ttx on 16/1/7.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortCollectionViewCell.h"



@interface SortModel : BaseModel
@property (nonatomic,copy)NSString *sortId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *icon;


@end

@interface IndustryCollectionViewCell : UICollectionViewCell


//返回重用标示
+ (NSString *)indentify;
//创建xib中的cell
+ (UINib *)newCell;


@property (weak, nonatomic) IBOutlet UIView *item_view;

@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UIImageView *industry_image;

@property (nonatomic, strong)SortModel *dataModel;

@property (nonatomic, strong)GoodsSort *goodsSortModel;



@end
