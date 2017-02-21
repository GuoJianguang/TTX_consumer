//
//  MerchantProductListView.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/20.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantProductListView : UIView


@property (weak, nonatomic) IBOutlet UITableView *talbeView;

@property (weak, nonatomic) IBOutlet UILabel *gengduoLabel;

- (IBAction)moreBtn:(id)sender;


@property (nonatomic, strong)NSMutableArray *goodsArray;

@property (nonatomic, strong)NSString *mchCode;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *alerLabel;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageview;


@end
