//
//  OrderTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "MallOrderModel.h"
#import "OderListViewController.h"
#import "OrderCommentViewController.h"
#import "LogisticsViewController.h"



@interface OrderTableViewCell()<UIAlertViewDelegate>

@end
@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.checkLogistics setTitleColor:MacoDetailColor forState:UIControlStateNormal];
    self.orderTypeLabel.textColor = MacoDetailColor;
    self.storeName.textColor = MacoTitleColor;
    self.orderStatus.textColor = MacoDetailColor;
    self.timeLabel.textColor = MacoIntrodouceColor;
    [self.actionBtn setBackgroundColor:MacoColor];
    self.goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImage.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



- (void)setDataModel:(MallOrderModel *)dataModel
{
    _dataModel = dataModel;
    NSURL *picnUrl = [NSURL URLWithString:_dataModel.pic];
    [self.goodsImage sd_setImageWithURL:picnUrl placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
    self.moneyLabel.text = [NSString stringWithFormat:@"-￥%.2f",[_dataModel.tranAmount doubleValue]];
    if (![_dataModel.freight isEqualToString:@"0"]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"-￥%.2f(含运费￥%.2f)",[_dataModel.tranAmount doubleValue],[_dataModel.freight doubleValue]];
    }
    self.actionBtn.layer.cornerRadius = 6;
    self.actionBtn.layer.masksToBounds = YES;
    self.actionBtn.layer.borderWidth = 1;
    self.actionBtn.layer.borderColor = MacoColor.CGColor;
    switch ([_dataModel.status integerValue]) {
        case 1:
            self.orderStatus.text = @"未发货";
            [self.actionBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
            self.actionBtn.hidden = YES;
            self.actionBtn.backgroundColor = [UIColor whiteColor];
            [self.actionBtn setTitleColor:MacoColor forState:UIControlStateNormal];
            self.checkLogistics.hidden = YES;
            self.checkImage.hidden = YES;

            break;
        case 2:
            self.orderStatus.text = @"已发货";
            [self.actionBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            self.actionBtn.backgroundColor = MacoColor;
            [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.checkLogistics.hidden = NO;
            self.checkImage.hidden = NO;
            break;
        case 3:
        {
            self.orderStatus.text = @"已确认收货";
            [self.actionBtn setTitle:@"去评价" forState:UIControlStateNormal];
            self.actionBtn.backgroundColor = MacoColor;
            [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.actionBtn.backgroundColor = MacoColor;
            self.checkLogistics.hidden = NO;
            self.checkImage.hidden = NO;
        }
            break;
        case 4:
            self.orderStatus.text = @"已付款";
            [self.actionBtn setTitle:@"去评价" forState:UIControlStateNormal];
            self.actionBtn.backgroundColor = MacoColor;
            [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.actionBtn.backgroundColor = MacoColor;
            self.checkLogistics.hidden = YES;
            self.checkImage.hidden = YES;
            break;
        case 5:
            self.orderStatus.text = @"已完成";
            self.actionBtn.hidden = YES;
            self.checkLogistics.hidden = NO;
            self.checkImage.hidden = NO;
            break;
        case 6:
            self.progressImage.hidden = NO;
            self.orderStatus.text = @"商家未打款";
            self.actionBtn.hidden = YES;
            self.checkLogistics.hidden = YES;
            self.checkImage.hidden = YES;
            break;
        case 7:
            self.progressImage.hidden = NO;
            self.orderStatus.text = @"退款中";
            self.actionBtn.hidden = YES;
            self.checkLogistics.hidden = YES;
            self.checkImage.hidden = YES;
            break;
        case 8:
            self.progressImage.hidden = NO;
            self.orderStatus.text = @"退款成功";
            self.actionBtn.hidden = YES;
            self.checkLogistics.hidden = YES;
            self.checkImage.hidden = YES;
            break;
        case 9:
            self.progressImage.hidden = NO;
            self.orderStatus.text = @"已支付";
            self.actionBtn.hidden = YES;
            self.checkLogistics.hidden = YES;
            self.checkImage.hidden = YES;
            break;
            
        default:
            break;
    }
    
    
    switch ([_dataModel.channel integerValue]) {
        case 1:
            self.orderTypeLabel.text = @"到店支付";
            self.storeName.text = _dataModel.mchName;
            self.orderTypeImage.image = [UIImage imageNamed:@"icon_mine_merchant_balance_payment"];
            self.checkLogistics.hidden = YES;
            self.checkImage.hidden = YES;
            break;
        case 2:
            self.orderTypeLabel.text = @"商城订单";
            self.orderTypeImage.image = [UIImage imageNamed:@"icon_mine_merchandise_balance_payment"];
            self.storeName.text = _dataModel.goodsName;
            break;
        case 3:
            self.orderTypeLabel.text = @"到店支付";
            self.orderTypeImage.image = [UIImage imageNamed:@"icon_mine_merchant_balance_payment"];
            self.storeName.text = _dataModel.mchName;
            self.checkLogistics.hidden = YES;
            self.checkImage.hidden = YES;
            break;
            
        default:
            break;
    }
    self.timeLabel.text = _dataModel.tranTime;
    
    NSInteger status =  [_dataModel.status integerValue];
    NSInteger channel = [_dataModel.channel integerValue];
    if (channel == 2) {
        if (status == 1 || status == 4) {
            self.progressImage.image = [UIImage imageNamed:@"icon_mine_not_yet_shipped"];
        }else if (status == 2){
            self.progressImage.image = [UIImage imageNamed:@"icon_mine_sent_out_goods"];
        }else if (status == 3){
            self.progressImage.image = [UIImage imageNamed:@"icon_mine_confirmed_receipt"];
        }else{
            self.progressImage.image = [UIImage imageNamed:@"icon_mine_off_the_stocks_mall"];
        }
    }else{
        if (status == 9 || status == 3 || status == 4) {
            self.progressImage.image = [UIImage imageNamed:@"icon_account_paid"];

        }else{
            self.progressImage.image = [UIImage imageNamed:@"icon_mine_off_the_stocks_seller"];

        }
    }
    
}


- (IBAction)actionBtn:(UIButton *)sender {
    switch ([_dataModel.status integerValue]) {
       case 3:
        {
            OrderCommentViewController *orderVC = [[OrderCommentViewController alloc]init];
            if ([_dataModel.channel integerValue] == 2) {
                orderVC.comment_type = Comment_type_goods;
            }else{
                orderVC.comment_type = Comment_type_merchant;
            }
            orderVC.dataModel = self.dataModel;
            [self.viewController.navigationController pushViewController:orderVC animated:YES];

            return;
        }
            break;
        case 4:
        {
            OrderCommentViewController *orderVC = [[OrderCommentViewController alloc]init];
            orderVC.comment_type = Comment_type_merchant;
            orderVC.dataModel = self.dataModel;
            [self.viewController.navigationController pushViewController:orderVC animated:YES];
            
            return;
        }
            break;
            
        default:
            break;
    }
    UIAlertView *showView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"是否确认收货？" delegate:self cancelButtonTitle:@"点错了" otherButtonTitles: @"确认",nil];
    [showView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *params = @{@"token":[TTXUserInfo shareUserInfos].token,
                                 @"orderId":self.dataModel.orderId};
        [HttpClient POST:@"shop/order/update" parameters:params success:^(NSURLSessionDataTask *operation, id jsonObject) {
            if (IsRequestTrue) {
                [[JAlertViewHelper shareAlterHelper]showTint:@"确认收货成功" duration:2.];
                [((OderListViewController *)self.viewController).tableView.mj_header beginRefreshing];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [[JAlertViewHelper shareAlterHelper]showTint:@"数据提交失败，请重试" duration:1.5];
        }];
    }
}

#pragma mark - 查看物流
- (IBAction)checkLogistics:(UIButton *)sender {
    if ([self.dataModel.logisticsNumber isEqualToString:@""]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"该订单无需物流" duration:2.];
        return;
    }
    LogisticsViewController *logisticsVC = [[LogisticsViewController alloc]init];
    logisticsVC.dataModel = self.dataModel;
    [self.viewController.navigationController pushViewController:logisticsVC animated:YES];
}

@end
