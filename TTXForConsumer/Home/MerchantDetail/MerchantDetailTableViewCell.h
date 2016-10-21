//
//  MerchantDetailTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/17.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussessDetailModel.h"
#import "TTXPageContrl.h"

@interface MerchantDetailTableViewCell : BaseTableViewCell


@property(nonatomic, strong)BussessDetailModel *dataModel;

@property (nonatomic, strong)NSMutableArray *commentArray;

@property (nonatomic, strong)NSMutableArray *goodsArray;

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;

@property (weak, nonatomic) IBOutlet TTXPageContrl *pageControl;


//@property (weak, nonatomic) IBOutlet HomeImageSwitchIndicatorView *pageView;
@property (weak, nonatomic) IBOutlet UILabel *mchantName;
@property (weak, nonatomic) IBOutlet UIButton *onPayBtn;

- (IBAction)onlinePay:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
- (IBAction)phoneBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (weak, nonatomic) IBOutlet UILabel *address;

- (IBAction)address:(UIButton *)sender;

#pragma mark - 商家详细介绍

@property (weak, nonatomic) IBOutlet UIView *showIntroduceView;

@property (weak, nonatomic) IBOutlet UIButton *showAllIntroduce;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceHeight;
- (IBAction)showAllIntroduce:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;


#pragma mark - 代金券
@property (weak, nonatomic) IBOutlet UICollectionView *voucherCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *jisaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinglunLabel;
@property (weak, nonatomic) IBOutlet UILabel *gengduoLabel;

@property (weak, nonatomic) IBOutlet UILabel *quanbulabel;


@property (weak, nonatomic) IBOutlet UILabel *shangpingLabel;
#pragma mark - 商品列表
@property (weak, nonatomic) IBOutlet UITableView *goodsTableView;

#pragma mark - 评论列表
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewHeight;


- (IBAction)checkAllComment:(UIButton *)sender;


- (IBAction)checkAllgoodsBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *goodsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsViewHeight;

@end
