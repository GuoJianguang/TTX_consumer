//
//  RevisePasswordViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "RevisePasswordViewController.h"

@interface RevisePasswordViewController ()<BasenavigationDelegate,UITextFieldDelegate>

@end

@implementation RevisePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"修改密码";
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.detailTitle = @"保存";
    self.naviBar.delegate = self;
    
    [self setViewLayer:self.oldPassword_view];
    [self setViewLayer:self.password_view];
    [self setViewLayer:self.surePassword_view];
    
    self.pasword_tf.delegate = self;
    self.surePassword_tf.delegate = self;
    self.pasword_tf.delegate = self;
    self.label1.textColor = self.label2.textColor = self.label3.textColor = MacoTitleColor;
}

- (void)setViewLayer:(UIView *)view
{
    view.layer.borderWidth = 1;
    view.layer.borderColor =[UIColor colorFromHexString:@"#e6e6e6"].CGColor;
}



#pragma mark - 保存
- (void)detailBtnClick
{
    if ([self valueValidated]) {
        NSString *oldPassword = [[NSString stringWithFormat:@"%@%@",self.oldPassword_tf.text,PasswordKey]md5_32];
        NSString *newPassword = [[NSString stringWithFormat:@"%@%@",self.pasword_tf.text,PasswordKey]md5_32];
        
        [SVProgressHUD showWithStatus:@"正在提交请求..."];
        NSDictionary *parms = @{@"oldPassword":oldPassword,
                                @"token":[TTXUserInfo shareUserInfos].token,
                                @"newPassword":newPassword};
        [HttpClient POST:@"user/updatePassword" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
            [SVProgressHUD dismiss];
            if (IsRequestTrue) {
                //设置用户信息
                [[JAlertViewHelper shareAlterHelper]showTint:@"修改成功" duration:1.5];
                [[NSUserDefaults standardUserDefaults]setObject:self.pasword_tf.text forKey:LoginUserPassword];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }

    
}


-(BOOL) valueValidated {
    // 判断电话号码是否合格
    if ([self emptyTextOfTextField:self.oldPassword_tf]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入旧密码" duration:1.];
        return NO;
    }else if ([self emptyTextOfTextField:self.pasword_tf]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入新密码" duration:1.];
        return NO;
    }else if (self.pasword_tf.text.length<6 || self.pasword_tf.text.length > 18){
        [[JAlertViewHelper shareAlterHelper]showTint:@"您的密码必须在6-18位之间" duration:1.];
        return NO;
    }else if ([self emptyTextOfTextField:self.surePassword_tf]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请重复新密码" duration:1.];
        return NO;
    }else if (![self.pasword_tf.text isEqualToString:self.surePassword_tf.text]){
        [[JAlertViewHelper shareAlterHelper]showTint:@"两次输入的密码不一致" duration:1.];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
