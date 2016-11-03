//
//  OrderCommentViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "OrderCommentViewController.h"

@interface OrderCommentViewController ()<BasenavigationDelegate,UITextViewDelegate>

@end

@implementation OrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"评价";
    self.naviBar.detailTitle = @"提交";
    self.naviBar.delegate = self;
    self.naviBar.hiddenDetailBtn = NO;
    self.mchName.textColor = MacoTitleColor;
    self.timeLabel.textColor = MacoIntrodouceColor;
    self.alerLabel.textColor = MacoIntrodouceColor;
    self.textView.delegate = self;
    
    self.alerLabel.text = @"您可以将自己购买的心得体会与大家分享";
    
    switch (self.comment_type) {
        case Comment_type_goods:
        {
            [self.mchImage sd_setImageWithURL:[NSURL URLWithString:self.dataModel.pic] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
            self.mchName.text = self.dataModel.goodsName;
            self.timeLabel.text = self.dataModel.tranTime;
            self.detailStr.text = [NSString stringWithFormat:@"%@/数量：%@",self.dataModel.specStr,self.dataModel.quantity];
        }
            break;
        case Comment_type_merchant:
        {
            [self.mchImage sd_setImageWithURL:[NSURL URLWithString:self.dataModel.pic] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
            self.mchName.text = self.dataModel.mchName;
            self.timeLabel.text = self.dataModel.tranTime;
            self.detailStr.hidden = YES;

        }
            break;
            
        default:
            break;
    }
    
    [self.alerLabel.superview bringSubviewToFront:self.alerLabel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.textView resignFirstResponder];
    
}

#pragma mark - 提交评论
- (void)detailBtnClick
{
    
    [self.textView resignFirstResponder];
    if ([self.textView.text isEqualToString:@""] || !self.textView.text) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入评论内容" duration:1.5];
        return;
    }
    
    switch (self.comment_type) {
            //商家的评论
        case Comment_type_merchant:
        {
            NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token,
                                    @"id":self.dataModel.commentId,
                                    @"content":self.textView.text};
            [HttpClient POST:@"user/comment/add" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
                if (IsRequestTrue) {
                    [[JAlertViewHelper shareAlterHelper]showTint:@"评论提交成功" duration:1.5];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"commentSuccess" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [[JAlertViewHelper shareAlterHelper]showTint:@"评论失败，请重试" duration:1.5];
                
            }];
        }
            break;
        case Comment_type_goods:
            //商品的评论
        {
            NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token,
                                    @"id":self.dataModel.commentId,
                                    @"content":self.textView.text};
            [HttpClient POST:@"shop/goodsComment/add" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
                if (IsRequestTrue) {
                    [[JAlertViewHelper shareAlterHelper]showTint:@"评论提交成功" duration:1.5];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"commentSuccess" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [[JAlertViewHelper shareAlterHelper]showTint:@"评论失败，请重试" duration:1.5];
                
            }];
        }
            break;
            
        default:
            break;
    }
    

}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.alerLabel.hidden = YES;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""] || !textView.text) {
        self.alerLabel.hidden = NO;
    }else{
        self.alerLabel.hidden = YES;
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (textView.text.length > 121 && ! [text isEqualToString:@""]) {
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
