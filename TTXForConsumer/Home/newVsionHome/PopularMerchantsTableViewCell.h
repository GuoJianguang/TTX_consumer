//
//  PopularMerchantsTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/14.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PopularMerModel : BaseModel

@property (nonatomic, copy)NSString *aviableBalance;
//商户号
@property (nonatomic, copy)NSString *mchCode;
//商户名
@property (nonatomic, copy)NSString *mchName;
//封面图
@property (nonatomic, copy)NSString *pic;


@end

@interface PopularMerchantsTableViewCell : BaseTableViewCell


@property (nonatomic, assign)BOOL isAlreadyRefrefsh;


@property (weak, nonatomic) IBOutlet UILabel *popularLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageview1st;

@property (weak, nonatomic) IBOutlet UIButton *button1st;
- (IBAction)button1stAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label1st;


@property (weak, nonatomic) IBOutlet UIButton *button2st;
- (IBAction)button2stAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label2st;


@property (weak, nonatomic) IBOutlet UIButton *button3st;
- (IBAction)button3stAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label3st;
@property (weak, nonatomic) IBOutlet UILabel *goodMLabel;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *shirenLabel;


@property (nonatomic, strong)NSMutableArray *privteDataSouceArray;


@property (nonatomic, strong)NSMutableArray *dataSouceArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (weak, nonatomic) IBOutlet UIView *personalView;



@end
