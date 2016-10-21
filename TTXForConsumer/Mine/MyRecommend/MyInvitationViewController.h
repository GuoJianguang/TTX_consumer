//
//  MyInvitationViewController.h
//  天添薪
//
//  Created by ttx on 16/1/11.
//  Copyright © 2016年 ttx. All rights reserved.
//


@interface RecommendMerchantModel : BaseModel
/**
 * 商户号
 */
@property (nonatomic,copy)NSString *mchCode;
/**
 * 商户名
 */
@property (nonatomic, copy)NSString *mchName;

@end

@interface MyInvitationViewController : BaseViewController

//显示商家列表的view
@property (nonatomic, strong)UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

- (IBAction)select_btn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *invitationBtn;

- (IBAction)invitationBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (weak, nonatomic) IBOutlet UILabel *mchLabel;

@property (weak, nonatomic) IBOutlet UIView *invitationView;


@property (weak, nonatomic) IBOutlet UILabel *shouyiLabel;

@property (weak, nonatomic) IBOutlet UILabel *alerLabel;


@end
