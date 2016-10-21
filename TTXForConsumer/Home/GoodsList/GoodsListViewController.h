//
//  GoodsListViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/21.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface GoodsListViewController : BaseViewController

- (IBAction)saleBtn:(UIButton *)sender;


- (IBAction)priceBtn:(UIButton *)sender;

- (IBAction)defaultBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *sortCollectionView;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIButton *defaltBtn;

@property (weak, nonatomic) IBOutlet UIButton *saleBtn;


@property (weak, nonatomic) IBOutlet UIButton *priceBtn;

@property (weak, nonatomic) IBOutlet UIImageView *priceImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
