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

@end
