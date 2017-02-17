//
//  DiscoveryHomeTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/16.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DiscoverHome : BaseModel

@property (nonatomic, copy)NSString *discoverId;
@property (nonatomic, copy)NSString *jumpWay;
@property (nonatomic, copy)NSString *jumpValue;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *name;


@end

@interface DiscoveryHomeTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityImage;

@property (nonatomic, strong)DiscoverHome *dataModel;



@end
