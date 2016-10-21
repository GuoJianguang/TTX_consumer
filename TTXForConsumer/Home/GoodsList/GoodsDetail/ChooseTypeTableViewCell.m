//
//  ChooseTypeTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/28.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "ChooseTypeTableViewCell.h"
#import "TypeView.h"
#import "GoodsDetailNewViewController.h"
#import "Watch.h"
#import "GoodsDetailNewViewController.h"

@interface ChooseTypeTableViewCell()<TypeSeleteDelegete>
//不同规格下请求商品价格的参数
@property (nonatomic, strong)NSMutableDictionary *priceParms;

@end

@implementation ChooseTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.goodsPrice.textColor = MacoColor;
    self.kuaidi.textColor = MacoDetailColor;
    self.goodsName.textColor = MacoTitleColor;
    
    self.numberTF.layer.borderWidth = 1;
    self.numberTF.layer.borderColor = MacoIntrodouceColor.CGColor;
    self.addBtn.layer.borderWidth = 1;
    [self.addBtn setTitleColor:MacoIntrodouceColor forState:UIControlStateNormal];
    self.addBtn.layer.borderColor = MacoIntrodouceColor.CGColor;
    self.minusBtn.layer.borderWidth = 1;
    self.minusBtn.layer.borderColor = [UIColor colorFromHexString:@"c8c8c8"].CGColor;
    [self.minusBtn setTitleColor:[UIColor colorFromHexString:@"c8c8c8"] forState:UIControlStateNormal];
    self.numberTF.textColor = MacoDetailColor;
    self.numberTF.text = @"1";
    
    self.yetSelectLabel = [[UILabel alloc]init];
}


- (NSMutableDictionary *)priceParms
{
    if (!_priceParms) {
        _priceParms = [NSMutableDictionary dictionary];
    }
    return _priceParms;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataModel:(Watch *)dataModel
{
    _dataModel = dataModel;
//    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计: %.2f元",[_dataModel.price doubleValue] + [_dataModel.freight doubleValue]];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImage] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
    self.goodsPrice.text = [NSString stringWithFormat:@"￥ %.2f",[_dataModel.price doubleValue]];
    self.kuaidi.text = [NSString stringWithFormat:@"快递:%@元",_dataModel.freight];
    self.goodsName.text = _dataModel.name;
    
//    if (!_dataModel.inventoryFlag) {
//        self.kucunLabel.text = [NSString stringWithFormat:@"库存:%@",@"无货"];
//    }else{
//        self.kucunLabel.text = [NSString stringWithFormat:@"库存:%@",@"有货"];
//    }
    if ([_dataModel.freight isEqualToString:@"0"]) {
        self.kuaidi.text = @"邮费: 包邮";
    }

}

- (IBAction)deletBtn:(UIButton *)sender {

    [((GoodsDetailNewViewController *)self.viewController).choosetypeView removeFromSuperview];
}

- (void)setGuigeArray:(NSArray *)guigeArray
{
    _guigeArray =guigeArray;
    
    if (_guigeArray.count ==0 ) {
        self.dataModel.actualPrice = [self.dataModel.price doubleValue];
        //        [self getGoodsPrice];
        self.yetSelectLabel.text = [NSString stringWithFormat:@"已选: "];
        return;
    }
    CGFloat numbertop = 0;
    for (int i = 0; i < guigeArray.count; i ++) {
        TypeView *view = [[TypeView alloc]initWithFrame:CGRectMake(0, TWitdh/(15/4.5) + 15, TWitdh, 50) andDatasource:_guigeArray[i][@"specList"] :_guigeArray[i][@"specAttr"]];
        view.tag = i + 10;
        view.delegate = self;
        [self.contentView addSubview:view];
        if (i>0) {
            CGFloat viewY = CGRectGetMaxY([self.contentView viewWithTag:view.tag-1].frame);
            view.frame = CGRectMake(0, viewY, TWitdh, view.height);
        }
        view.bounds = CGRectMake(0, 0, TWitdh, view.height);
        numbertop += view.height;
    }
    self.numberViewTap.constant = numbertop;
    
    
    //请求当前商品价格
    NSString *temp = [NSString string];
    
    for (NSDictionary *dic in _guigeArray) {
        [self.priceParms setObject:dic[@"specList"][0] forKey:dic[@"specAttr"]];
        temp =  [temp stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"specList"][0]]];
    }
    if (![temp isEqualToString:@""]) {
        temp  = [temp substringFromIndex:1];
        
    }
    self.yetSelectLabel.text = [NSString stringWithFormat:@"已选: %@",temp];
    [self getGoodsPrice];


}

- (void)btn:(UIButton *)button withIndex:(int)tag
{
    for (id  btn in button.superview.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            ((UIButton *) btn).selected = NO;
            ((UIButton *) btn).backgroundColor = [UIColor whiteColor];
            ((UIButton *) btn).layer.borderColor = MacoIntrodouceColor.CGColor;
        }
    }
    button.selected= YES;
    button.backgroundColor = MacoColor;
    button.layer.borderColor = MacoColor.CGColor;
    
    //设置请求当前已选中商品价格的参数
    NSString *temp = [NSString string];
    for (NSDictionary *dic in self.guigeArray) {
        for (NSString *str in dic[@"specList"]) {
            if ([button.titleLabel.text isEqualToString:str]) {
                temp = dic[@"specAttr"];
                break;
            }
        }
    }
    
    [self.priceParms setObject:button.titleLabel.text forKey:temp];
    NSString *tempSelectStr = [NSString string];
    for (NSString *str in self.priceParms.allValues) {
        tempSelectStr =  [tempSelectStr stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
    }
    if (![tempSelectStr isEqualToString:@""]) {
        tempSelectStr  = [tempSelectStr substringFromIndex:1];
    }
    self.yetSelectLabel.text = [NSString stringWithFormat:@"已选: %@",tempSelectStr];
    //请求当前已选中规格商品价格
    [self getGoodsPrice];
}

#pragma mark - 数量的加减
- (IBAction)addBtn:(UIButton *)sender {
    
    self.minusBtn.layer.borderColor = MacoIntrodouceColor.CGColor;
    [self.minusBtn setTitleColor:MacoIntrodouceColor forState:UIControlStateNormal];
    self.numberTF.text =[NSString stringWithFormat:@"%ld",[self.numberTF.text integerValue]+1];
    CGFloat totalMoney = [self.numberTF.text integerValue]* self.dataModel.actualPrice + [_dataModel.freight doubleValue];
//    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计: %.2f元",totalMoney];
}


- (IBAction)minusBtn:(UIButton *)sender {
    
    if ([self.numberTF.text integerValue]== 2) {
        self.minusBtn.layer.borderColor = [UIColor colorFromHexString:@"c8c8c8"].CGColor;
        [self.minusBtn setTitleColor:[UIColor colorFromHexString:@"c8c8c8"] forState:UIControlStateNormal];
    }
    if ([self.numberTF.text integerValue] < 2 ) {
        return;
    }
    self.numberTF.text =[NSString stringWithFormat:@"%ld",[self.numberTF.text integerValue]-1];
    CGFloat totalMoney = [self.numberTF.text integerValue]* self.dataModel.actualPrice + [_dataModel.freight doubleValue];
//    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计: %.2f元",totalMoney];
}



#pragma mark - 请求不同规格下的商品价格
- (void)getGoodsPrice
{
    NSDictionary *dic = @{@"id":self.dataModel.mch_id,
                        @"specs":self.priceParms};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *prams = @{@"reqData":json};
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpClient POST:@"shop/goodsPrice/get" parameters:prams success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        [SVProgressHUD dismiss];
        if (IsRequestTrue) {
            self.goodsPrice.text = [NSString stringWithFormat:@"￥ %.2f",[NullToNumber(jsonObject[@"data"][@"price"]) doubleValue]];
            //            [self.mchImage sd_setImageWithURL:[NSURL URLWithString:NullToSpace(jsonObject[@"data"][@"coverImage"])] placeholderImage:LoadingErrorImage options:SDWebImageRefreshCached];
            CGFloat totalMoney = [self.numberTF.text integerValue]* [NullToNumber(jsonObject[@"data"][@"price"]) doubleValue] + [_dataModel.freight doubleValue];
            self.dataModel.priceId = NullToSpace(jsonObject[@"data"][@"priceId"]);
            self.dataModel.actualPrice = [NullToNumber(jsonObject[@"data"][@"price"]) doubleValue];
//            self.totalPriceLabel.text = [NSString stringWithFormat:@"总计: %.2f元",totalMoney];
            if (![NullToSpace(jsonObject[@"data"][@"priceId"]) isEqualToString:@""]) {
                [((GoodsDetailNewViewController *)self.viewController) setOrderViewSureBtn:YES];
            }else{
                [((GoodsDetailNewViewController *)self.viewController) setOrderViewSureBtn:NO];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        self.dataModel.actualPrice = [self.dataModel.price doubleValue];
//        [((BaseMchViewController *)self.viewController) setOrderViewSureBtn:NO];
    }];
}


@end
