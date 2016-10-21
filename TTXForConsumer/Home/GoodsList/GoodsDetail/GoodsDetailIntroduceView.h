//
//  GoodsDetailView.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Watch;
@interface GoodsDetailIntroduceView : UIView

@property (weak, nonatomic) IBOutlet UILabel *mchName;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *kuaidi;

@property (nonatomic, strong)Watch *dataModel;
@property (weak, nonatomic) IBOutlet UIButton *checkStoreBtn;

- (IBAction)checkStoreBtn:(UIButton *)sender;


@end
