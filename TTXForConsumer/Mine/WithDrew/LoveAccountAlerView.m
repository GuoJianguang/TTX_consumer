//
//  LoveAccountAlerView.m
//  TTXForConsumer
//
//  Created by Guo on 16/12/7.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "LoveAccountAlerView.h"

@implementation LoveAccountAlerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backView.backgroundColor = [UIColor colorWithRed:204/255. green:216/255. blue:226/255. alpha:0.8];
    self.backgroundColor = [UIColor clearColor];
    [self sendSubviewToBack:self.backView];
    self.alerTitleLabel.textColor = self.joinLabel.textColor =  MacoDetailColor;
    [self.protcolBtn setTitleColor:MacoDetailColor forState:UIControlStateNormal];
    self.sureBtn.layer.cornerRadius = 18.;
    self.sureBtn.layer.masksToBounds = YES;
    
    self.itemView.backgroundColor = [UIColor whiteColor];
    self.itemView.layer.cornerRadius = 5;
    self.itemView.layer.masksToBounds = YES;
    

}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"LoveAccountAlerView" owner:nil options:nil][0];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        self.backView.userInteractionEnabled = YES;
        [self.backView addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)tap{

    [self removeFromSuperview];
}


- (void)setDataModelDic:(NSMutableDictionary *)dataModelDic
{
    _dataModelDic = dataModelDic;
    self.alerTitleLabel.text  = NullToSpace(_dataModelDic[@"content"]);
}

- (IBAction)joinBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

- (IBAction)protcolBtn:(id)sender {
    BaseHtmlViewController *htmelVC = [[BaseHtmlViewController alloc]init];
    htmelVC.htmlTitle = @"账户协议";
    htmelVC.htmlUrl = [NSString stringWithFormat:@"%@%@",formal_html_base,@"loveNotice.html"];
    [self.viewController.navigationController pushViewController:htmelVC animated:YES];
}

#pragma mark - 确认提现
- (IBAction)surebtn:(UIButton *)sender {
    sender.enabled = NO;
    NSString *isJoin = [NSString string];
    if (self.joinBtn.selected) {
        isJoin = @"2";
    }else{
        isJoin = @"1";
    }
    [_dataModelDic setObject:isJoin forKey:@"flag"];
    [_dataModelDic removeObjectForKey:@"content"];
    [_dataModelDic setObject:[TTXUserInfo shareUserInfos].token forKey:@"token"];
    [SVProgressHUD showWithStatus:@"正在提交请求..."];
    [HttpClient POST:@"user/donate/withdraw/add" parameters:_dataModelDic success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [SVProgressHUD dismiss];
        sender.enabled = YES;
        if (IsRequestTrue) {
            NSDictionary *dic = @{@"money":NullToNumber(jsonObject[@"data"])};
            self.successView.infoDic = dic;
            [self withDrawalSuccess];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [SVProgressHUD dismiss];
        sender.enabled = YES;
    }];
    
}

#pragma mark - 提现成功的界面
- (WithDrewSuccessView *)successView
{
    if (!_successView) {
        _successView = [[WithDrewSuccessView alloc]init];
    }
    return  _successView;
}

#pragma mark - 提现成功
- (void)withDrawalSuccess
{
    [self.viewController.navigationController.view addSubview:self.successView];
    [self.successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(self.viewController.view);
        make.trailing.equalTo(self.viewController.view);
        make.bottom.equalTo(self.viewController.view);
    }];
    [self.successView buttonAction];
}


@end
