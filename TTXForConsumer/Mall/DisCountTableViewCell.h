//
//  DisCountTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/28.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Watch;

@interface DisCountTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (weak, nonatomic) IBOutlet UILabel *discountPrice;

@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *yetLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *butBtn;
- (IBAction)buyBtn:(id)sender;


@property (nonatomic, strong)Watch *dataModel;

@end
