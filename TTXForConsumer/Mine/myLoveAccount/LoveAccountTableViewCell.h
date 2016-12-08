//
//  LoveAccountTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 16/11/10.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoveAccountTableViewCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UITextView *explainTextView;

- (IBAction)backBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;


@property (nonatomic, strong)NSDictionary *dataModel;

- (IBAction)rechargeBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *loveAccountMoeny;


@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end
