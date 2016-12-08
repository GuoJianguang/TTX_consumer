//
//  JoinLoveAccountViewController.m
//  TTXForConsumer
//
//  Created by Guo on 16/11/10.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "JoinLoveAccountViewController.h"
#import "WeXinPayObject.h"
#import "MyLoveAccountViewController.h"

@interface JoinLoveAccountViewController ()<BasenavigationDelegate>

@end

@implementation JoinLoveAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"爱心账户";
    self.naviBar.delegate = self;
    
    self.joinBtn.layer.cornerRadius = 25;
    self.joinBtn.layer.masksToBounds = YES;
    self.joinBtn.backgroundColor = MacoColor;
    
    self.expainTextView.text = @"";
    self.expainTextView.textColor = MacoTitleColor;
    self.expainTextView.editable = NO;
    self.naviBar.hiddenDetailBtn = YES;
    self.naviBar.detailTitle = @"账户协议";
    self.expainTextView.backgroundColor = [UIColor clearColor];
    
    NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",formal_html_base,@"loveNotice.html"]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.];
//    self.webview.delegate = self;
    self.webview.backgroundColor = MacoGrayColor;
    [self.webview loadRequest:request];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weixinPayResult:) name:WeixinPayResult object:nil];

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

- (IBAction)joinBtn:(id)sender {
    NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token};
    [WeXinPayObject loveAcountWexinPay:parms];
}

#pragma mark - 微信支付结果回调
- (void)weixinPayResult:(NSNotification *)notification
{
    //    WXSuccess           = 0,    /**< 成功    */
    //    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    //    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    //    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    //    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    //    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    NSString *code = notification.userInfo[@"resultcode"];
    switch ([code intValue]) {
        case WXSuccess:
        {
            __weak JoinLoveAccountViewController *weak_self = self;
            NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token};
            [SVProgressHUD showWithStatus:@"爱心帐户更新中..."];
            [HttpClient POST:@"user/donate/get" parameters:prams success:^(NSURLSessionDataTask *operation, id jsonObject) {
                [SVProgressHUD dismiss];
                MyLoveAccountViewController *loveAccountVC = [[MyLoveAccountViewController alloc]init];
                if ([NullToNumber(jsonObject[@"data"][@"recharge"]) isEqualToString:@"0"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                loveAccountVC.loveAccountDic = jsonObject[@"data"];
                [weak_self.navigationController pushViewController:loveAccountVC animated:YES];
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
            
            break;
        case WXErrCodeCommon:
            [[JAlertViewHelper shareAlterHelper]showTint:@"支付失败" duration:2.];
            
            break;
        case WXErrCodeUserCancel:
            [[JAlertViewHelper shareAlterHelper]showTint:@"您已取消支付" duration:2.];
            
            break;
        case WXErrCodeSentFail:
            [[JAlertViewHelper shareAlterHelper]showTint:@"发起支付请求失败" duration:2.];
            
            break;
        case WXErrCodeAuthDeny:
            [[JAlertViewHelper shareAlterHelper]showTint:@"微信支付授权失败" duration:2.];
            break;
        case WXErrCodeUnsupport:
            [[JAlertViewHelper shareAlterHelper]showTint:@"您未安装微信客户端,请先安装" duration:2.];
            break;
        default:
            break;
    }
}

- (void)backBtnClick
{
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WeixinPayResult object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailBtnClick
{

    BaseHtmlViewController *htmelVC = [[BaseHtmlViewController alloc]init];
    htmelVC.htmlTitle = @"账户协议";
    htmelVC.htmlUrl = [NSString stringWithFormat:@"%@%@",formal_html_base,@"loveNotice.html"];
    [self.navigationController pushViewController:htmelVC animated:YES];
}

@end
