//
//  ChooseTypeTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/28.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Watch;


@interface ChooseTypeTableViewCell : BaseTableViewCell

@property (nonatomic, strong)Watch *dataModel;


@property (nonatomic, strong)UILabel *yetSelectLabel;

@property (weak, nonatomic) IBOutlet UIView *goodsView;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@property (weak, nonatomic) IBOutlet UILabel *kuaidi;

@property (weak, nonatomic) IBOutlet UIButton *deletBtn;

- (IBAction)deletBtn:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberViewTap;

@property (weak, nonatomic) IBOutlet UIView *numberView;

@property (weak, nonatomic) IBOutlet UITextField *numberTF;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

- (IBAction)addBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
- (IBAction)minusBtn:(UIButton *)sender;

@property (nonatomic, strong)NSArray *guigeArray;

@end
