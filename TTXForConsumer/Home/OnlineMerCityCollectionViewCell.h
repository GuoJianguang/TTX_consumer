//
//  OnlineMerCityCollectionViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 16/10/18.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VenceDataModel : BaseModel

@property (nonatomic, strong)NSString *venceId;
@property (nonatomic, strong)NSString *name;

@property (nonatomic, strong)NSString *pic;


@end

@interface OnlineMerCityCollectionViewCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *venceImage;

@property (nonatomic, strong)VenceDataModel *dataModel;

@end
