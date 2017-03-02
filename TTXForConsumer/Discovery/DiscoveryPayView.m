//
//  DiscoveryPayView.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/20.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryPayView.h"
#import "DiscoveryDetailViewController.h"

@implementation DiscoveryPayView


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];

    self.backView.alpha = 0.8;
    self.numberTF.layer.borderWidth = 1;
    self.numberTF.layer.borderColor = MacoIntrodouceColor.CGColor;
    self.addBtn.layer.borderWidth = 1;
    [self.addBtn setTitleColor:MacoIntrodouceColor forState:UIControlStateNormal];
    self.addBtn.layer.borderColor = MacoIntrodouceColor.CGColor;
    self.minusBtn.layer.borderWidth = 1;
    self.minusBtn.layer.borderColor = [UIColor colorFromHexString:@"c8c8c8"].CGColor;
    [self.minusBtn setTitleColor:[UIColor colorFromHexString:@"c8c8c8"] forState:UIControlStateNormal];
    self.numberTF.textColor = MacoDetailColor;
    self.numberTF.text = @"1";
    
    self.itemLabel.textColor = MacoColor;
    self.buyNumberLabel.textColor = MacoTitleColor;
    
    self.sureBtn.backgroundColor = MacoColor;
    self.sureBtn.layer.cornerRadius = 20.;
    self.sureBtn.layer.masksToBounds = YES;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"DiscoveryPayView" owner:nil options:nil][0];
        [self sendSubviewToBack:self.backView];
        self.itemView.backgroundColor = [UIColor whiteColor];
        self.backView.backgroundColor = [UIColor colorFromHexString:@"#ccd8e2"];
        self.backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.backView addGestureRecognizer:tap];
    }
    
    return self;
}


- (IBAction)addBtn:(UIButton *)sender
{
    self.minusBtn.layer.borderColor = MacoIntrodouceColor.CGColor;
    [self.minusBtn setTitleColor:MacoIntrodouceColor forState:UIControlStateNormal];
    self.numberTF.text =[NSString stringWithFormat:@"%ld",[self.numberTF.text integerValue]+1];
}
- (IBAction)minusBtn:(UIButton *)sender
{
    if ([self.numberTF.text integerValue]== 2) {
        self.minusBtn.layer.borderColor = [UIColor colorFromHexString:@"c8c8c8"].CGColor;
        [self.minusBtn setTitleColor:[UIColor colorFromHexString:@"c8c8c8"] forState:UIControlStateNormal];
    }
    if ([self.numberTF.text integerValue] < 2 ) {
        return;
    }
    self.numberTF.text =[NSString stringWithFormat:@"%ld",[self.numberTF.text integerValue]-1];
    
}

#pragma mark - 确认抽奖
- (IBAction)sureBtn:(UIButton *)sender {
    
    if (![TTXUserInfo shareUserInfos].currentLogined) {
        //判断是否先登录
        UINavigationController *navc = [LoginViewController controller];
        [self.viewController presentViewController:navc animated:YES completion:NULL];
        return;
    }
    if ([self gotRealNameRu:@"请先进行实名认证"]) {
        return;
    }
    
    sender.enabled = NO;
    NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token,
                            @"id":NullToSpace(self.detailId),
                            @"num":NullToNumber(self.numberTF.text)};
    [HttpClient POST:@"find/draw/buy" parameters:prams success:^(NSURLSessionDataTask *operation, id jsonObject) {
        sender.enabled = YES;
        if (IsRequestTrue) {
            [[JAlertViewHelper shareAlterHelper]showTint:@"抽奖成功" duration:1.5];
            [self tap];
            [((DiscoveryDetailViewController *)self.viewController).tableView.mj_header beginRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"抽奖失败，请稍后重试" duration:1.5];
        sender.enabled = YES;

    }];
    

}



- (IBAction)deletBtn:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.itemView.frame = CGRectMake(0, THeight, TWitdh, TWitdh*(11/10.));
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


- (void)tap{
    [UIView animateWithDuration:0.5 animations:^{
        self.itemView.frame = CGRectMake(0, THeight, TWitdh, TWitdh*(11/10.));
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - 去进行实名认证
- (BOOL)gotRealNameRu:(NSString *)alerTitle
{
    if (![TTXUserInfo shareUserInfos].identityFlag) {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"重要提示" message:alerTitle preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //去进行实名认证
            RealNameAutViewController *realNVC = [[RealNameAutViewController alloc]init];
            realNVC.isYetAut = NO;
            [self.viewController.navigationController pushViewController:realNVC animated:YES];
        }];
        [alertcontroller addAction:cancelAction];
        [alertcontroller addAction:otherAction];
        [self.viewController presentViewController:alertcontroller animated:YES completion:NULL];
        return YES;
    }
    return NO;
}

@end
