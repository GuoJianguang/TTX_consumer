//
//  ImageViewer.h
//  Tourguide
//
//  Created by inphase on 15/7/1.
//  Copyright (c) 2015年 inphase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageViewer : NSObject

+(ImageViewer*) sharedImageViewer;

@property (nonatomic, strong)UIViewController *controller;
@property (nonatomic, strong)NSMutableArray *imagearay;
@property (nonatomic, assign)NSInteger temp;

- (void)showImageViewer:(NSMutableArray *)array withIndex:(NSInteger)index andView:(UIView *)view;
@end
