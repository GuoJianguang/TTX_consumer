//
//  GoodsDetailViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"
#import "ChooseTypeView.h"


@interface GoodsDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (nonatomic, strong)ChooseTypeView *choosetypeView;

- (IBAction)buyBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *buyBtnView;

@property (nonatomic, strong)NSString *goodsID;


@end
