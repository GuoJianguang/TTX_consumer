//
//  GoodsIndustryTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/23.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "GoodsIndustryTableViewCell.h"
#import "SquaredUpView.h"
#import "CustomButton.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation GoodsIndrstryModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    GoodsIndrstryModel *model = [[ GoodsIndrstryModel alloc]init];
    model.sortId = NullToSpace(dic[@"id"]);
    model.name = NullToSpace(dic[@"name"]);
    model.icon = NullToSpace(dic[@"icon"]);
    
    model.icon = [model.icon stringByReplacingOccurrencesOfString:@"," withString:@" "];
    /*处理空格*/
    
    NSCharacterSet *characterSet2 = [NSCharacterSet whitespaceCharacterSet];
    
    // 将string1按characterSet1中的元素分割成数组
    NSArray *array2 = [model.icon componentsSeparatedByCharactersInSet:characterSet2];
    
    model.icon = array2[0];
    return model;
}

@end

@interface GoodsIndustryTableViewCell()<SquaredUpViewDelegate>

@end

@implementation GoodsIndustryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    // Initialization code
    
    [self getGoodsTypeRequest];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initSquaredUpView:(NSMutableArray *)datasouceArray {
    SquaredUpView *squaredUpView = [[SquaredUpView alloc] init];
    squaredUpView.squaredUpViewDelegate = self;
    [self.contentView addSubview:squaredUpView];
    CGRect squaredeUpViewFrame = [squaredUpView layoutSquaredUpViewCellsFrameWithModelArray:datasouceArray];
    squaredUpView.frame = CGRectMake(0, 0, CGRectGetWidth(squaredeUpViewFrame), CGRectGetHeight(squaredeUpViewFrame));
    [squaredUpView.squaredUpViewCellArray enumerateObjectsUsingBlock:^(CustomButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        GoodsIndrstryModel *model = datasouceArray[idx];
        [button setTitle:model.name forState:UIControlStateNormal];
        [button sd_setImageWithURL:[NSURL URLWithString:model.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_list_default"]];
    }];
}

- (void)jSquaredUpViewCell:(CustomButton *)cell didSelectedAtIndex:(NSInteger)index
{
  
}

- (NSMutableArray *)sortDataSouceArray
{
    if (!_sortDataSouceArray) {
        _sortDataSouceArray = [NSMutableArray array];
    }
    return _sortDataSouceArray;
}

//获取所有商品类型
- (void)getGoodsTypeRequest
{
    [HttpClient GET:@"shop/goodsType/get" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self.sortDataSouceArray removeAllObjects];
            NSArray *array = jsonObject[@"data"];
            for (NSDictionary *dic in array) {
                GoodsIndrstryModel *model = [GoodsIndrstryModel modelWithDic:dic];
                [self.sortDataSouceArray addObject:model];
            }
            [self initSquaredUpView:self.sortDataSouceArray];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}


@end
