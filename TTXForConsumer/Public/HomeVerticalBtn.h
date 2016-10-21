//
//  HomeVerticalBtn.h
//  天添薪
//
//  Created by ttx on 16/1/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVerticalBtn : UIView


@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) NSString *title;

@property (nonatomic, strong) UILabel *alerLabel;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, copy)NSString *alerTitle;
@property (nonatomic, assign)BOOL showAlerNumber ;
@property (nonatomic, assign)BOOL showAlerLabel;


@end
