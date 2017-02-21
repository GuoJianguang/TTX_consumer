//
//  MerchantCommentLIstVIew.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/21.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantCommentLIstVIew : UIView


@property (weak, nonatomic) IBOutlet UILabel *quanbulabel;


@property (nonatomic, strong)NSMutableArray *commentArray;

@property (nonatomic, strong)NSString *mchCode;
- (IBAction)checkAllComment:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *alerLabel;


@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end
