//
//  IndustryCollectionViewCell.h
//  天添薪
//
//  Created by ttx on 16/1/7.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortCollectionViewCell.h"



@interface NewSortModel : BaseModel
@property (nonatomic,copy)NSString *sortId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *icon;


@end

@interface NewIndustryCollectionViewCell : BaseCollectionViewCell





@property (weak, nonatomic) IBOutlet UIView *item_view;

@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UIImageView *industry_image;

@property (nonatomic, strong)NewSortModel *dataModel;

@property (nonatomic, strong)GoodsSort *goodsSortModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagWidth;


@end
