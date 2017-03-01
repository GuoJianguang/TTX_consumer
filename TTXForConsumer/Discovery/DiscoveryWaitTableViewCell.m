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

@property (nonatomic, assign)NSTimeInterval tempTime;

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
    self.tempTime = 0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)luckyDrawBtn:(id)sender {
    
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
    
    NSTimeInterval interval=[_dataModel.endTime longLongValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    __weak DiscoveryWaitTableViewCell *weak_self = self;
    NSTimeInterval nowInterval= _dataModel.systmTime/1000;
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:nowInterval];
    self.tempTime =[date timeIntervalSinceDate:nowDate];
    [self.countDown countDownWithPER_SECBlock:^{
        [weak_self getNowTimeWithStringEndTime];
        weak_self.tempTime --;
    }];
}

#pragma mark - 倒计时计数
-( void)getNowTimeWithStringEndTime{
    
    
    int days = (int)(self.tempTime/(3600*24));
    int hours = (int)((self.tempTime-days*24*3600)/3600);
    int minutes = (int)(self.tempTime-days*24*3600-hours*3600)/60;
    int seconds = self.tempTime-days*24*3600-hours*3600-minutes*60;
    
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
        [self.countDown destoryTimer];
        self.timeLabel.text = @"活动已结束";
        [self.countDown destoryTimer];
        return;
    }
    if (days) {
        self.timeLabel.text = [NSString stringWithFormat:@"还剩%@天%@小时%@分%@秒结束", dayStr,hoursStr, minutesStr,secondsStr];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"还剩%@小时%@分%@秒结束",hoursStr , minutesStr,secondsStr];
}

@end
