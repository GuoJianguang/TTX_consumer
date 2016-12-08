//
//  OtherdiquRealNameAutViewController.m
//  TTXForConsumer
//
//  Created by ttx on 16/8/2.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "OtherdiquRealNameAutViewController.h"
#import "AuthenticationSuccessView.h"
#import "Verify.h"
#import "LBXScanWrapper.h"
#import "LBXAlertAction.h"
#import <QiniuSDK.h>
#import "WaitingAuthenticationViewController.h"


@interface OtherdiquRealNameAutViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong)AuthenticationSuccessView *successView;

@property (nonatomic, strong)NSString *idPhoto;
@property (nonatomic, assign)BOOL isSelectPhoto;


@end

@implementation OtherdiquRealNameAutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBar.title = @"实名认证";
    [self setViewLayer:self.nameView];
    [self setViewLayer:self.idCardNumView];
    
    self.yetAutLabel.layer.cornerRadius = 4;
    self.yetAutLabel.backgroundColor = MacoColor;
    self.yetAutLabel.textColor = [UIColor whiteColor];
    self.yetAutLabel.layer.masksToBounds = YES;
    self.yetAutLabel.hidden = YES;
    self.yetAutLabel.text = @"已认证";
    self.alerLabel.text = @"提示：为保障您的资金安全需进行实名认证，一经认证不可修改。";
    
    self.sureBtn.layer.cornerRadius =  20.;
    self.sureBtn.layer.masksToBounds = YES;
    
    self.label2.textColor = self.label1.textColor = self.label3.textColor= MacoTitleColor;
    self.alerLabel.textColor = MacoDetailColor;
    //已经实名认证
    self.yetAutLabel.hidden = !self.isYetAut;
    if (self.isYetAut) {
        self.nameTF.text = [TTXUserInfo shareUserInfos].idcardName;
        self.idCardNumTF.text = [TTXUserInfo shareUserInfos].idcard;
        self.nameTF.enabled  = NO;
        self.idCardNumTF.enabled  = NO;
        self.sureBtn.hidden = YES;
        self.alerLabel.hidden = YES;
        [self hideIDCardNum];
    }
    self.isSelectPhoto = NO;

}

- (void)hideIDCardNum
{
    if (self.idCardNumTF.text.length == 18) {
        self.idCardNumTF.text = [self.idCardNumTF.text stringByReplacingCharactersInRange:NSMakeRange(1, 16) withString:@"****************"];
    }
    
}
- (void)setViewLayer:(UIView *)view
{
    view.layer.borderWidth = 1;
    view.layer.borderColor = MacolayerColor.CGColor;
}

#pragma mark - 确定认证
- (IBAction)sureBtn:(UIButton *)sender {
    [self.idCardNumTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
    sender.enabled = NO;
    if ([self valueValidated]) {
        __weak __typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"正在发送请求" maskType:SVProgressHUDMaskTypeBlack];
        [HttpClient POST:@"user/getQiniuToken" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
            
            NSString *qiniuToken = jsonObject[@"data"];
            
            [weakSelf upLoadImage:self.uploadImageBtn.currentBackgroundImage withToken:qiniuToken];
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [SVProgressHUD dismiss];
            sender.enabled = YES;
        }];
    }else{
        sender.enabled = YES;
    }
}


-(BOOL) valueValidated {
    // 判断电话号码是否合格
    if ([self emptyTextOfTextField:self.nameTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入姓名" duration:1.5];
        return NO;
    }else if ([self emptyTextOfTextField:self.idCardNumTF]) {
        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入证件号码" duration:1.5];
        return NO;
    }else if (!self.isSelectPhoto){
        [[JAlertViewHelper shareAlterHelper]showTint:@"请设置您的证件照" duration:1.5];
        return NO;
    }
//    Verify *ver = [[Verify alloc]init];
//    if (![ver verifyIDNumber:self.idCardNumTF.text]) {
//        [[JAlertViewHelper shareAlterHelper]showTint:@"请输入正确的身份证号码" duration:1.5];
//        return NO;
//    }
    return YES;
}

-(BOOL) emptyTextOfTextField:(UITextField*) textField {
    
    if ([textField.text isEqualToString:@""] || !textField.text) {
        return YES;
    }
    return NO;
    
}


- (AuthenticationSuccessView *)successView
{
    if (!_successView) {
        _successView = [[AuthenticationSuccessView alloc]init];
        _successView.frame = CGRectMake(0, 64, TWitdh, THeight - 64);
    }
    return _successView;
}

#pragma mark - 选择照相或者图片


- (IBAction)uploadImageBtn:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择",@"拍照", nil];
    [sheet showInView:self.view];
    return;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self presentAlbum];
        }
            break;
            //进入照相界面
        case 1:
        {
            
            [self prsentCamera];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 进入照相机
- (void)prsentCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"该设备不支持照相");
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
#pragma mark - 打开本地相册
- (void)presentAlbum
{
    if ([LBXScanWrapper isGetPhotoPermission])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        picker.delegate = self;
        
        
        picker.allowsEditing = YES;
        
        
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

#pragma mark -- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self.uploadImageBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    self.isSelectPhoto = YES;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}

#pragma mark - 上传照片
- (void)upLoadImage:(UIImage *)image withToken:(NSString *)qiniuToken
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DateFormatterString];
    NSString *string = [formatter stringFromDate:date];
    NSString *strRandom = @"";
    for(int i=0; i< 6; i++)
    {
        strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    NSString *imageSuffix = @"jpg";
    NSData *imageData = UIImageJPEGRepresentation(image, 0.4f);
    if (!imageData) {
        imageData = UIImagePNGRepresentation(image);
        imageSuffix = @"png";
    }
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        QNServiceAddress *s1 = [[QNServiceAddress alloc] init:@"https://upload.qbox.me" ips:@[@"183.136.139.16"]];
        QNServiceAddress *s2 = [[QNServiceAddress alloc] init:@"https://up.qbox.me" ips:@[@"183.136.139.16"]];
        builder.zone = [[QNZone alloc] initWithUp:s1 upBackup:s2];
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    NSString *randomDkey = [NSString stringWithFormat:@"%@.%@",[string stringByAppendingString:strRandom],imageSuffix];
    [upManager putData:imageData key:randomDkey token:qiniuToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  if (info.error) {
                      [SVProgressHUD dismiss];
                      self.sureBtn.enabled = YES;
                      [[JAlertViewHelper shareAlterHelper]showTint:@"头像上传失败,请稍后重试" duration:1.5];
                      return;
                  }
                  self.idPhoto = NullToSpace(resp[@"key"]);
                  
                  NSDictionary *parms = @{@"token":[TTXUserInfo shareUserInfos].token,
                                          @"cardNo":self.idCardNumTF.text,
                                          @"idcardName":self.nameTF.text,
                                          @"idPhoto":NullToSpace(self.idPhoto)};
                  [HttpClient POST:@"user/verifyIdcardReq" parameters:parms success:^(NSURLSessionDataTask *operation, id jsonObject) {
                      self.sureBtn.enabled = YES;
                      [SVProgressHUD dismiss];
                      if (IsRequestTrue) {
                          [TTXUserInfo shareUserInfos].idVerifyReqFlag = YES;
                          WaitingAuthenticationViewController *waitingVC = [[WaitingAuthenticationViewController alloc]init];
                          waitingVC.isHandmoveAu = YES;
                          [self.navigationController pushViewController:waitingVC animated:YES];
                      }
                      
                  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                      [SVProgressHUD dismiss];
                      [[JAlertViewHelper shareAlterHelper]showTint:@"认证失败,请稍后重试" duration:1.5];
                      self.sureBtn.enabled = YES;
                  }];

              } option:nil];
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


@end
