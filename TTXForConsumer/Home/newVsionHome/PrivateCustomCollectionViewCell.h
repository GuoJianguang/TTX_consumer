//
//  PrivateCustomCollectionViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/24.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondActivityTableViewCell.h"

@interface PrivateCustomCollectionViewCell : BaseCollectionViewCell


@property (nonatomic, strong)SecondACtivityModel *dataModel;

@property (weak, nonatomic) IBOutlet UIImageView *privateCustomImageView;

@property (weak, nonatomic) IBOutlet UILabel *privateCustomName;

@end
