//
//  TTXUserInfo.m
//  天添薪
//
//  Created by ttx on 16/1/6.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "TTXUserInfo.h"

static TTXUserInfo *instance;


@implementation TTXUserInfo


+ (TTXUserInfo *)shareUserInfos
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TTXUserInfo alloc]init];
    });
    return instance;
}

- (NSDictionary *)notificationParms
{
    if (!_notificationParms) {
        _notificationParms = [NSDictionary dictionary];
    }
    return _notificationParms;
}

- (void)setUserinfoWithdic:(NSDictionary *)dic
{
    instance.avatar = NullToSpace(dic[@"avatar"]);
    instance.aviableBalance = NullToNumber(dic[@"aviableBalance"]);
    instance.city = NullToSpace(dic[@"city"]);
    instance.userid = NullToSpace(dic[@"id"]);
    instance.nickName = NullToSpace(dic[@"nickName"]);
    instance.province = NullToSpace(dic[@"province"]);
    instance.token = NullToSpace(dic[@"token"]);
    instance.totalConsumeAmount = NullToNumber(dic[@"totalConsumeAmount"]);
    instance.totalExpectAmount = NullToNumber(dic[@"totalExpectAmount"]);
    instance.zone = NullToSpace(dic[@"zone"]);
    instance.phone = NullToSpace(dic[@"phone"]);
    
    instance.bindingFlag = NullToNumber(dic[@"bindingFlag"]);
    instance.grade = NullToNumber(dic[@"grade"]);
    instance.integral = NullToNumber(dic[@"integral"]);
    instance.bankAccount = NullToSpace(dic[@"bankAccount"]);
    instance.bankAccountRealName = NullToSpace(dic[@"bankAccountRealName"]);
    
    instance.completeCount = NullToNumber(dic[@"completeCount"]);
    instance.totalWaitCount = NullToNumber(dic[@"totalWaitCount"]);
    instance.messageCount = NullToNumber(dic[@"messageCount"]);
    instance.withdrawCount = NullToNumber(dic[@"withdrawCount"]);
    instance.feedbackCount = NullToNumber(dic[@"feedbackCount"]);
    instance.orderCount = NullToNumber(dic[@"orderCount"]);
    instance.waitDeleverCount = NullToNumber(dic[@"waitDeleverCount"]);
    instance.waitConfirmCount = NullToNumber(dic[@"waitConfirmCount"]);
    instance.unPayOrderCount = NullToNumber(dic[@"unPayOrderCount"]);
    instance.idcard = NullToSpace(dic[@"idcard"]);
    instance.idcardName = NullToSpace(dic[@"idcardName"]);
    instance.consumeBalance = NullToNumber(dic[@"consumeBalance"]);

    
    NSString *notPay = NullToNumber(dic[@"notConsumeDays"]);
    instance.notConsumeDays = [notPay integerValue];
    if ([NullToNumber(dic[@"identityFlag"]) isEqualToString:@"1"]) {
        instance.identityFlag = YES;
    }else{
        instance.identityFlag = NO;
    }
    
    if ([NullToNumber(dic[@"idVerifyReqFlag"]) isEqualToString:@"1"]) {
        instance.idVerifyReqFlag = YES;
    }else{
        instance.idVerifyReqFlag = NO;
    }
    
    instance.wiatJoinAmunt = NullToNumber(dic[@"waitJoinAmount"]);
    
    if ([dic[@"unreadMsgCountVo"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *unreadMsgCountVo = dic[@"unreadMsgCountVo"];
        instance.feedbackCount = NullToNumber(unreadMsgCountVo[@"feedbackCount"]);
        instance.messageCount = NullToNumber(unreadMsgCountVo[@"messageCount"]);
//        instance.orderCount = NullToNumber(unreadMsgCountVo[@"orderCount"]);
        instance.withdrawCount = NullToNumber(unreadMsgCountVo[@"withdrawCount"]);
        instance.waitDeleverCount = NullToNumber(unreadMsgCountVo[@"waitDeliverCount"]);
        instance.waitConfirmCount = NullToNumber(unreadMsgCountVo[@"waitConfirmCount"]);
        instance.unPayOrderCount = NullToNumber(unreadMsgCountVo[@"unPayorderCount"]);
        instance.completeCount = NullToNumber(unreadMsgCountVo[@"completeCount"]);
        instance.totalWaitCount = NullToNumber(unreadMsgCountVo[@"totalWaitCount"]);
    }
//    instance.waitDeleverCount = @"2";
//    instance.waitConfirmCount = @"3";
//    instance.unPayOrderCount = @"5";
    
}

- (NSString *)locationCity
{
    if (!_locationCity) {
        _locationCity = [NSString string];
        _locationCity = @"";
    }
    return _locationCity;
}

#pragma mark - 设置渐变色
+ (void)setjianpianColorwithView:(UIView *)backView withWidth:(CGFloat )width withHeight:(CGFloat)height
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0 , 0,width, height);
    
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    
    UIColor *statColor = [UIColor colorWithRed:244/255. green:91/255. blue:80/255. alpha:1.];
    UIColor *endColor = [UIColor colorWithRed:244/255. green:165/255. blue:80/255. alpha:1.];
    
    
    gradient.colors = [NSArray arrayWithObjects:
                       (id)statColor.CGColor,
                       (id)endColor.CGColor,
                       nil];
    [backView.layer insertSublayer:gradient atIndex:0];
}


@end
