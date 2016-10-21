//
//  ChooseTypeView.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/28.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Watch;

@interface ChooseTypeView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

- (IBAction)buyBtn:(UIButton *)sender;

@property (nonatomic, strong)Watch *dataModel;

@property (weak, nonatomic) IBOutlet UIView *backView;


@end
