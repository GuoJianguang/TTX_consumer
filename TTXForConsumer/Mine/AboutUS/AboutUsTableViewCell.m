//
//  AboutUsTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "AboutUsTableViewCell.h"


@implementation AboutUsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.versionLabel.textColor = MacoTitleColor;
    self.versionLabel.text = [NSString stringWithFormat:@"版本 %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    self.companyLabel.textColor = self.guanwangLabel.textColor = MacoTitleColor;
    self.weichantLabel.textColor = MacoDetailColor;
    self.aboutUsLabel.textColor = MacoIntrodouceColor;
    self.phoneLabel.textColor = MacoColor;

    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)backBtn:(UIButton *)sender {
    [self.viewController.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)companyWebsite:(UIButton *)sender {
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://www.tiantianxcn.com"]]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"暂时不能浏览官网" duration:1.5];
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.tiantianxcn.com"]];
    
}

- (IBAction)callBtn:(UIButton *)sender {
    UIWebView *webView = (UIWebView*)[self.viewController.view viewWithTag:1000];
    if (!webView) {
        webView = [[UIWebView alloc]init];
    }
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4001028997"]]]];
    [self.viewController.view addSubview:webView];
    
}
@end
