//
//  RegisterTableViewCell.m
//  tiantianxin
//
//  Created by ttx on 16/5/30.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "RegisterTableViewCell.h"
#import "Verify.h"

@interface RegisterTableViewCell()<UITextFieldDelegate>
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation RegisterTableViewCell

{
    int timeLefted;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    timeLefted = 60;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickProLabel)];
    self.protocolLabel.userInteractionEnabled = YES;
    [self.protocolLabel addGestureRecognizer:tap];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.protocolLabel.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7, 13)];

    self.protocolLabel.attributedText = attributedString;
    
    self.phone_num_tf.delegate = self;
    self.password_tf.delegate = self;
    self.surePassword_tf.delegate = self;
    self.verifi_tf.delegate = self;
    self.verifi_btn.layer.cornerRadius = 3;
    self.verifi_btn.layer.borderWidth = 1;
    self.verifi_btn.layer.borderColor = MacoGrayColor.CGColor;
    
}

- (void)clickProLabel
{
    BaseHtmlViewController *htmlVC = [[BaseHtmlViewController alloc]init];
    htmlVC.htmlTitle = @"用户使用条款及服务协议";
    htmlVC.htmlUrl = @"http://www.tiantianxcn.com/html5/forapp/xy_user.html";
    [self.viewController.navigationController pushViewController:htmlVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



- (IBAction)graphBtn:(UIButton *)sender {
    if ([self emptyTextOfTextField:self.phone_num_tf]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入手机号码" duration:1.];
        return;
    }
    sender.enabled = NO;
    
    Verify *veri = [[Verify alloc]init];
    [veri verifyPhoneNumber:self.phone_num_tf.text callBack:^(BOOL success, NSError *error) {
        if (success) {
            NSDictionary *parms = @{@"phone":self.phone_num_tf.text,
                                    @"key":@"register"};
            AFHTTPRequestOperationManager *manager = [self defaultManager];
            NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parms];
            NSString *url = [NSString stringWithFormat:@"%@%@",HttpClient_BaseUrl,@"verifyCode/getImageVerifyCode"];
            [manager POST:url parameters:mutalbleParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [SVProgressHUD dismiss];
                UIImage *image = [[UIImage alloc]initWithData:responseObject];
                [self.graphBtn setBackgroundImage:image forState:UIControlStateNormal];
                [self.graphBtn setTitle:@"" forState:UIControlStateNormal];
                sender.enabled = YES;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [[JAlertViewHelper shareAlterHelper]showTint:@"图形验证码获取失败，请重试" duration:2.];
                sender.enabled = YES;
            }];
            return ;
        }
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入正确的手机号" duration:1.5];
        sender.enabled = YES;
    }];
}


-(AFHTTPRequestOperationManager*) defaultManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.stringEncoding = RequestSerializerEncoding;
    requestSerializer.timeoutInterval = TimeoutInterval;
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.stringEncoding = ResponseSerializerEncoding;
    
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = responseSerializer;
    
    return manager;
}



#pragma mark - 验证码按钮点击事件
- (IBAction)verifi_btn:(UIButton *)sender {
    if ([self emptyTextOfTextField:self.graphCodeTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入图形验证码" duration:1.5];
        return;
    }
    sender.enabled = NO;
    Verify *veri = [[Verify alloc]init];
    [veri verifyPhoneNumber:self.phone_num_tf.text callBack:^(BOOL success, NSError *error) {
        if (success) {
            //获取验证码
            NSDictionary *parms = @{@"phone":self.phone_num_tf.text,
                                    @"imageVerifyCode":self.graphCodeTF.text};
            [HttpClient POST:@"sms/sendCommonCode" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
                sender.enabled = YES;
                if (IsRequestTrue) {
                    [self.verifi_btn setTitle:@"重新获取(60)" forState:UIControlStateNormal];
                    self.verifi_btn.enabled = NO;
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeLeft:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                sender.enabled = YES;
            }];
            
            return ;
        }
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入正确的手机号" duration:1.5];
    }];
}


#pragma mark - 完成
- (IBAction)login_btn:(UIButton *)sender {
    [self.phone_num_tf resignFirstResponder];
    [self.verifi_tf resignFirstResponder];
    [self.password_tf resignFirstResponder];
    [self.surePassword_tf resignFirstResponder];
    if ([self valueValidated]) {
        //注册接口请求
        NSString *password = [[NSString stringWithFormat:@"%@%@",self.password_tf.text,PasswordKey]md5_32];
        NSDictionary *parms = @{@"phone":self.phone_num_tf.text,
                                @"verifyCode":self.verifi_tf.text,
                                @"password":password};
        [HttpClient POST:@"user/register" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
            if (IsRequestTrue) {
                [self autoLogin];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [SVProgressHUD dismiss];
        }];
    }
}


-(BOOL) valueValidated {
    // 判断电话号码是否合格
    if ([self emptyTextOfTextField:self.phone_num_tf]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入手机号码" duration:1.];
        return NO;
    }else if ([self emptyTextOfTextField:self.verifi_tf]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入验证码" duration:1.];
        return NO;
    }else if ([self emptyTextOfTextField:self.password_tf]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入密码" duration:1.];
        return NO;
    }else if ([self emptyTextOfTextField:self.surePassword_tf]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请确认密码" duration:1.];
        return NO;
    }else if (![self.password_tf.text isEqualToString:self.surePassword_tf.text]){
        [[JAlertViewHelper shareAlterHelper]showTint:@"两次输入的密码不一致" duration:1.];
        return NO;
    }else if (self.password_tf.text.length < 6 || self.surePassword_tf.text.length < 6){
        [[JAlertViewHelper shareAlterHelper]showTint:@"您的密码长度不能小于6位" duration:1.];
        return NO;
    }
    return YES;
}


-(BOOL) emptyTextOfTextField:(UITextField*) textField {
    
    if ([textField.text isEqualToString:@""] || !textField.text) {
        return YES;
    }
    return NO;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.phone_num_tf resignFirstResponder];
    [self.verifi_tf resignFirstResponder];
    [self.password_tf resignFirstResponder];
    [self.surePassword_tf resignFirstResponder];
}


#pragma mark - 验证码计时器
//static int timeLefted = 60;
-(void) timeLeft:(NSTimer*) timer {
    
    timeLefted--;
    if (timeLefted == 0) {
        [self verifyButtonNormal];
        return;
    }
    NSString *title = [NSString stringWithFormat:@"重新获取(%d)",timeLefted];
    self.verifi_btn.titleLabel.text = title;
    [self.verifi_btn setTitle:title forState:UIControlStateNormal];
    
}

-(void) verifyButtonNormal {
    [self.timer invalidate];
    timeLefted = 60;
    [self.verifi_btn setTitle:@"重新获取" forState:UIControlStateNormal];
    self.verifi_btn.enabled = YES;
}


#pragma mark - UITextFiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phone_num_tf) {
        if (textField.text.length > 10 && ![string isEqualToString:@""]) {
            return NO;
        }
        [self.graphBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.graphBtn setTitle:@"点击获取" forState:UIControlStateNormal];
        
        self.graphCodeTF.text = @"";
    }
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}


- (void)autoLogin
{
    if ([self valueValidated]) {
        //登录接口请求操作
        NSString *password = [[NSString stringWithFormat:@"%@%@",self.password_tf.text,PasswordKey]md5_32];
        
        NSDictionary *parms = @{@"phone":self.phone_num_tf.text,
                                @"deviceToken":[TTXUserInfo shareUserInfos].devicetoken,
                                @"deviceType":@"ios",
                                @"password":password};
        [HttpClient POST:@"user/login" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
//            [SVProgressHUD dismiss];
            if (IsRequestTrue) {
                //设置用户信息
                [[JAlertViewHelper shareAlterHelper]showTint:@"注册成功" duration:1.5];
                [[NSUserDefaults standardUserDefaults]setObject:self.phone_num_tf.text forKey:LoginUserName];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults]setObject:self.password_tf.text forKey:LoginUserPassword];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [TTXUserInfo shareUserInfos].currentLogined = YES;
                [[TTXUserInfo shareUserInfos]setUserinfoWithdic:jsonObject[@"data"]];
                [self.viewController dismissViewControllerAnimated:YES completion:NULL];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [SVProgressHUD dismiss];
        }];
    }
}


@end
