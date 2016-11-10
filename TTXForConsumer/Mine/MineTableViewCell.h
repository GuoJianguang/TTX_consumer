//
//  MineTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/21.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVerticalBtn.h"



@interface MineTableViewCell : BaseTableViewCell

#pragma mark - 个人信息
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *backTotal;
@property (weak, nonatomic) IBOutlet UIButton *integralHelp;
- (IBAction)integralHelf:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *alerLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alerTop;

#pragma mark - 积分
@property (weak, nonatomic) IBOutlet UIButton *vip;

@property (weak, nonatomic) IBOutlet UIView *vipView;

@property (weak, nonatomic) IBOutlet UILabel *vipNumber;
@property (weak, nonatomic) IBOutlet UIImageView *vipStart;
@property (weak, nonatomic) IBOutlet UIImageView *vipend;
@property (weak, nonatomic) IBOutlet UILabel *vipHelp;

#pragma mark - 我的资产

//账户余额
@property (weak, nonatomic) IBOutlet UILabel *accountBalance;
//待回馈金额
@property (weak, nonatomic) IBOutlet UILabel *WaitCashbackAmount;
//总消费金额
@property (weak, nonatomic) IBOutlet UILabel *totalConsumeAmount;

@property (weak, nonatomic) IBOutlet UIImageView *mineBgIamge;

@property (weak, nonatomic) IBOutlet UILabel *myloveLabel;

#pragma mark - 我的订单
- (IBAction)checkAllOrder:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet HomeVerticalBtn *yetComplete;

- (IBAction)yetComplete:(id)sender;

@property (weak, nonatomic) IBOutlet HomeVerticalBtn *waitShipp;
- (IBAction)waitShipp:(id)sender;
@property (weak, nonatomic) IBOutlet HomeVerticalBtn *waitComment;
- (IBAction)waitComment:(id)sender;

#pragma mark - 我的钱包
@property (weak, nonatomic) IBOutlet HomeVerticalBtn *withDraw;
- (IBAction)withDraw:(id)sender;

@property (weak, nonatomic) IBOutlet HomeVerticalBtn *walltDynamic;
- (IBAction)walltDynamic:(id)sender;

@property (weak, nonatomic) IBOutlet HomeVerticalBtn *bankManagement;
- (IBAction)bankManagement:(id)sender;

#pragma mark - 设置
- (IBAction)recommend:(UIButton *)sender;

- (IBAction)setBtn:(id)sender;
- (IBAction)helpBtn:(UIButton *)sender;

- (IBAction)aboutUsBtn:(UIButton *)sender;

- (IBAction)mylvoeBtn:(UIButton *)sender;


#pragma mark - 加载头像

- (void)loadingHeadImage;
- (void)searchUserInfor;
- (void)getMyGrade;


#pragma mark - 需要设置的字体颜色

@property (weak, nonatomic) IBOutlet UILabel *myzichan;

@property (weak, nonatomic) IBOutlet UILabel *myorderLabel;

@property (weak, nonatomic) IBOutlet UILabel *myWalletLabel;

@property (weak, nonatomic) IBOutlet UILabel *mytuijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *mySetLabel;
@property (weak, nonatomic) IBOutlet UILabel *myHelpLabel;

@property (weak, nonatomic) IBOutlet UILabel *myAboutLabel;


@property (nonatomic, strong)NSDictionary *bankCardInfo;

@property (weak, nonatomic) IBOutlet UIButton *goRealNameBtn;

- (IBAction)goRealNameBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *yetRealName;



@end
