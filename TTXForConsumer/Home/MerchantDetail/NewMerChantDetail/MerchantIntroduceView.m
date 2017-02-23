//
//  MerchantIntroduceView.m
//  TTXForConsumer
//
//  Created by Guo on 2017/2/20.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import "MerchantIntroduceView.h"
#import "BussessDetailModel.h"
#import "BussessMapViewController.h"

@interface MerchantIntroduceView()<UIActionSheetDelegate>

@end

@implementation MerchantIntroduceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MerchantIntroduceView" owner:nil options:nil][0];
        self.introduceLabel.textColor = MacoDetailColor;
        self.phoneNum.textColor = self.address.textColor = self.jisaoLabel.textColor  =  MacoTitleColor;

    }
    
    return self;
}

- (void)setDataModel:(BussessDetailModel *)dataModel
{
    _dataModel = dataModel;
    //电话
    self.phoneNum.text = _dataModel.phone;
    self.address.text = _dataModel.address;
    
    self.introduceHeight.constant  = [self cellHeight:_dataModel.desc]+ 55. + 25.;

    //介绍
    self.introduceLabel.text = _dataModel.desc;
    if ([_dataModel.desc isEqualToString:@""]) {
        self.introdouceView.hidden = YES;
    }
}

#pragma mark - 计算cell的高度
- (CGFloat)cellHeight:(NSString *)textSting
{
    CGSize size = [textSting boundingRectWithSize:CGSizeMake(TWitdh  - 30, 0) font:[UIFont systemFontOfSize:13]];
    return size.height;
}

#pragma mark - 拨打电话
- (IBAction)phoneBtn:(UIButton *)sender {
    
    if ([self.dataModel.phone containsString:@","]) {
        NSArray *arry =   [self.dataModel.phone componentsSeparatedByString:@","];
        
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"拨打商家电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
        for (int i = 0; i < arry.count; i ++) {
            [sheet addButtonWithTitle:arry[i]];
        }
        [sheet showInView:self.viewController.view];
    }else{
        //只有一个电话号码
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.dataModel.phone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.viewController.view addSubview:callWebview];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)address:(UIButton *)sender {
    
    BussessMapViewController *mapVC = [[BussessMapViewController alloc]init];
    
    CLLocationCoordinate2D d;
    d.latitude = [self.dataModel.latitude floatValue];
    d.longitude = [self.dataModel.longitude floatValue];
    
    if (d.longitude == 0 || d.latitude == 0) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"该商户暂时没有位置信息" duration:1.5];
        return;
    }
    
    mapVC.destinationCoordinate = d;
    mapVC.dataModel = self.dataModel;
    [self.viewController.navigationController pushViewController:mapVC animated:YES];
}

@end
