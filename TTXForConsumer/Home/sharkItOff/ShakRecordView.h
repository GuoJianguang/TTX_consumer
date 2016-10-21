//
//  ShakRecordView.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakRecordView : UIView

- (IBAction)deletBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *deletBtn;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *itemView;



@end
