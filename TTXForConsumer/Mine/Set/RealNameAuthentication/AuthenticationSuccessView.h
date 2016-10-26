//
//  AuthenticationSuccessView.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/29.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoView.h"

@interface AuthenticationSuccessView : UIView

@property (weak, nonatomic) IBOutlet MoView *succesView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *idCardNumLabel;


@property (weak, nonatomic) IBOutlet UIButton *bingdingBtn;

- (IBAction)bingdingBtn:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (weak, nonatomic) IBOutlet UIView *itemsView;

@property (weak, nonatomic) IBOutlet UILabel *alerLabel;


@property (nonatomic, strong)NSDictionary *infoDic;


@property (nonatomic, strong)NSString *alerString;

@property (nonatomic, assign)NSString *alerCode;

- (void)buttonAction;



@end
