//
//  SetTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/23.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "SetTableViewCell.h"
#import "EditNickNameViewController.h"
#import "RevisePasswordViewController.h"
#import "ShippingAddressViewController.h"
#import "WaitingAuthenticationViewController.h"

@interface SetTableViewCell()<UIActionSheetDelegate>
@property (nonatomic,strong) UIActionSheet *actionSheet;


@end

@implementation SetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.exitBtn.layer.cornerRadius = 20.;
    self.exitBtn.layer.masksToBounds = YES;
    
    self.shimingLabel.textColor = MacoTitleColor;
    self.passwordLabel.textColor = MacoTitleColor;
    self.addressLabel.textColor = MacoTitleColor;
    self.huanclabel.textColor = MacoTitleColor;
    self.detailHuancLabel.textColor = MacoDetailColor;
    
    NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
    
    NSString * currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:intg]];
    self.detailHuancLabel.text = currentVolum;
    self.detailHuancLabel.hidden= YES;

}

- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIActionSheet *)actionSheet
{
    if(_actionSheet == nil)
    {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"您确定要退出登录吗？" delegate:self cancelButtonTitle:@"点错了" destructiveButtonTitle:nil otherButtonTitles:@"退出", nil];
    }
    
    return _actionSheet;
}

//修改昵称
- (IBAction)editNickname:(UIButton *)sender {    
    if ([TTXUserInfo shareUserInfos].idVerifyReqFlag) {
        WaitingAuthenticationViewController *waitingVC = [[WaitingAuthenticationViewController alloc]init];
        [self.viewController.navigationController pushViewController:waitingVC animated:YES];
        return;
    }
    RealNameAutViewController *realNVC = [[RealNameAutViewController alloc]init];
    if ([TTXUserInfo shareUserInfos].identityFlag) {
        realNVC.isYetAut = YES;
    }else{
        realNVC.isYetAut = NO;
    }
    [self.viewController.navigationController pushViewController:realNVC animated:YES];;
}

//修改密码
- (IBAction)editPassword:(UIButton *)sender {
    RevisePasswordViewController *passwordVC = [[RevisePasswordViewController alloc]init];
    [self.viewController.navigationController pushViewController:passwordVC animated:YES];
    
}

//修改收货地址
- (IBAction)editAddrdss:(UIButton *)sender {
    ShippingAddressViewController *shippingAVC = [[ShippingAddressViewController alloc]init];
    [self.viewController.navigationController pushViewController:shippingAVC animated:YES];
}

//清除缓存
- (IBAction)cleanCache:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"正在清除..."];
    [[SDImageCache sharedImageCache]clearDisk];
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
        NSString * currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:intg]];
        self.detailHuancLabel.text = currentVolum;
        [SVProgressHUD showSuccessWithStatus:@"清除完毕"];

    }];
//    // 停止下载图片
//    [[SDWebImageManager sharedManager] cancelAll];
//    
//    // 清除内存缓存图片
//    [[SDWebImageManager sharedManager].imageCache clearMemory];
//    [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{
//
//    }];
    
}
//退出登录
- (IBAction)exitBtn:(UIButton *)sender {
    
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[@"退出"];
        [self addActionTarget:alert titles:titles];
        [self addCancelActionTarget:alert title:@"取消"];
        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        UIFont *font = [UIFont systemFontOfSize:15];
        [appearanceLabel setFont:font];
        [self.viewController presentViewController:alert animated:YES completion:nil];
    }else{
        [self.actionSheet showInView:self.viewController.view];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
                [HttpClient POST:@"user/logout" parameters:@{@"token":[TTXUserInfo shareUserInfos].token} success:^(NSURLSessionDataTask *operation, id jsonObject) {
                    
                } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                }];
                [TTXUserInfo shareUserInfos].currentLogined = NO;
                [self.viewController.navigationController popToRootViewControllerAnimated:YES];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:LoginUserPassword];
                //统计新增用户
                [MobClick profileSignOff];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:LogOutNSNotification object:nil userInfo:nil];
                return;
        }
            break;

            
        default:
            break;
    }
}

#pragma mark - 退出登录的方法

// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles
{
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [HttpClient POST:@"user/logout" parameters:@{@"token":[TTXUserInfo shareUserInfos].token} success:^(NSURLSessionDataTask *operation, id jsonObject) {
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            }];
            [TTXUserInfo shareUserInfos].currentLogined = NO;
            [self.viewController.navigationController popToRootViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:LoginUserPassword];
            //统计新增用户
            [MobClick profileSignOff];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:LogOutNSNotification object:nil userInfo:nil];
        }];
        //        [action setValue:MacoColor forKey:@"_titleTextColor"];
        [alertController addAction:action];
    }
}

// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    //    [action setValue:MacoTitleColor forKey:@"_titleTextColor"];
    [alertController addAction:action];
}

@end
