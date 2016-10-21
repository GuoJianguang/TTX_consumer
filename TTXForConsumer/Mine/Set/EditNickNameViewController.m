//
//  EditNickNameViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/23.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "EditNickNameViewController.h"

@interface EditNickNameViewController ()<BasenavigationDelegate,BasenavigationDelegate,UITextFieldDelegate>

@end

@implementation EditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"修改昵称";
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.detailTitle = @"保存";
    self.naviBar.delegate = self;
    self.editTF.delegate = self;
    
    self.editTF.text = [TTXUserInfo shareUserInfos].nickName;

    
}
- (void)detailBtnClick
{
    [self.editTF resignFirstResponder];
    self.editTF.text =  [self.editTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self.editTF.text isEqualToString:@""] || !self.editTF.text) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入新的昵称" duration:1.5];
    }else{
        
        NSDictionary *parms = @{@"realName":self.editTF.text,
                                @"token":[TTXUserInfo shareUserInfos].token};
        [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
                [HttpClient POST:@"user/userInfo/update" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
            [SVProgressHUD dismiss];
            if (IsRequestTrue) {
                [TTXUserInfo shareUserInfos].nickName = jsonObject[@"data"][@"nickName"];
                [[NSNotificationCenter defaultCenter]postNotificationName:ChangeNickNameSucces object:nil];
                [SVProgressHUD showSuccessWithStatus:@"昵称修改成功"];
//                [[JAlertViewHelper shareAlterHelper]showTint:@"昵称修改成功" duration:1.5];
//                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 8) {
        textField.text = [textField.text stringByReplacingCharactersInRange:NSMakeRange(8, textField.text.length-8) withString:@""];
    }
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
