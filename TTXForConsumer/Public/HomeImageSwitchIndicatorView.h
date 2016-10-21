//
//  HomeImageSwitchIndicatorView.h
//  Tourguide
//
//  Created by test on 15/3/8.
//  Copyright (c) 2015年 inphase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeImageSwitchIndicatorView : UIView


@property (nonatomic,strong) UIColor *indicatorColor;
@property (nonatomic,assign) NSUInteger indicatorCounts;

@property (nonatomic,assign) CGFloat indicatorHeight;


@property (nonatomic,assign) NSUInteger currentIndicatorIndex;


@end
