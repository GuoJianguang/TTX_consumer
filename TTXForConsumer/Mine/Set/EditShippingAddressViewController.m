//
//  EditShippingAddressViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "EditShippingAddressViewController.h"
#import "PSCityPickerView.h"
#import "Verify.h"

@interface EditShippingAddressViewController ()<BasenavigationDelegate,UITextFieldDelegate,UIAlertViewDelegate,PSCityPickerViewDelegate>

@property (strong, nonatomic) PSCityPickerView *cityPicker;
//省
@property (nonatomic, strong)NSString *proStr;
//市
@property (nonatomic, strong)NSString *shiStr;

//区
@property (nonatomic, strong)NSString *quStr;

@end

@implementation EditShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.detailTitle = @"删除地址";
    self.naviBar.hiddenDetailBtn = NO;
    self.naviBar.title = @"收货地址";
    self.naviBar.delegate = self;
    
    self.sureBtn.layer.cornerRadius = 20.;
    self.sureBtn.layer.masksToBounds = YES;
    if (self.isAddAddress) {
        self.naviBar.hiddenDetailBtn = YES;
        self.naviBar.title = @"增加收货地址";
        self.naviBar.hiddenDetailBtn = YES;
        self.proStr = @"北京市";
        self.shiStr = @"北京市";
        self.quStr = @"东城区";
    }
    self.provincesTF.inputView = self.cityPicker;
    
    self.detailAddressTF.delegate = self;
    self.shippingPersonTF.delegate = self;
    self.provincesTF.delegate = self;
    self.phoneTF.delegate = self;
    
    if (self.addressModel) {
        self.shippingPersonTF.text = self.addressModel.name;
        self.detailAddressTF.text = self.addressModel.address;
        self.provincesTF.text = [NSString stringWithFormat:@"%@ %@ %@",self.addressModel.province,self.addressModel.city,self.addressModel.zone];
        
        self.ZipCodeTF.text = self.addressModel.zipCode;
        self.phoneTF.text = self.addressModel.phone;
        
        self.proStr = self.addressModel.province;
        self.shiStr = self.addressModel.city;
        self.quStr = self.addressModel.zone;
    }
    
    [self setViewLayer:_view1];
    [self setViewLayer:_view2];
    [self setViewLayer:_view3];
    [self setViewLayer:_view4];
    [self setViewLayer:_view5];
    [self setViewLayer:_view6];

    self.label1.textColor = self.label2.textColor = self.label3.textColor = self.label4.textColor = self.label5.textColor = MacoTitleColor;

}


#pragma mark - 设置边框
- (void)setViewLayer:(UIView *)view
{
    view.layer.borderWidth = 1;
    view.layer.borderColor = MacolayerColor.CGColor;
}


- (void)detailBtnClick
{
    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您确认要删除收货地址吗？" delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"确认", nil];
    [alerView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token,
                                @"id":self.addressModel.addressId};
        [HttpClient POST:@"user/userInfo/address/delete" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
            if (IsRequestTrue) {
                [[JAlertViewHelper shareAlterHelper]showTint:@"地址删除成功" duration:1.5];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}


- (PSCityPickerView *)cityPicker
{
    if (!_cityPicker)
    {
        _cityPicker = [[PSCityPickerView alloc] init];
        _cityPicker.cityPickerDelegate = self;
    }
    return _cityPicker;
}
#pragma mark - PSCityPickerViewDelegate
- (void)cityPickerView:(PSCityPickerView *)picker
    finishPickProvince:(NSString *)province
                  city:(NSString *)city
              district:(NSString *)district
{
    self.proStr = province;
    self.shiStr = city;
    self.quStr = district;
    [self.provincesTF setText:[NSString stringWithFormat:@"%@ %@ %@",province,city,district]];
}

- (IBAction)sure_btn:(id)sender
{
    self.shippingPersonTF.text =  [self.shippingPersonTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.detailAddressTF.text = [self.detailAddressTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if (![self valueValidated]) {
        return;
    }
    
    //添加地址
    if (self.isAddAddress) {
        NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token,
                                @"name":self.shippingPersonTF.text,
                                @"province":NullToSpace(self.proStr),
                                @"city":NullToSpace(self.shiStr),
                                @"zone":NullToSpace(self.quStr),
                                @"address":self.detailAddressTF.text,
                                @"phone":self.phoneTF.text,
                                @"zipCode":self.ZipCodeTF.text,
                                @"defaultFlag":@"",
                                };
        
        [HttpClient POST:@"user/userInfo/address/add" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
            if (IsRequestTrue) {
                [[JAlertViewHelper shareAlterHelper]showTint:@"地址添加成功" duration:1.5];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        return;
    }
    //修改地址
    NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token,
                            @"name":self.shippingPersonTF.text,
                            @"province":NullToSpace(self.proStr),
                            @"city":NullToSpace(self.shiStr),
                            @"zone":NullToSpace(self.quStr),
                            @"address":self.detailAddressTF.text,
                            @"phone":self.phoneTF.text,
                            @"defaultFlag":self.addressModel.defaultFlag,
                            @"zipCode":self.ZipCodeTF.text,
                            @"id":self.addressModel.addressId};
    [HttpClient POST:@"user/userInfo/address/update" parameters:parms success:^(AFHTTPRequestOperation *operation, id jsonObject) {
        if (IsRequestTrue) {
            [[JAlertViewHelper shareAlterHelper]showTint:@"地址修改成功" duration:1.5];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
-(BOOL) valueValidated {
    // 判断电话号码是否合格
    if ([self emptyTextOfTextField:self.shippingPersonTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入收件人姓名" duration:1.];
        return NO;
    }else if ([self emptyTextOfTextField:self.provincesTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请选择省市区" duration:1.];
        return NO;
    }else if ([self emptyTextOfTextField:self.detailAddressTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入详细地址" duration:1.];
        return NO;
    }else if ([self emptyTextOfTextField:self.ZipCodeTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入邮编" duration:1.];
        return NO;
    }else if ([self emptyTextOfTextField:self.phoneTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入电话号码" duration:1.];
        return NO;
    }
    
    Verify *ver = [[Verify alloc]init];
    BOOL isture = [ver verifyPhoneNumber:self.phoneTF.text];
    if (!isture) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"您的电话号码格式不正确" duration:1.];
        return NO;
    }
    return YES;
}


-(BOOL) emptyTextOfTextField:(UITextField*) textField {
    
    if ([textField.text isEqualToString:@""] || !textField.text) {
        return YES;
    }
    return NO;
    
}

#pragma mark - UItextFileDelegate

//字数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.shippingPersonTF) {
        if (self.shippingPersonTF.text.length >10 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    if (textField == self.detailAddressTF) {
        if (self.detailAddressTF.text.length >100 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    if (textField == self.phoneTF) {
        if (self.phoneTF.text.length >10 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.provincesTF) {
        [self.provincesTF setText:[NSString stringWithFormat:@"%@ %@ %@",self.proStr,self.shiStr,self.quStr]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectProBtn:(UIButton *)sender {
    [self.provincesTF becomeFirstResponder];
}
@end
