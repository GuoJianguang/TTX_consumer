//
//  MineTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/21.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MineTableViewCell.h"
#import "WithDrewMoneyViewController.h"
#import "BankCardManageViewController.h"
#import "WalletDymicViewController.h"
#import "SetViewController.h"
#import "HelpViewController.h"
#import "AboutUsViewController.h"
#import "OderListViewController.h"
#import "ChangeHeadImage.h"
#import "MyInvitationViewController.h"
#import "MineViewController.h"
#import "CustomIOSAlertView.h"
#import "RealNameAutViewController.h"
#import "MyLoveAccountViewController.h"
#import "JoinLoveAccountViewController.h"
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"



@interface MineTableViewCell()<BaiduMobAdViewDelegate>

{
    BaiduMobAdView* sharedAdView;

}

@property (nonatomic, strong)ChangeHeadImage *changeIamge;

@end

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
    self.yetRealName.layer.cornerRadius  = 5;
    self.yetRealName.layer.masksToBounds = YES;
    self.yetRealName.textAlignment = NSTextAlignmentCenter;
    self.yetRealName.backgroundColor = MacoColor;
    
    self.mineBgIamge.image = [UIImage imageNamed:@"bg_mine.jpg"];
    self.headImage.layer.cornerRadius = (TWitdh*(170/750.) - 24)/2;
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.borderWidth = 3;
    self.headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.myzichan.textColor = MacoTitleColor;
    self.myorderLabel.textColor = MacoTitleColor;
    self.myWalletLabel.textColor = MacoTitleColor;
    self.mytuijianLabel.textColor = MacoColor;
    self.mySetLabel.textColor = MacoTitleColor;
    self.myloveLabel.textColor = MacoTitleColor;
    self.myHelpLabel.textColor = MacoTitleColor;
    self.myAboutLabel.textColor = MacoTitleColor;
    self.accountBalance.textColor = MacoColor;
    self.consumeBalanceLabel.textColor = MacoColor;
    self.accountBalance.adjustsFontSizeToFitWidth = YES;
    self.WaitCashbackAmount.adjustsFontSizeToFitWidth = YES;
    self.totalConsumeAmount.adjustsFontSizeToFitWidth = YES;
    
    self.WaitCashbackAmount.textColor =MacoColor;
    self.totalConsumeAmount.textColor = MacoColor;
    self.alerLabel.adjustsFontSizeToFitWidth = YES;


    self.vipView.layer.cornerRadius = 2.5;
    self.vipView.layer.masksToBounds = YES;
    self.vipHelp.adjustsFontSizeToFitWidth = YES;

    [self functionItem:self.yetComplete withImageNamed:@"icon_mine_all_orders" title:@"全部"];
    [self functionItem:self.waitShipp withImageNamed:@"icon_mine_completed_orders" title:@"已完成"];
    [self functionItem:self.waitComment withImageNamed:@"icon_mine_orders_to_be_received" title:@"待收货"];
    [self functionItem:self.withDraw withImageNamed:@"icon_mine_cash_withdrawal" title:@"金额提现"];
    [self functionItem:self.walltDynamic withImageNamed:@"icon_mine_purse_dynamics" title:@"钱包动态"];
    [self functionItem:self.bankManagement withImageNamed:@"icon_mine_managing_bank_card" title:@"管理银行卡"];
    self.backTotal.text = [NSString stringWithFormat:@"欢迎您加入天添薪平台！"];

    
//    [self searchUserInfor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(eidtUserNameSuccess) name:ChangeNickNameSucces object:nil];
    
    self.nameLabel.text = [TTXUserInfo shareUserInfos].nickName;
    
//    self.changeIamge = [ChangeHeadImage]
    //给头像添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changheadImage)];
    [self.headImage addGestureRecognizer:tap];
    self.headImage.userInteractionEnabled = YES;
    self.changeIamge.cell = self;
    [self loadingHeadImage];
    //获取个人信息
    [self searchUserInfor];
    //获取我的等级信息
    [self getMyGrade];
    
//    [self addAdView];
}

#pragma mark - 获取个人信息

- (void)searchUserInfor
{
    NSString *token = [TTXUserInfo shareUserInfos].token;
    //获取用户最新消息
    [HttpClient POST:@"user/userBaseInfo/get" parameters:@{@"token":token} success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [[TTXUserInfo shareUserInfos]setUserinfoWithdic:jsonObject[@"data"]];
            if ([[TTXUserInfo shareUserInfos].messageCount isEqualToString:@"0"]) {
               ((MineViewController *)self.viewController).naviBar.detailImage = [UIImage imageNamed:@"icon_mine_message"];
            }else{
                ((MineViewController *)self.viewController).naviBar.detailImage = [UIImage imageNamed:@"icon_mine_message_reddot"];
            };
            if ([TTXUserInfo shareUserInfos].identityFlag) {
                self.nameLabel.hidden = NO;
                self.yetRealName.hidden = NO;
                self.nameLabel.text = [TTXUserInfo shareUserInfos].idcardName;
                self.goRealNameBtn.hidden = YES;
            }else{
                self.nameLabel.hidden = YES;
                self.yetRealName.hidden = YES;
                self.goRealNameBtn.hidden = NO;
            }
            //是否显示提示的Label
            [TTXUserInfo shareUserInfos].token = token;
            if ([[TTXUserInfo shareUserInfos].totalConsumeAmount floatValue] > 0 &&[[TTXUserInfo shareUserInfos].totalExpectAmount floatValue]==0) {
                self.alerLabel.hidden = NO;
                self.alerTop.constant = 31;
            }else{
                self.alerLabel.hidden = YES;
                self.alerTop.constant = 10;
            }
            CGFloat cumCashback = [[TTXUserInfo shareUserInfos].totalConsumeAmount doubleValue] -[[TTXUserInfo shareUserInfos].totalExpectAmount doubleValue]-[[TTXUserInfo shareUserInfos].wiatJoinAmunt doubleValue];
//            self.backTotal.text = [NSString stringWithFormat:@"您已累计让利回馈%.2f元",cumCashback];
            self.accountBalance.text = [NSString stringWithFormat:@"%.2f",[[TTXUserInfo shareUserInfos].aviableBalance doubleValue]];
            self.WaitCashbackAmount.text = [NSString stringWithFormat:@"%.2f",[[TTXUserInfo shareUserInfos].totalExpectAmount doubleValue] + [[TTXUserInfo shareUserInfos].wiatJoinAmunt doubleValue]];
             self.totalConsumeAmount.text = [NSString stringWithFormat:@"%.2f",[[TTXUserInfo shareUserInfos].totalConsumeAmount doubleValue]];
            self.consumeBalanceLabel.text = [NSString stringWithFormat:@"%.2f",[[TTXUserInfo shareUserInfos].consumeBalance doubleValue]];
            [self setYetWihtMessage];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
    
    
}



#pragma mark - 设置各个模块的唯独消息数量
- (void)setYetWihtMessage
{
    //全部订单
//    self.yetComplete.alerTitle =[NSString stringWithFormat:@"%ld",[[TTXUserInfo shareUserInfos].completeCount integerValue] + [[TTXUserInfo shareUserInfos].totalWaitCount integerValue]];
//    if ([self.yetComplete.alerTitle isEqualToString:@"0"]) {
//        self.yetComplete.showAlerLabel = NO;
//    }else{
//        self.yetComplete.showAlerLabel = YES;
//    }
    //已完成
//    self.waitShipp.alerTitle =[NSString stringWithFormat:@"%ld",[[TTXUserInfo shareUserInfos].completeCount integerValue]];
//    if ([self.waitShipp.alerTitle isEqualToString:@"0"]) {
//        self.waitShipp.showAlerLabel = NO;
//    }else{
//        self.waitShipp.showAlerLabel = YES;
//    }
    
    //待收货
    self.waitComment.alerTitle =[NSString stringWithFormat:@"%ld",[[TTXUserInfo shareUserInfos].waitConfirmCount integerValue]];
    if ([self.waitComment.alerTitle isEqualToString:@"0"]) {
        self.waitComment.showAlerLabel = NO;
    }else{
        self.waitComment.showAlerLabel = YES;
    }
    //钱包动态
    self.walltDynamic.alerTitle =[NSString stringWithFormat:@"%ld",[[TTXUserInfo shareUserInfos].withdrawCount integerValue] + [[TTXUserInfo shareUserInfos].feedbackCount integerValue]];
    self.walltDynamic.showAlerNumber = NO;
    if ([self.walltDynamic.alerTitle isEqualToString:@"0"]) {
        self.walltDynamic.showAlerLabel = NO;
    }else{
        self.walltDynamic.showAlerLabel = YES;
    }
    //提现
    self.bankManagement.alerTitle = [TTXUserInfo shareUserInfos].withdrawCount;
    self.bankManagement.showAlerNumber = NO;
    if ([[TTXUserInfo shareUserInfos].bindingFlag isEqualToString:@"1"]) {
        self.bankManagement.showAlerLabel = NO;
    }else{
        self.bankManagement.showAlerLabel = YES;
    }
}

#pragma mark - 获取我的等级

- (void)getMyGrade
{
    NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token};
    [HttpClient POST:@"user/grade" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
        if (IsRequestTrue) {
            [self setVipImage:[NullToNumber(jsonObject[@"data"][@"grade"]) integerValue]];
            [self.vip setTitle:[NSString stringWithFormat:@"VIP %@",NullToNumber(jsonObject[@"data"][@"grade"])] forState:UIControlStateNormal];
            [TTXUserInfo shareUserInfos].grade = NullToNumber(jsonObject[@"data"][@"grade"]);
            self.vipNumber.text = [NSString stringWithFormat:@"%@/%@",NullToNumber(jsonObject[@"data"][@"integral"]),NullToNumber(jsonObject[@"data"][@"nextIntegral"])];
            self.vipHelp.text = [NSString stringWithFormat:@"距离VIP%ld还有%@的成长值(1元＝1成长值)",[NullToNumber(jsonObject[@"data"][@"grade"]) integerValue] + 1,NullToNumber(jsonObject[@"data"][@"cutValue"])];
            CGFloat value= 0;
            value = [NullToNumber(jsonObject[@"data"][@"integral"]) doubleValue]/[NullToNumber(jsonObject[@"data"][@"nextIntegral"]) doubleValue];
            if ([NullToNumber(jsonObject[@"data"][@"grade"]) isEqualToString:@"10"]) {
                self.vipNumber.text = [NSString stringWithFormat:@"%@",NullToNumber(jsonObject[@"data"][@"integral"])];
                self.vipHelp.text = [NSString stringWithFormat:@"您的成长值已满(1元＝1成长值)"];
                value = 1.;
            }
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(0, 0, 0, self.vipView.bounds.size.height);
            view.backgroundColor =  [UIColor colorFromHexString:@"#ffd862"];
            for (UIView *vi in self.vipView.subviews) {
                [vi removeFromSuperview];
            }
            [self.vipView addSubview:view];
            view.layer.cornerRadius = self.vipView.bounds.size.height/2;
            view.layer.masksToBounds = YES;
            CGFloat width= 0;
            if (!isnan(value)) {
             width = self.vipView.bounds.size.width*value;
            }
            [UIView animateWithDuration:1.5 animations:^{
                view.frame = CGRectMake(0, 0, width, self.vipView.bounds.size.height);
            } completion:^(BOOL finished) {
            }];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)setVipImage:(NSInteger)grade
{
    grade +=1;
    switch (grade) {
        case 1:
        {
            self.vipStart.image = [UIImage imageNamed:@"icon_v0"];
            self.vipend.image = [UIImage imageNamed:@"icon_v1"];
        }
            
            break;
        case 2:
        {
            self.vipStart.image = [UIImage imageNamed:@"icon_v1"];
            self.vipend.image = [UIImage imageNamed:@"icon_v2"];
            
        }
            
            break;
        case 3:
        {
            self.vipStart.image = [UIImage imageNamed:@"icon_v2"];
            self.vipend.image = [UIImage imageNamed:@"icon_v3"];
            
        }
            
            break;
        case 4:
        {
            self.vipStart.image = [UIImage imageNamed:@"icon_v3"];
            self.vipend.image = [UIImage imageNamed:@"icon_v4"];
            
        }
            
            break;
        case 5:
        {

            self.vipStart.image = [UIImage imageNamed:@"icon_v4"];
            self.vipend.image = [UIImage imageNamed:@"icon_v5"];
            
        }
            
            break;
        case 6:
        {
            self.vipStart.image = [UIImage imageNamed:@"icon_v5"];
            self.vipend.image = [UIImage imageNamed:@"icon_v6"];
            
        }
            
            break;
        case 7:
        {
            self.vipStart.image = [UIImage imageNamed:@"icon_v6"];
            self.vipend.image = [UIImage imageNamed:@"icon_v7"];
            
        }
            
            break;
        case 8:
        {
            self.vipStart.image = [UIImage imageNamed:@"icon_v7"];
            self.vipend.image = [UIImage imageNamed:@"icon_v8"];
            
        }
            
            break;
        case 9:
        {
            self.vipStart.image = [UIImage imageNamed:@"icon_v8"];
            self.vipend.image = [UIImage imageNamed:@"icon_v9"];
            
        }
            
            break;
        case 10:
        {
            self.vipStart.image = [UIImage imageNamed:@"icon_v9"];
            self.vipend.image = [UIImage imageNamed:@"icon_v10"];
            
        }
            break;
        case 11:
        {
            self.vipStart.image = [UIImage imageNamed:@"icon_v9"];
            self.vipend.image = [UIImage imageNamed:@"icon_v10"];
            
        }
            break;
            
        default:
            break;
    }
    

}


#pragma mark - 点击头像

- (ChangeHeadImage *)changeIamge
{
    if (!_changeIamge) {
        _changeIamge = [[ChangeHeadImage alloc]init];
    }
    return _changeIamge;
}

- (void)changheadImage
{
    [self.changeIamge changheadImage];
}

#pragma mark - 加载头像

- (void)loadingHeadImage
{
    NSLog(@"--------%@",[TTXUserInfo shareUserInfos].avatar);
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[TTXUserInfo shareUserInfos].avatar] placeholderImage:[UIImage imageNamed:@"head_sculpture"] completed:NULL];
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:@"https://www.dmall.com/images/section1_img.jpg"] placeholderImage:BannerLoadingErrorImage];
}

#pragma mark - 修改昵称成功
- (void)eidtUserNameSuccess
{
    self.nameLabel.text = [TTXUserInfo shareUserInfos].nickName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)integralHelf:(UIButton *)sender {
}
-(void) functionItem:(HomeVerticalBtn*)item withImageNamed:(NSString*) imageName title:(NSString*)title{
    item.imageView.image = [UIImage imageNamed:imageName];
    item.textLabel.text = title;
}

#pragma mark - 查看订单
- (IBAction)checkAllOrder:(UIButton *)sender {
    OderListViewController *orderVC = [[OderListViewController alloc]init];
    orderVC.orderType = Order_type_all;
    [self.viewController.navigationController pushViewController:orderVC animated:YES];
}
//已完成
- (IBAction)yetComplete:(id)sender {
    OderListViewController *orderVC = [[OderListViewController alloc]init];
    orderVC.orderType = Order_type_yetComplet;
    [self.viewController.navigationController pushViewController:orderVC animated:YES];
}
//待收货
- (IBAction)waitShipp:(id)sender
{
    OderListViewController *orderVC = [[OderListViewController alloc]init];
    orderVC.orderType = Order_type_waitShipp;
    [self.viewController.navigationController pushViewController:orderVC animated:YES];
    
}
//待评论
- (IBAction)waitComment:(id)sender
{
    OderListViewController *orderVC = [[OderListViewController alloc]init];
    orderVC.orderType = Order_type_waitComment;
    [self.viewController.navigationController pushViewController:orderVC animated:YES];
}

- (NSDictionary *)bankCardInfo
{
    if (!_bankCardInfo) {
        _bankCardInfo = [NSDictionary dictionary];
    }
    return _bankCardInfo;
}


//去实名认证
- (IBAction)goRealNameBtn:(UIButton *)sender {
    RealNameAutViewController *realNVC = [[RealNameAutViewController alloc]init];
    realNVC.isYetAut = NO;
    [self.viewController.navigationController pushViewController:realNVC animated:YES];
}

//提现
- (IBAction)withDraw:(UIButton *)sender
{
    //首先判断用户时候已经实名认证
    if ([self gotRealNameRu:@"在您申请提现之前,请先进行实名认证"]){
        return;
    }
    //再判断是否绑定银行卡
    if (![[TTXUserInfo shareUserInfos].bindingFlag isEqualToString:@"1"]) {
        [self goBingdingBank:@"您还未绑定银行卡，请先绑定银行卡"];
    }
    //然后去进行提现
    WithDrewMoneyViewController *withDrewVC = [[WithDrewMoneyViewController alloc]init];
    [self.viewController.navigationController pushViewController:withDrewVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        BankCardManageViewController *bankcardVC = [[BankCardManageViewController alloc]init];
        bankcardVC.isYetBingdingCard = YES;
        bankcardVC.bankcardInfo = self.bankCardInfo;
        [self.viewController.navigationController pushViewController:bankcardVC animated:YES];
    }
}

//钱包动态
- (IBAction)walltDynamic:(id)sender
{
    WalletDymicViewController *walletDVC = [[WalletDymicViewController alloc]init];
    walletDVC.walletType = WalletDymic_type_yuE;
    [self.viewController.navigationController pushViewController:walletDVC animated:YES];
}

//银行卡管理
- (IBAction)bankManagement:(UIButton *)sender
{
    if ([self gotRealNameRu:@"在您管理您的银行卡之前，请先进行实名认证"]){
        return;
    }
    if ([[TTXUserInfo shareUserInfos].bindingFlag isEqualToString:@"1"]){
        sender.enabled = NO;
        NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token};
        [HttpClient GET:@"user/withdraw/bindBankcard/get" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
            if (IsRequestTrue) {
                BankCardManageViewController *bankcardVC = [[BankCardManageViewController alloc]init];
                bankcardVC.isYetBingdingCard = YES;
                bankcardVC.bankcardInfo = jsonObject[@"data"];
                [self.viewController.navigationController pushViewController:bankcardVC animated:YES];
            }
            sender.enabled = YES;
        }failure:^(NSURLSessionDataTask *operation, NSError *error) {
                    sender.enabled = YES;
                }];
        return;
    }
    BankCardManageViewController *bankcardVC = [[BankCardManageViewController alloc]init];
    bankcardVC.isYetRealnameAuthentication = YES;
    bankcardVC.realnameAuDic = @{@"name":[TTXUserInfo shareUserInfos].idcardName,
                                 @"idcardnumber":[TTXUserInfo shareUserInfos].idcard};
    [self.viewController.navigationController pushViewController:bankcardVC animated:YES];
}

#pragma mark - 设置模块

//推荐有礼
- (IBAction)recommend:(UIButton *)sender {
    MyInvitationViewController *invitationVC = [[MyInvitationViewController alloc]init];
    [self.viewController.navigationController pushViewController:invitationVC animated:YES];
}

//设置
- (IBAction)setBtn:(id)sender {
    SetViewController *setVC = [[SetViewController alloc]init];
    [self.viewController.navigationController pushViewController:setVC animated:YES];
}

//帮助
- (IBAction)helpBtn:(UIButton *)sender {
    HelpViewController *helpVC = [[HelpViewController alloc]init];
    [self.viewController.navigationController pushViewController:helpVC animated:YES];
}
//关于我们
- (IBAction)aboutUsBtn:(UIButton *)sender {
    AboutUsViewController *aboutsVC = [[AboutUsViewController alloc]init];
    [self.viewController.navigationController pushViewController:aboutsVC animated:YES];
}

//我的爱心账户
- (IBAction)mylvoeBtn:(UIButton *)sender {
    __weak MineTableViewCell *weak_self = self;
    NSDictionary *prams = @{@"token":[TTXUserInfo shareUserInfos].token};
    AFHTTPSessionManager *manager = [self defaultManager];
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:prams];
    NSString *url = [NSString stringWithFormat:@"%@%@",HttpClient_BaseUrl,@"user/donate/get"];
    
    [SVProgressHUD showWithStatus:@"正在请求数据..."];
    sender.enabled = NO;
   [manager POST:url parameters:mutalbleParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       sender.enabled = YES;
       [SVProgressHUD dismiss];
       @try {
           NSError *error = nil;
           //    id jsonObject = [responseObject objectFromJSONData];//
           id jsonObject=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
           NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:ResponseSerializerEncoding];
           NSString *err_string = [NSString stringWithFormat:@"json 格式错误.返回字符串：%@",responseString];
           NSAssert(error==nil, err_string);
           if ([NullToSpace(jsonObject[@"code"]) isEqualToString:@"0"]) {
               MyLoveAccountViewController *loveAccountVC = [[MyLoveAccountViewController alloc]init];
               if (![jsonObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                   return ;
               }
               loveAccountVC.loveAccountDic = jsonObject[@"data"];
               [weak_self.viewController.navigationController pushViewController:loveAccountVC animated:YES];
           }else if([NullToSpace(jsonObject[@"code"]) isEqualToString:@"2048"]){
               JoinLoveAccountViewController *joinVC = [[JoinLoveAccountViewController alloc]init];
               [self.viewController.navigationController pushViewController:joinVC animated:YES];
           }else{
               [[ JAlertViewHelper shareAlterHelper]showTint:NullToSpace(jsonObject[@"message"] )duration:2.0];
           }
       } @catch (NSException *exception) {
           
       } @finally {
           
       }

    
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       sender.enabled = YES;
       [SVProgressHUD dismiss];
       [[JAlertViewHelper shareAlterHelper]showTint:@"网络请求错误，请稍后重试..." duration:2.];

   }];

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



#pragma mark - 去进行实名认证
- (BOOL)gotRealNameRu:(NSString *)alerTitle
{
    if (![TTXUserInfo shareUserInfos].identityFlag) {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"重要提示" message:alerTitle preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //去进行实名认证
            RealNameAutViewController *realNVC = [[RealNameAutViewController alloc]init];
            realNVC.isYetAut = NO;
            [self.viewController.navigationController pushViewController:realNVC animated:YES];
        }];
        [alertcontroller addAction:cancelAction];
        [alertcontroller addAction:otherAction];
        [self.viewController presentViewController:alertcontroller animated:YES completion:NULL];
        return YES;
    }
    return NO;
}


#pragma mark - 去绑定银行卡
- (void)goBingdingBank:(NSString *)alerTitle
{
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"重要提示" message:alerTitle preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //去绑定银行卡
            BankCardManageViewController *bankcardVC = [[BankCardManageViewController alloc]init];
            bankcardVC.isYetRealnameAuthentication = YES;
            bankcardVC.realnameAuDic = @{@"name":[TTXUserInfo shareUserInfos].idcardName,
                                         @"idcardnumber":[TTXUserInfo shareUserInfos].idcard};
            [self.viewController.navigationController pushViewController:bankcardVC animated:YES];
        }];
        [alertcontroller addAction:cancelAction];
        [alertcontroller addAction:otherAction];
        [self.viewController presentViewController:alertcontroller animated:YES completion:NULL];
}

#pragma mark - 百度广告
- (void)addAdView {
    //lp颜色配置
    CGFloat height = TWitdh*(963/750.) + 385 + 44;
    
    [BaiduMobAdSetting setLpStyle:BaiduMobAdLpStyleDefault];
    //使用嵌入广告的方法实例。
    sharedAdView = [[BaiduMobAdView alloc] init];
    sharedAdView.AdUnitTag = @"2959722";
    sharedAdView.AdType = BaiduMobAdViewTypeBanner;
    CGFloat bannerY = height - 0.15*TWitdh;
    sharedAdView.frame = CGRectMake(0, bannerY, TWitdh, 0.15*TWitdh);
    [self.contentView addSubview:sharedAdView];
    sharedAdView.delegate = self;
    [sharedAdView start];
    
}

- (NSString *)publisherId
{
    return  @"dad9db17"; //@"your_own_app_id";注意，iOS和android的app请使用不同的app ID
}
-(BOOL) enableLocation
{
    //启用location会有一次alert提示
    return YES;
}

-(void) willDisplayAd:(BaiduMobAdView*) adview
{
    NSLog(@"delegate: will display ad");
}

-(void) failedDisplayAd:(BaiduMobFailReason) reason;
{
    NSLog(@"delegate: failedDisplayAd %d", reason);
}

- (void)didAdImpressed {
    NSLog(@"delegate: didAdImpressed");
    
}

- (void)didAdClicked {
    NSLog(@"delegate: didAdClicked");
}

- (void)didAdClose {
    NSLog(@"delegate: didAdClose");
}


@end
