//
//  GoodsMoreIntroduceView.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "GoodsMoreIntroduceView.h"
#import "MchAllCommentViewController.h"
#import "Watch.h"

@implementation GoodsMoreIntroduceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"GoodsMoreIntroduceView" owner:nil options:nil][0];

    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.backgroundColor = [UIColor whiteColor];
    self.comment.textColor = MacoDetailColor;
    self.sales.textColor = MacoDetailColor;
    self.kucun.textColor = MacoDetailColor;
}


- (void)setDataModel:(Watch *)dataModel
{
 
    _dataModel = dataModel;
    if (_dataModel.inventoryFlag) {
        self.kucun.text = @"库存：有货";
    }else{
        self.kucun.text = @"库存：无货";
    }
    self.sales.text = [NSString stringWithFormat:@"销量：%@笔",_dataModel.salenum];
    self.comment.text = [NSString stringWithFormat:@"累积评论（%@）",_dataModel.totalCommentCount];
}
- (IBAction)checkAllComment:(UIButton *)sender {
    
    MchAllCommentViewController *commentVC = [[MchAllCommentViewController alloc]init];
    commentVC.mchId = self.dataModel.mch_id;
    [self.viewController.navigationController pushViewController:commentVC animated:YES];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




@end
