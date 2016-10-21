//
//  HomeBusinessListTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/16.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeBusinessList : BaseModel

@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *code;
@property (nonatomic, copy)NSString *desc;
//判断是否是优质商家
@property (nonatomic, copy)NSString *highQuality;
@property (nonatomic, copy)NSString *keyword;
@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *longitude;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *recommend;
@property (nonatomic, copy)NSArray *slidePic;
//行业
@property (nonatomic, copy)NSString *trade;

//判断是否是通过搜索出来的结果
@property (nonatomic, assign)BOOL isSearchResult;


@property (nonatomic, copy)NSString *distance;

@end

@interface HomeBusinessListTableViewCell : BaseTableViewCell


@property (nonatomic, strong)HomeBusinessList *dataModel;

@property (weak, nonatomic) IBOutlet UIImageView *bussessImage;

@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UILabel *detail_label;

@property (weak, nonatomic) IBOutlet UILabel *sort_label;

@property (weak, nonatomic) IBOutlet UIView *itemView;


@end
