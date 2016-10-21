//
//  HomeBannerTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/16.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomenBannerModel : BaseModel
/**
 * id
 */
@property (nonatomic, copy)NSString  *bannerId;
/**
 * 跳转方式（1：APP商户详情 2：APP产品详情 3：网页）
 */
@property (nonatomic, copy)NSString  *jumpWay;
/**
 * 跳转参数值
 */
@property (nonatomic, copy)NSString  *jumpValue;
/**
 * 图片
 */
@property (nonatomic, copy)NSString  *pic;


@end

@interface  ActivityModel: BaseModel

@property (nonatomic, copy)NSString *seqId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *coverImg;
@property (nonatomic, copy)NSString *sort;

@end


@interface HomeBannerTableViewCell: BaseTableViewCell

//天添薪特卖更多
- (IBAction)temaiBtn:(UIButton *)sender;


//精品推荐更多
- (IBAction)recommendedMort:(id)sender;

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;

//pageView
//@property (weak, nonatomic) IBOutlet HomeImageSwitchIndicatorView *pageView;

@property (weak, nonatomic) IBOutlet TTXPageContrl *pageView;

#pragma mark - 活动
@property (weak, nonatomic) IBOutlet UIImageView *activityImage1;
- (IBAction)activity1Btn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *activityImage2;
-(IBAction)activity2Btn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *activityImage3;
-(IBAction)activity3Btn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *activityImage4;
-(IBAction)activity4Btn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *activityImage5;
-(IBAction)activity5Btn:(UIButton *)sender;


//用于判断第五个活动到底展示还是不展示

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveActivityHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveTop;

@property (weak, nonatomic) IBOutlet UIView *fiveView;
#pragma mark - 天添薪特卖

@property (weak, nonatomic) IBOutlet UILabel *specialLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *specialImage1;

- (IBAction)special1Btn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *specialLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *specialImage2;

- (IBAction)special2Btn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *specialLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *specialImage3;
- (IBAction)special3Btn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *moreGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *temaiLabel;

@property (weak, nonatomic) IBOutlet UILabel *moremchLabel;

@property (weak, nonatomic) IBOutlet UILabel *jinmingTuijianLabel;

//不让每次都刷新
@property (nonatomic, assign)BOOL isAlreadyRefrefsh;

@end
