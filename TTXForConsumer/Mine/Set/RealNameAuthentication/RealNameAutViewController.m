//
//  RealNameAutViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/29.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "RealNameAutViewController.h"
#import "OtherdiquRealNameAutViewController.h"
#import "AuthenticationSuccessView.h"
#import "Verify.h"
#import "WaitingAuthenticationViewController.h"

@interface RealNameAutViewController ()


@property (nonatomic, strong)AuthenticationSuccessView *successView;

@end

@implementation RealNameAutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"实名认证";
    [self setViewLayer:self.nameView];
    [self setViewLayer:self.idCardNumView];
    
    self.yetAutLabel.layer.cornerRadius = 4;
    self.yetAutLabel.backgroundColor = MacoColor;
    self.yetAutLabel.textColor = [UIColor whiteColor];
    self.yetAutLabel.layer.masksToBounds = YES;
    self.yetAutLabel.hidden = YES;
    self.yetAutLabel.text = @"已认证";
    self.alerLabel.text = @"提示：为保障您的资金安全需进行实名认证，一经认证不可修改。海外、港澳台地区及无法认证的消费者请手动认证，您每天最多有3次机会可以进行实名认证，请仔细核对认证信息！";
    self.sureBtn.layer.cornerRadius = self.ManualCerBtn.layer.cornerRadius= 20.;
    self.sureBtn.layer.masksToBounds =  self.ManualCerBtn.layer.masksToBounds = YES;
    
    self.label2.textColor = self.label1.textColor = MacoTitleColor;
    self.alerLabel.textColor = MacoDetailColor;
    //已经实名认证
    self.yetAutLabel.hidden = !self.isYetAut;
    if (self.isYetAut) {
        self.nameTF.text = [TTXUserInfo shareUserInfos].idcardName;
        self.idCardNumTF.text = [TTXUserInfo shareUserInfos].idcard;
        self.nameTF.enabled  = NO;
        self.idCardNumTF.enabled  = NO;
        self.sureBtn.hidden = YES;
        self.ManualCerBtn.hidden = YES;
        self.alerLabel.hidden = YES;
        [self hideIDCardNum];
    }
    
    //手动认证是否正在审核
    if ([TTXUserInfo shareUserInfos].idVerifyReqFlag) {
        WaitingAuthenticationViewController *waitingVC = [[WaitingAuthenticationViewController alloc]init];
        [self addChildViewController:waitingVC];
//        [self.navigationController pushViewController:waitingVC animated:YES];
        [self.view addSubview:waitingVC.view];
    }
    
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"重要提示" message:@"您每天有3次机会可以进行实名认证，请仔细核实您的实名认证信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertcontroller addAction:cancelAction];
    [self presentViewController:alertcontroller animated:YES completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if ([TTXUserInfo shareUserInfos].idVerifyReqFlag) {
//        WaitingAuthenticationViewController *waitingVC = [[WaitingAuthenticationViewController alloc]init];
//        [self.navigationController pushViewController:waitingVC animated:YES];
//    }
}


- (void)hideIDCardNum
{
    if (self.idCardNumTF.text.length == 18) {
        self.idCardNumTF.text = [self.idCardNumTF.text stringByReplacingCharactersInRange:NSMakeRange(1, 16) withString:@"****************"];
    }

}

- (void)setViewLayer:(UIView *)view
{
    view.layer.borderWidth = 1;
    view.layer.borderColor = MacolayerColor.CGColor;
}


//2035,"身份证实名认证失败"
//2036,"实名认证失败,身份证与姓名不匹配"
//2037,"未绑卡，现在去绑定银行卡吗？"
//2038,"您还没有实名认证"
//2039,"实名认证信息与之前绑定银行卡信息不一致，银行卡信息已清空，是否现在去重新绑定？"

#pragma mark - 确定认证
- (IBAction)sureBtn:(UIButton *)sender {
    [self.idCardNumTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
    sender.enabled = NO;
    if ([self valueValidated]) {
        NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token,
                                @"cardNo":self.idCardNumTF.text,
                                @"idcardName":self.nameTF.text};
        AFHTTPSessionManager *manager = [self defaultManager];
        NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parms];
        NSString *url = [NSString stringWithFormat:@"%@%@",HttpClient_BaseUrl,@"user/verifyIdcard"];
        [SVProgressHUD showWithStatus:@"正在请求..."];
        [manager POST:url parameters:mutalbleParameter progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            sender.enabled = YES;
            @try {
                NSError *error = nil;
                //    id jsonObject = [responseObject objectFromJSONData];//
                id jsonObject=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:ResponseSerializerEncoding];
                NSString *err_string = [NSString stringWithFormat:@"json 格式错误.返回字符串：%@",responseString];
                NSAssert(error==nil, err_string);
                //token过期
                if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                    if ([NullToNumber(jsonObject[@"code"]) isEqualToString:@"-300"]) {
                        [TTXUserInfo shareUserInfos].currentLogined = NO;
                        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您的登录信息已过期，请重新登录" delegate:[UIApplication sharedApplication].keyWindow.rootViewController cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [aler show];
                        return;
                    }
                    if ([NullToNumber(jsonObject[@"code"]) isEqualToString:@"0"]) {
                        [TTXUserInfo shareUserInfos].identityFlag = YES;
                        self.successView.infoDic = @{@"name":self.nameTF.text,
                                                     @"idcardnumber":self.idCardNumTF.text};
                        [TTXUserInfo shareUserInfos].idcardName  =self.nameTF.text ;
                        [TTXUserInfo shareUserInfos].idcard = self.idCardNumTF.text ;
                        self.successView.alerCode = NullToNumber(jsonObject[@"code"]);
                        self.successView.alerString = NullToSpace(jsonObject[@"message"]);
                        [self.view addSubview:self.successView];
                        [self.successView buttonAction];
                        return;
                    }
                    //                    2035,"身份证实名认证失败"
                    else if ([NullToNumber(jsonObject[@"code"]) isEqualToString:@"2035"]) {
                        [[JAlertViewHelper shareAlterHelper]showTint:jsonObject[@"message"] duration:1.5];
                        return;
                    }
                    //                    2036,"实名认证失败,身份证与姓名不匹配"
                    else if ([NullToNumber(jsonObject[@"code"]) isEqualToString:@"2036"]) {
                        [[JAlertViewHelper shareAlterHelper]showTint:jsonObject[@"message"] duration:1.5];
                        return;
                    }
                    //                    2037,"未绑卡，现在去绑定银行卡吗？"
                    else if ([NullToNumber(jsonObject[@"code"]) isEqualToString:@"2037"]) {
                        [TTXUserInfo shareUserInfos].identityFlag = YES;
                        self.successView.infoDic = @{@"name":self.nameTF.text,
                                                     @"idcardnumber":self.idCardNumTF.text};
                        [TTXUserInfo shareUserInfos].idcardName  =self.nameTF.text ;
                        [TTXUserInfo shareUserInfos].idcard = self.idCardNumTF.text ;
                        self.successView.alerCode = NullToNumber(jsonObject[@"code"]);
                        self.successView.alerString = NullToSpace(jsonObject[@"message"]);
                        [self.view addSubview:self.successView];
                        [self.successView buttonAction];
                        return;
                    }
                    //                    2039,"实名认证信息与之前绑定银行卡信息不一致，银行卡信息已清空，是否现在去重新绑定？"
                    else if ([NullToNumber(jsonObject[@"code"]) isEqualToString:@"2039"]) {
                        [TTXUserInfo shareUserInfos].identityFlag = YES;
                        self.successView.infoDic = @{@"name":self.nameTF.text,
                                                     @"idcardnumber":self.idCardNumTF.text};
                        [TTXUserInfo shareUserInfos].idcardName  =self.nameTF.text ;
                        [TTXUserInfo shareUserInfos].idcard = self.idCardNumTF.text ;
                        self.successView.alerCode = NullToNumber(jsonObject[@"code"]);
                        self.successView.alerString = NullToSpace(jsonObject[@"message"]);
                        [self.view addSubview:self.successView];
                        [self.successView buttonAction];
                        return;
                    }else{
                        [[JAlertViewHelper shareAlterHelper]showTint:jsonObject[@"message"] duration:1.5];
                        return;
                    }
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            sender.enabled = YES;
            [SVProgressHUD dismiss];
            [[JAlertViewHelper shareAlterHelper]showTint:@"网络请求失败，请重试" duration:2.];
        }];
    }else{
        sender.enabled = YES;
        
    }
}


-(BOOL) valueValidated {
    // 判断电话号码是否合格
    if ([self emptyTextOfTextField:self.nameTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入姓名" duration:1.5];
        return NO;
    }else if ([self emptyTextOfTextField:self.idCardNumTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入身份证号码" duration:1.5];
        return NO;
    }
    Verify *ver = [[Verify alloc]init];
//    if (![ver verifyIDNumber:self.idCardNumTF.text]) {
//        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入正确的身份证号码" duration:1.5];
//        return NO;
//    }
    return YES;
}

-(BOOL) emptyTextOfTextField:(UITextField*) textField {
    
    if ([textField.text isEqualToString:@""] || !textField.text) {
        return YES;
    }
    return NO;
    
}


- (AuthenticationSuccessView *)successView
{
    if (!_successView) {
        _successView = [[AuthenticationSuccessView alloc]init];
        _successView.frame = CGRectMake(0, 64, TWitdh, THeight - 64);
    }
    return _successView;
}


-(AFHTTPSessionManager*) defaultManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.stringEncoding = RequestSerializerEncoding;
    requestSerializer.timeoutInterval = TimeoutInterval;
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.stringEncoding = ResponseSerializerEncoding;
    
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = responseSerializer;
    
    return manager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ManualCerBtn:(UIButton *)sender {
    OtherdiquRealNameAutViewController *ohterDiquVC = [[OtherdiquRealNameAutViewController alloc]init];
    [self.navigationController pushViewController:ohterDiquVC animated:YES];
}
@end
