//
//  AboutUsTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/27.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "AboutUsTableViewCell.h"

@interface AboutUsTableViewCell()<UIActionSheetDelegate>

@end

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
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://www.tiantianxcn.com"]]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"暂时不能浏览官网" duration:1.5];
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tiantianxcn.com"]];
    
}

#pragma mark - 拨打客服电话
- (IBAction)callBtn:(UIButton *)sender {
    NSArray *arry =  @[@"02862908389",@"02862908390",@"02862908391",@"02862908392"];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"拨打客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    for (int i = 0; i < arry.count; i ++) {
        [sheet addButtonWithTitle:arry[i]];
    }
    [sheet showInView:self.viewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
