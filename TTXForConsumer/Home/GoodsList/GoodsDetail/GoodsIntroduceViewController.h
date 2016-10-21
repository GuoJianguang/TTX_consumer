//
//  GoodsIntroduceViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"

@class Watch;

@interface GoodsIntroduceViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)Watch *dataModel;

- (void)drawDetailImage:(NSArray *)heightArray andImagArray:(NSArray *)imageArray andHeight:(CGFloat)totalHeight;

@property (weak, nonatomic) IBOutlet UIView *redview;


@end
