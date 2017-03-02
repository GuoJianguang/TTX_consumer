//
//  PrivateCustomCollectionViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/24.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "PrivateCustomCollectionViewCell.h"

@implementation PrivateCustomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.privateCustomName.textColor = MacoTitleColor;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.privateCustomImageView.layer.masksToBounds = YES;
    
    self.privateCustomImageView.layer.cornerRadius = 3;
    
}


- (void)setDataModel:(SecondACtivityModel *)dataModel
{
    _dataModel = dataModel;
    [self.privateCustomImageView sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImg] placeholderImage:LoadingErrorImage];
    self.privateCustomName.text = _dataModel.name;
    
}

@end
