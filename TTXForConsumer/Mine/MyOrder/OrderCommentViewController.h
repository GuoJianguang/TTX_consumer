//
//  OrderCommentViewController.h
//  TTXForConsumer
//
//  Created by ttx on 16/7/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "BaseViewController.h"
#import "MallOrderModel.h"

typedef NS_ENUM(NSInteger,Comment_type){
    Comment_type_goods= 1,//商品
    Comment_type_merchant = 2,//商家
};


@interface OrderCommentViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *mchImage;

@property (weak, nonatomic) IBOutlet UILabel *mchName;

@property (weak, nonatomic) IBOutlet UILabel *detailStr;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *alerLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, assign)Comment_type comment_type;


@property (nonatomic, strong)MallOrderModel *dataModel;

@end
