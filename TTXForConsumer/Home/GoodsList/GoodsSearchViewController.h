//
//  GoodsSearchViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@interface GoodsSearchViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)backBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITextField *serchTF;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign)BOOL isSerach;

@end
