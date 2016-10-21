//
//  ViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/16.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "RootViewController.h"
#import "MessageViewController.h"
#import "WalletDymicViewController.h"
#import "OderListViewController.h"

static NSString *infomation = @"infomation";//消息列表
static NSString *feedback = @"feedback";//账户返现
static NSString *withdraw = @"withdraw";//账户提现
static NSString *waitPay = @"waitPay";//待付款
static NSString *waitReceive = @"waitReceive";//待收货

@interface RootViewController ()<UIAlertViewDelegate>

@property (nonatomic, copy)NSString *turnType;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    
    //接收的推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fanxian:) name:Upush_Notifi object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLogin) name:AutoLoginAfterGetDeviceToken object:nil];
}


- (void)notifica:(NSDictionary *)notifiInfo
{
    if ([TTXUserInfo shareUserInfos].currentLogined) {
        self.turnType = NullToSpace(notifiInfo[@"page"]);
        NSString *alerInfo = NullToSpace(notifiInfo[@"aps"][@"alert"]);
        if (![self.turnType isEqualToString:infomation] &&![self.turnType isEqualToString:feedback]&&![self.turnType isEqualToString:withdraw]&&![self.turnType isEqualToString:waitPay]&&![self.turnType isEqualToString:waitReceive]) {
            UIAlertView *showView = [[UIAlertView alloc]initWithTitle:@"提醒" message:alerInfo delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [showView show];
            showView.tag = 20;
            return;
        }
        UIAlertView *showView = [[UIAlertView alloc]initWithTitle:@"提醒" message:alerInfo delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去看看", nil];
        [showView show];
        showView.tag = 10;
    }
}

//接收返现信息的推送

- (void)fanxian:(NSNotification *)faication
{
    if ([TTXUserInfo shareUserInfos].currentLogined) {
        self.turnType = NullToSpace(faication.userInfo[@"page"]);
        NSString *alerInfo = NullToSpace(faication.userInfo[@"aps"][@"alert"]);
        if (![self.turnType isEqualToString:infomation] &&![self.turnType isEqualToString:feedback]&&![self.turnType isEqualToString:withdraw]&&![self.turnType isEqualToString:waitPay]&&![self.turnType isEqualToString:waitReceive]) {
            UIAlertView *showView = [[UIAlertView alloc]initWithTitle:@"提醒" message:alerInfo delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [showView show];
            showView.tag = 20;
            return;
        }
        UIAlertView *showView = [[UIAlertView alloc]initWithTitle:@"提醒" message:alerInfo delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去看看", nil];
        [showView show];
        showView.tag = 10;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10 && buttonIndex == 1) {
        if ([self.turnType isEqualToString:infomation]) {
            MessageViewController *listVC = [[MessageViewController alloc]init];
            [self pushViewController:listVC animated:YES];
            
        }else if([self.turnType isEqualToString:feedback]){
            WalletDymicViewController *detailVC = [[WalletDymicViewController alloc]init];
            detailVC.walletType = WalletDymic_type_fanXian;
            [self pushViewController:detailVC animated:YES];
        }else if([self.turnType isEqualToString:withdraw]){
            WalletDymicViewController *detailVC = [[WalletDymicViewController alloc]init];
            detailVC.walletType = WalletDymic_type_Tixian;
            [self pushViewController:detailVC animated:YES];
        }else if([self.turnType isEqualToString:waitPay]){
//            WaitPayViewController *waitPayVC = [[WaitPayViewController alloc]init];
//            [self pushViewController:waitPayVC animated:YES];
        }else if([self.turnType isEqualToString:waitReceive]){
            OderListViewController *orderListVC = [[OderListViewController alloc]init];
            orderListVC.orderType = Order_type_waitShipp;
            [self pushViewController:orderListVC animated:YES];
        }
        return;
    }else if(alertView.tag == 20){
        return;
    }else{
        //去登录
        if (buttonIndex == 1) {
            UINavigationController *logvc = [LoginViewController controller];
            [self presentViewController:logvc animated:YES completion:NULL];
        }
    }
}

#pragma mark - 自动登录
- (void)autoLogin
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:LoginUserPassword]) {
        NSString *password = [[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]objectForKey:LoginUserPassword],PasswordKey]md5_32];
        
        NSDictionary *parms = @{@"phone":[[NSUserDefaults standardUserDefaults]objectForKey:LoginUserName],
                                @"deviceToken":[TTXUserInfo shareUserInfos].devicetoken,
                                @"deviceType":@"ios",
                                @"password":password};
        [HttpClient POST:@"user/login" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
            if (IsRequestTrue) {
                //设置用户信息
                [TTXUserInfo shareUserInfos].currentLogined = YES;
                [[TTXUserInfo shareUserInfos]setUserinfoWithdic:jsonObject[@"data"]];
                //统计新增用户
                [MobClick profileSignInWithPUID:[TTXUserInfo shareUserInfos].userid];
                if ([TTXUserInfo shareUserInfos].islaunchFormNotifi) {
                    [self notifica:[TTXUserInfo shareUserInfos].notificationParms];
                    [TTXUserInfo shareUserInfos].islaunchFormNotifi = NO;
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
