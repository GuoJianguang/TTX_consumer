//
//  MerchantSearchViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/1.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@protocol MerchantSearchViewDelegate <NSObject>

- (void)cancelSearch;

- (void)sureSearch:(NSString *)keyWord city:(NSString *)cityName;

@end


@interface MerchantSearchViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)backBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITextField *serchTF;

- (IBAction)selectCity:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *selectCityLabel;


@property (weak, nonatomic) IBOutlet UIView *cityView;

@property (nonatomic, assign)BOOL isSerach;

@property (nonatomic, assign)id<MerchantSearchViewDelegate> delegate;


@property (nonatomic, strong)NSString *selectCityname;


@end
