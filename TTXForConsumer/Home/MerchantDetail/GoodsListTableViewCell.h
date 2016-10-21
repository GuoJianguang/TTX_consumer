//
//  GoodsListTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/20.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GoodsListModel : BaseModel
@property (nonatomic, copy)NSString *coverImage;
@property (nonatomic, copy)NSString *goodsId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *salenum;
@property (nonatomic, copy)NSString *price;

@end

@interface GoodsListTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (weak, nonatomic) IBOutlet UILabel *salenum;

@property (weak, nonatomic) IBOutlet UILabel *price;


@property(nonatomic, strong)GoodsListModel *dataModel;
@end
