//
//  DiscoveryWaitTableViewCell.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/17.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "DiscoveryWaitTableViewCell.h"
#import "CountDown.h"
#import "DiscoveryDetailViewController.h"

@interface DiscoveryWaitTableViewCell()

@property (strong, nonatomic)  CountDown *countDown;

@property (nonatomic, strong)NSTimer *activeTimer;

@end

@implementation DiscoveryWaitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.disCoveryName.textColor = MacoTitleColor;
    self.changeLabel.textColor = self.timeLabel.textColor = MacoDetailColor;
    self.stateLabel.textColor = MacoColor;
    self.progressView.layer.borderColor = [UIColor colorFromHexString:@"#ffd862"].CGColor;
    self.progressView.layer.borderWidth = 1;
    self.progressView.layer.cornerRadius = TWitdh*(12/1500.);
    self.progressView.progressTintColor = [UIColor colorFromHexString:@"#ffd862"];
    self.progressView.trackTintColor = [UIColor whiteColor];
    self.luckyDrawBtn.backgroundColor = MacoPriceColor;
    self.luckyDrawBtn.layer.cornerRadius = 5;
    self.luckyDrawBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)luckyDrawBtn:(id)sender {
    
    NSLog(@"luckyDraw");
    [(DiscoveryDetailViewController *)self.viewController buyLuckyDarw:self.dataModel.detailId] ;
    
}

- (CountDown *)countDown
{
    if (!_countDown) {
        _countDown = [[CountDown alloc]init];
    }
    return _countDown;
}


- (void)setDataModel:(DiscoveryDeatailModel *)dataModel
{
    _dataModel = dataModel;
    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImg] placeholderImage:LoadingErrorImage];
    self.disCoveryName.text = _dataModel.productName;
    self.changeLabel.text = [NSString stringWithFormat:@"限量%@次机会，还剩%@次机会",_dataModel.endCountNum,_dataModel.countNum];
    
    self.progressView.progress = 1- [_dataModel.countNum doubleValue]/[_dataModel.endCountNum doubleValue];
    NSTimeInterval interval=[_dataModel.endTime doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    
    self.timeLabel.text = timeStr;
    
    switch ([_dataModel.zoneFlag integerValue]) {
        case 1:
            self.stateLabel.text = [NSString stringWithFormat:@"余额%@元/次",_dataModel.payAmount];
            break;
        case 2:
            self.stateLabel.text = [NSString stringWithFormat:@"待回馈金额%@元/次",_dataModel.payAmount];
            break;
            
        default:
            break;
    }
    __weak DiscoveryWaitTableViewCell *weak_self = self;
    [self.countDown countDownWithPER_SECBlock:^{
       weak_self.timeLabel.text =  [weak_self getNowTimeWithString:timeStr];
    }];
    
}

#pragma mark - 倒计时计数
-(NSString *)getNowTimeWithString:(NSString *)aTimeString{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [NSDate date];
    // 当前时间字符串格式
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [formater dateFromString:nowDateStr];
    
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        self.luckyDrawBtn.backgroundColor = [UIColor grayColor];
        self.luckyDrawBtn.alpha = 0.7;
        [self.luckyDrawBtn setTitle:@"已结束" forState:UIControlStateNormal];
        return @"活动已经结束！";
    }else{
        self.luckyDrawBtn.backgroundColor = MacoPriceColor;
        self.luckyDrawBtn.enabled = YES;

    }
    if (days) {
        return [NSString stringWithFormat:@"还剩%@天%@小时%@分%@秒", dayStr,hoursStr, minutesStr,secondsStr];
    }
    return [NSString stringWithFormat:@"还剩%@小时%@分%@秒",hoursStr , minutesStr,secondsStr];
}



@end
