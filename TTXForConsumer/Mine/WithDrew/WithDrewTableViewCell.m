//
//  WithDrewTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/22.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "WithDrewTableViewCell.h"

@interface WithDrewTableViewCell()<UITextFieldDelegate>
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong)NSString *rate;


@end


@implementation WithDrewTableViewCell
{
    int timeLefted;

    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    timeLefted = 60;
//    [TTXUserInfo setjianpianColorwithView:self.showMoneyView withWidth:TWitdh withHeight:TWitdh/2];
    self.tixianLabel.textColor = MacoTitleColor;
    self.codeLabel.textColor = MacoTitleColor;
    self.alerLabel.textColor = self.alerLabel1.textColor = MacoDetailColor;
    self.alerLabel.adjustsFontSizeToFitWidth = self.alerLabel1.adjustsFontSizeToFitWidth = YES;
    self.actualAmount.textColor = MacoColor;
    
    self.withDrewMoenyView.layer.borderWidth = 1;
    self.withDrewMoenyView.layer.borderColor = MacolayerColor.CGColor;
    self.verCodeView.layer.borderWidth = 1;
    self.verCodeView.layer.borderColor = MacolayerColor.CGColor;
    
    self.sendCodeBtn.layer.cornerRadius = 5;
    self.sendCodeBtn.layer.borderWidth =  1;
    self.sendCodeBtn.layer.borderColor = MacoColor.CGColor;
    self.sendCodeBtn.layer.masksToBounds = YES;
    [self.sendCodeBtn setTitleColor:MacoColor forState:UIControlStateNormal];
    
    self.commitBtn.layer.cornerRadius = 35/2.;
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.backgroundColor = MacoColor;
    self.editMoneyTF.delegate = self;
    //账户余额
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[[TTXUserInfo shareUserInfos].aviableBalance doubleValue]];
    self.alerGradeLabel.textColor = MacoDetailColor;
    //self.alerGradeLabel.hidden = YES;
    if ([[TTXUserInfo shareUserInfos].grade isEqualToString:@"10"]) {
        self.alerGradeLabel.text = [NSString stringWithFormat:@"当前等级VIP%@,没有提现额度限制",[TTXUserInfo shareUserInfos].grade];
    }else{
        self.alerGradeLabel.text = [NSString stringWithFormat:@"当前等级VIP%@,提现额度为1000",[TTXUserInfo shareUserInfos].grade];
    }
    
    
    [self checkWhatMybank];
}

- (NSString *)rate
{
    if (!_rate) {
        _rate = [NSString string];
    }
    return _rate;
}


- (LoveAccountAlerView *)loveAccountView
{
    if (!_loveAccountView) {
        _loveAccountView = [[LoveAccountAlerView alloc]init];
    }
    return _loveAccountView;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.editMoneyTF resignFirstResponder];
}

#pragma mark - 检查当前绑定的是什么银行卡
- (void)checkWhatMybank
{
    NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token};
    [HttpClient GET:@"user/withdraw/bindBankcard/get" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [TTXUserInfo shareUserInfos].bankname = NullToSpace(jsonObject[@"data"][@"bankId"]);
            self.rate = NullToNumber(jsonObject[@"data"][@"withdrawRate"]);
            if ([NullToSpace(jsonObject[@"data"][@"withdrawRateDesc"]) isEqualToString:@""]) {
                self.alerLabel.text = [NSString stringWithFormat:@"农行手续费2元，其他行手续费6元"];
            }else{
                self.alerLabel.text = [NSString stringWithFormat:@"%@",NullToSpace(jsonObject[@"data"][@"withdrawRateDesc"])];
            }
            
        }
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (WithDrewSuccessView *)successView
{
    if (!_successView) {
        _successView = [[WithDrewSuccessView alloc]init];
    }
    return  _successView;
}


- (IBAction)sendCodeBtn:(UIButton *)sender {
    // 判断电话号码是否合格
    if ([self emptyTextOfTextField:self.editMoneyTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入提现金额" duration:1.];
        return;
    }else if ([self.moneyLabel.text doubleValue] < [self.editMoneyTF.text doubleValue]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"您的可提现余额不足，请重新输入" duration:1.];
        return;
    }else if ([self.editMoneyTF.text integerValue]%10 !=0){
        [[JAlertViewHelper shareAlterHelper]showTint:@"您的提现金额必须是10的整数倍" duration:1.];
        return;
    }else if ([self.editMoneyTF.text integerValue] <100 ){
        [[JAlertViewHelper shareAlterHelper]showTint:@"您的提现金额不能小于100" duration:1.5];
        return;
    }
    sender.enabled = NO;
    [HttpClient POST:@"user/withdraw/sendVerifyCode" parameters:@{@"token":[TTXUserInfo shareUserInfos].token} success:^(NSURLSessionDataTask *operation, id jsonObject) {
        sender.enabled = YES;
        if (IsRequestTrue) {
            [self.sendCodeBtn setTitle:@"重新获取(60)" forState:UIControlStateNormal];
            self.sendCodeBtn.enabled = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeLeft:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        sender.enabled = YES;
    }];
}

#pragma mark - 验证码计时器
-(void) timeLeft:(NSTimer*) timer {
    timeLefted--;
    if (timeLefted == 0) {
        [self verifyButtonNormal];
        return;
    }
    NSString *title = [NSString stringWithFormat:@"重新获取(%d)",timeLefted];
    self.sendCodeBtn.titleLabel.text = title;
    [self.sendCodeBtn setTitle:title forState:UIControlStateNormal];
    
}


-(void) verifyButtonNormal {
    [self.timer invalidate];
    timeLefted = 60;
    [self.sendCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    self.sendCodeBtn.enabled = YES;
}

- (IBAction)commitBtn:(UIButton *)sender {
//    [self.codeTF resignFirstResponder];
//    [self.editMoneyTF resignFirstResponder];
//    
//    sender.enabled = NO;
//    if ([self valueValidated]) {
//        //提现的接口请求
//        NSString *password = [[NSString stringWithFormat:@"%@%@",self.codeTF.text,PasswordKey]md5_32];
//        NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token,
//                                @"password":password,
//                                @"withdrawAmount":self.editMoneyTF.text};
//        [SVProgressHUD showWithStatus:@"正在提交申请"];
//        [HttpClient POST:@"user/withdraw/add" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
//            sender.enabled = YES;
//            [SVProgressHUD dismiss];
//            if (IsRequestTrue) {
//                NSDictionary *dic = @{@"money":self.editMoneyTF.text};
//                self.successView.infoDic = dic;
//                [self withDrawalSuccess];
//            }
//        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//            [SVProgressHUD dismiss];
//            sender.enabled = YES;
//        }];
//    }else{
//        sender.enabled = YES;
//    }
    
    [self.codeTF resignFirstResponder];
    [self.editMoneyTF resignFirstResponder];
    sender.enabled = NO;
    if ([self valueValidated]) {
        NSString *password = [[NSString stringWithFormat:@"%@%@",self.codeTF.text,PasswordKey]md5_32];
        NSDictionary *prms = @{@"token":[TTXUserInfo shareUserInfos].token,
                               @"password":password};
        //判断是否加入了爱心账户
        [HttpClient POST:@"user/donate/notify/get" parameters:prms success:^(NSURLSessionDataTask *operation, id jsonObject) {
            if (IsRequestTrue) {
                if ([NullToNumber(jsonObject[@"data"][@"notifyFlag"]) isEqualToString:@"0"]) {
                    [self withDrewQequest:sender];
                }else{
                    sender.enabled = YES;
                    if ([jsonObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                        [self isLoveAccount:jsonObject[@"data"]];
                        return ;
                    }
                    [[JAlertViewHelper shareAlterHelper]showTint:@"数据异常，请稍后重试" duration:2.];
                }
                return;
            }
            sender.enabled = YES;
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            sender.enabled = YES;
        }];
    }else{
        sender.enabled = YES;
    }
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


-(BOOL) valueValidated {
    // 判断电话号码是否合格
    if ([self emptyTextOfTextField:self.editMoneyTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入提现金额" duration:1.];
        return NO;
    }else if ([self.moneyLabel.text doubleValue] < [self.editMoneyTF.text doubleValue]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"您的可提现余额不足，请重新输入" duration:1.5];
        return NO;
    }else if ([self.editMoneyTF.text integerValue]%10 !=0){
        [[JAlertViewHelper shareAlterHelper]showTint:@"您的提现金额必须是10的整数倍" duration:1.5];
        return NO;
    }else if (([self.editMoneyTF.text integerValue] <100 || [self.editMoneyTF.text integerValue] >1000) &&![[TTXUserInfo shareUserInfos].grade isEqualToString:@"10"]){
            [[JAlertViewHelper shareAlterHelper]showTint:@"您的提现金额不能小于100，并且不能超过1000" duration:1.5];
            return NO;
    }else if ([self emptyTextOfTextField:self.codeTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入密码" duration:1.5];
        return NO;
    }
    
    //else if ([self.editMoneyTF.text integerValue] <100 ){
     //   [[JAlertViewHelper shareAlterHelper]showTint:@"您的提现金额不能小于100" duration:2.];
      //  return NO;
   // }
//    else if (([self.editMoneyTF.text integerValue] <100 || [self.editMoneyTF.text integerValue] >1000) &&![[TTXUserInfo shareUserInfos].grade isEqualToString:@"10"]){
//        [[JAlertViewHelper shareAlterHelper]showTint:@"您的提现金额不能小于100，并且不能超过1000" duration:1.5];
//        return NO;
//    }
    
    return YES;
}

-(BOOL) emptyTextOfTextField:(UITextField*) textField {
    
    if ([textField.text isEqualToString:@""] || !textField.text) {
        return YES;
    }
    return NO;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.editMoneyTF == textField) {
        
        if ([textField.text  isEqualToString: @""] || !textField.text) {
            return;
        }
        double withRate = 1 -  [self.rate doubleValue];
        double money = [textField.text doubleValue];
        
        if (withRate != 1) {
            double actualMoney = money*withRate;
            self.actualAmount.text = [NSString stringWithFormat:@"实到金额：%.2f元",actualMoney];
            return;
        }
        
        if ([[TTXUserInfo shareUserInfos].bankname isEqualToString:@"2"]) {
            double actualMoney = money*withRate - 2;
            self.actualAmount.text = [NSString stringWithFormat:@"实到金额：%.2f元",actualMoney];
        }else{
            double actualMoney = money*withRate - 6;
            self.actualAmount.text = [NSString stringWithFormat:@"实到金额：%.2f元",actualMoney];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.editMoneyTF) {
        self.actualAmount.text = [NSString stringWithFormat:@"实到金额：--元"];
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange         pointRange = [textField.text rangeOfString:@"."];
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        else
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
        {
            return NO;
        }
        
        short remain = 2; //默认保留2位小数
        
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return NO;
            }
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string;
                return NO;
            }else{
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                }
            }
        }
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
        {
            return NO;
        }
    }
    return YES;
}


- (IBAction)backBtn:(UIButton *)sender {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}


- (IBAction)tixianAction:(UIButton *)sender {
    BaseHtmlViewController *htmelVC = [[BaseHtmlViewController alloc]init];
    htmelVC.htmlTitle = @"提现说明";
    htmelVC.htmlUrl = @"https://www.tiantianxcn.com/html5/forapp/getMoney-notice.html";
    [self.viewController.navigationController pushViewController:htmelVC animated:YES];
    
}


#pragma  mark - 发起提现请求
- (void)withDrewQequest:(UIButton *)sender
{
    //提现的接口请求
    NSString *password = [[NSString stringWithFormat:@"%@%@",self.codeTF.text,PasswordKey]md5_32];
    NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token,
                            @"password":password,
                            @"withdrawAmount":self.editMoneyTF.text};
    [SVProgressHUD showWithStatus:@"正在提交申请"];
    [HttpClient POST:@"user/withdraw/add" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        [SVProgressHUD dismiss];
        sender.enabled = YES;
        if (IsRequestTrue) {
            NSDictionary *dic = @{@"money":self.editMoneyTF.text};
            self.successView.infoDic = dic;
            [self withDrawalSuccess];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        sender.enabled = YES;
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 是否加入爱心账户

- (void)isLoveAccount:(NSDictionary *)parms
{
    [self.viewController.view addSubview:self.loveAccountView];
    NSString *password = [[NSString stringWithFormat:@"%@%@",self.codeTF.text,PasswordKey]md5_32];
    NSMutableDictionary *datamodel = [NSMutableDictionary dictionaryWithDictionary:@{@"content":NullToSpace(parms[@"content"]),
                                                                                     @"password":password,
                                                                                     @"withdrawAmount":self.editMoneyTF.text}];
    self.loveAccountView.dataModelDic = datamodel;
    [self.loveAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(self.viewController.view);
        make.trailing.equalTo(self.viewController.view);
        make.bottom.equalTo(self.viewController.view);
    }];
}

@end
