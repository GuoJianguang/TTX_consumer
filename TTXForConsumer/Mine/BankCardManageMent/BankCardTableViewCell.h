//
//  BankCardTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/22.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIView *view2;

@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UIView *view4;

@property (weak, nonatomic) IBOutlet UIView *view5;

@property (weak, nonatomic) IBOutlet UIView *view6;

@property (weak, nonatomic) IBOutlet UIView *view7;

@property (weak, nonatomic) IBOutlet UIView *view8;

@property (weak, nonatomic) IBOutlet UIView *view9;

@property (weak, nonatomic) IBOutlet UIView *view10;


@property (weak, nonatomic) IBOutlet UITextField *bankCardNu;
@property (weak, nonatomic) IBOutlet UITextField *bankLabel;
- (IBAction)banLabelBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *provincesTF;
- (IBAction)provincesBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idCardNUTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *kaihuhangTF;
@property (weak, nonatomic) IBOutlet UITextField *kaihuhangNumdTF;
@property (weak, nonatomic) IBOutlet UITextField *wangdianTF;
- (IBAction)kaihuhangBtn:(UIButton *)sender;
- (IBAction)kaihuwangdianBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *inputKaihuhangTF;

@property (weak, nonatomic) IBOutlet UIView *wandiangView;

@property (weak, nonatomic) IBOutlet UIView *kaihuhangView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wangdianHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kaiHuHangHeight;





#pragma mark - 是否手动输入支行号
@property (weak, nonatomic) IBOutlet UIButton *selcetZHNumBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhNumBtnHeight;
- (IBAction)selcetZHNumBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *zhihangView;

@property (weak, nonatomic) IBOutlet UITextField *zhihangTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhiHangViewH;


#pragma mark - 已绑定时候的数据
@property (nonatomic, strong)NSDictionary *bankcardinfo;
//是否已经绑定银行卡
@property (nonatomic, assign)BOOL isYetBingdingCard;

//是否从实名认证传入过来
@property (nonatomic, assign)BOOL isYetRealnameAuthentication;
@property (nonatomic, strong)NSDictionary *realnameAuDic;



@property (weak, nonatomic) IBOutlet UIButton *bingdingBtn;

- (IBAction)bingdingBtn:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIView *editView;

@property (weak, nonatomic) IBOutlet UIButton *deletBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)saveBtn:(UIButton *)sender;

- (IBAction)deletBtn:(UIButton *)sender;

@property (nonatomic, assign)BOOL isEdit;



@end
