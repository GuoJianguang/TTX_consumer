//
//  DisCoverYetTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/17.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoveryDeatailModel.h"


@interface DisCoverYetTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
- (IBAction)detailBtn:(id)sender;


@property (nonatomic, strong)DiscoveryDeatailModel *dataModel;


@end
