//
//  HelpTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpModel : BaseModel
@property (nonatomic, strong)NSString *question;
@property (nonatomic, strong)NSString *answer;

@end

@interface HelpTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *markImage;

@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;


@property (nonatomic, strong)HelpModel *dataModel;


@property (weak, nonatomic) IBOutlet UIView *fengeView;


@end
