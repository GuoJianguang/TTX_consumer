//
//  GoodsDetailView.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsDetailView.h"

@implementation GoodsDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"GoodsDetailView" owner:nil options:nil][0];
    }
    return self;
}



@end
