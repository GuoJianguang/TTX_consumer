//
//  AuthenticationSuccessView.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/29.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "AuthenticationSuccessView.h"
#import "BankCardManageViewController.h"


@interface AuthenticationSuccessView ()

@property (nonatomic, strong)MoView *anmintionView;

@end

@implementation AuthenticationSuccessView

- (void)awakeFromNib
{
    self.bingdingBtn.layer.cornerRadius = 5;
    self.bingdingBtn.layer.masksToBounds = YES;
    self.bingdingBtn.layer.borderWidth = 1;
    self.bingdingBtn.layer.borderColor = MacoColor.CGColor;
    [self.bingdingBtn setTitleColor:MacoColor forState:UIControlStateNormal];
    self.bingdingBtn.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = MacoGrayColor;
    self.alerLabel.textColor = MacoTitleColor;
    
    self.nameLabel.textColor = self.idCardNumLabel.textColor = MacoDetailColor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"AuthenticationSuccessView" owner:nil options:nil][0];
        self.anmintionView = [[MoView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.succesView addSubview:self.anmintionView];
        
        self.anmintionView.center = CGPointMake(CGRectGetWidth(self.succesView.frame)/2, CGRectGetHeight(self.succesView.frame)/2);
        self.anmintionView.backgroundColor = MacoColor;
        self.anmintionView.layer.cornerRadius = CGRectGetHeight(self.anmintionView.bounds)/2;
        self.anmintionView.layer.masksToBounds = YES;
//        [self buttonAction];
    }
    return self;
}
- (void)buttonAction
{
    if (self.anmintionView) {
        [self.anmintionView startLoading];
        
        [self.anmintionView success:^{
            if ([self.alerCode isEqualToString:@"0"]) {
                return ;
            }
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"重要提示" message:self.alerString preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //绑定银行卡
                BankCardManageViewController *bankcardVC = [[BankCardManageViewController alloc]init];
                bankcardVC.isYetRealnameAuthentication = YES;
                bankcardVC.realnameAuDic = self.infoDic;
                [self.viewController.navigationController pushViewController:bankcardVC animated:YES];
            }];
            [alertcontroller addAction:cancelAction];
            [alertcontroller addAction:otherAction];
            [self.viewController presentViewController:alertcontroller animated:YES completion:NULL];
        }];
    }
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    _infoDic = infoDic;
    self.nameLabel.text =[NSString stringWithFormat:@"姓名:%@",_infoDic[@"name"]];
    self.idCardNumLabel.text  =[NSString stringWithFormat:@"身份证号:%@", _infoDic[@"idcardnumber"]];
    if (self.idCardNumLabel.text.length == 23) {
        self.idCardNumLabel.text = [self.idCardNumLabel.text stringByReplacingCharactersInRange:NSMakeRange(6, 16) withString:@"****************"];
    }
}

#pragma mark - 去绑定银行卡
- (IBAction)bingdingBtn:(UIButton *)sender {
    BankCardManageViewController *bankcardVC = [[BankCardManageViewController alloc]init];
    bankcardVC.isYetRealnameAuthentication = YES;
    bankcardVC.realnameAuDic = self.infoDic;
    [self.viewController.navigationController pushViewController:bankcardVC animated:YES];
}
@end
