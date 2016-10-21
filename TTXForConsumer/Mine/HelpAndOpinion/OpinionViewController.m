//
//  OpinionViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "OpinionViewController.h"

@interface OpinionViewController ()<UITextViewDelegate>

@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"意见反馈";
    self.textView.delegate = self;
    
    self.commitBtn.layer.cornerRadius = 35/2.;
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.backgroundColor = MacoColor;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.alerLabel.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 101 && ![text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@""]) {
        self.alerLabel.hidden = NO;;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.textView resignFirstResponder];
    if ([self.textView.text isEqualToString:@""]) {
        self.alerLabel.hidden = NO;;
    }
}

#pragma mark - 体检反馈意见
- (IBAction)commitBtn:(UIButton *)sender {
    
    [self.textView resignFirstResponder];
    if ([self.textView.text isEqualToString:@""] || !self.textView.text) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入您要反馈的意见" duration:1.5];
        return;
    }
    NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token,
                            @"content":self.textView.text};
    [HttpClient POST:@"user/question/add" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            self.alerLabel.hidden = NO;
            self.textView.text = @"";
            [[JAlertViewHelper shareAlterHelper]showTint:@"我们已经收到您的宝贵意见,我们会即使处理，谢谢！" duration:1.5];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
