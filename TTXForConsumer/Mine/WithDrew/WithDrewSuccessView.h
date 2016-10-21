//
//  WithDrewSuccessView.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/9.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoView.h"

@interface WithDrewSuccessView : UIView


@property (weak, nonatomic) IBOutlet MoView *succesView;

@property (weak, nonatomic) IBOutlet UILabel *tixianLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *money;



@property (weak, nonatomic) IBOutlet UILabel *time;


@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (weak, nonatomic) IBOutlet UIView *itemsView;

@property (weak, nonatomic) IBOutlet UILabel *alerLabel;

@property (weak, nonatomic) IBOutlet UILabel *alertimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgimageView;

@property (nonatomic, strong)NSDictionary *infoDic;
- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)buttonAction;


@end
