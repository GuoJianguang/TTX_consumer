//
//  WithDrewSuccessView.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/9.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "WithDrewSuccessView.h"

@interface WithDrewSuccessView()
@property (nonatomic, strong)MoView *anmintionView;

@end

@implementation WithDrewSuccessView

- (void)awakeFromNib
{
    self.titleLabel.textColor = MacoTitleColor;
    
    self.money.textColor = self.tixianLabel.textColor = self.timeLabel.textColor = self.time.textColor = MacoDetailColor;
    self.alerLabel.textColor =self.alertimeLabel.textColor = MacoColor;
    self.backgroundColor = MacoGrayColor;
    
    UIImage *image = [UIImage imageNamed:@"bg_mine_certification_success"];
    image= [image resizableImageWithCapInsets:UIEdgeInsetsMake(100, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    self.bgimageView.image  = image;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"WithDrewSuccessView" owner:nil options:nil][0];
        self.anmintionView = [[MoView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.succesView addSubview:self.anmintionView];
        
        self.anmintionView.center = CGPointMake(CGRectGetWidth(self.succesView.frame)/2, CGRectGetHeight(self.succesView.frame)/2);
        self.anmintionView.backgroundColor = MacoColor;
        self.anmintionView.layer.cornerRadius = CGRectGetHeight(self.anmintionView.bounds)/2;
        self.anmintionView.layer.masksToBounds = YES;
//        [self buttonAction];
        
        
    }
    return self;
}

- (void)buttonAction
{
    if (self.anmintionView) {
        [self.anmintionView startLoading];
        
//        [self performSelector:@selector(success) withObject:nil afterDelay:1.];
        [self success];

    }
}

- (void)success
{
    [self.anmintionView success:^{
        
    }];
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    _infoDic = infoDic;
    self.money.text = [NSString stringWithFormat:@"%.2f元",[_infoDic[@"money"] doubleValue]];
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    self.time.text = dateString;
    
}

- (IBAction)backBtn:(id)sender {
    [(UINavigationController *)self.viewController popViewControllerAnimated:YES];
    [self removeFromSuperview];
}
@end
