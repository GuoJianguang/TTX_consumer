//
//  GoodsDetailNewViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/8.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"
#import "ChooseTypeView.h"


@interface GoodsDetailNewViewController : BaseViewController

@property (nonatomic, strong)UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (nonatomic, strong)ChooseTypeView *choosetypeView;

- (IBAction)buyBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *buyBtnView;

@property (nonatomic, strong)NSString *goodsID;

- (void)setOrderViewSureBtn:(BOOL)isCanBuy;
@end
