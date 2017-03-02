//
//  UploadImageTool.m
//  SportJX
//
//  Created by Chendy on 15/12/22.
//  Copyright © 2015年 Chendy. All rights reserved.
//

#import "UploadImageTool.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "QiniuUploadHelper.h"


#define QiNiuBaseUrl @"http://7xozpn.com2.z0.glb.qiniucdn.com/"
@implementation UploadImageTool


#pragma mark - Helpers
//给图片命名

+ (NSString *)getDateTimeString {
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}


+ (NSString *)randomStringWithLength:(int)len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i = 0; i<len; i++) {
        
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}


//上传单张图片
+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure {
    
    [UploadImageTool getQiniuUploadToken:^(NSString *token) {
        
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
        [upManager putData:imageData key:randomDkey token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      if (info.error) {
                          [[JAlertViewHelper shareAlterHelper]showTint:@"头像上传失败,请稍后重试" duration:1.5];
                          return;
                      }
                      if (info.statusCode == 200 && resp) {
                        NSString *url= NullToSpace(resp[@"key"]);
                        if (success) {

                            success(url);
                        }
                    }
                    else {
                        if (failure) {
                            
                            failure();
                        }
                    }

                      
                      
                  } option:nil];

//        NSData *data = UIImageJPEGRepresentation(image, 0.01);
//        
//        if (!data) {
//            
//            if (failure) {
//                
//                failure();
//            }
//            return;
//        }
        
//        NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", [UploadImageTool getDateTimeString], [UploadImageTool randomStringWithLength:8]];
//        
//        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
//                                                   progressHandler:progress
//                                                            params:nil
//                                                          checkCrc:NO
//                                                cancellationSignal:nil];
//        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        
//        [uploadManager putData:data
//                           key:fileName
//                         token:token
//                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                          
//                          if (info.statusCode == 200 && resp) {
//                              NSString *url= [NSString stringWithFormat:@"%@%@", QiNiuBaseUrl, resp[@"key"]];
//                              if (success) {
//                                  
//                                  success(url);
//                              }
//                          }
//                          else {
//                              if (failure) {
//                                  
//                                  failure();
//                              }
//                          }
//            
//        } option:opt];
        
    } failure:^{
        
    }];
    
}

//上传多张图片
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block CGFloat totalProgress = 0.0f;
    __block CGFloat partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }
        else {
            NSLog(@"---%ld",(unsigned long)currentIndex);
            
            if (currentIndex<imageArray.count) {
                
                 [UploadImageTool uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
            }
           
        }
    };
    
    [UploadImageTool uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}


//#error mark -- 必须设置获取七牛token服务器地址,然后获取token返回 --(确认设置后,删除此行)
//获取七牛的token
+ (void)getQiniuUploadToken:(void (^)(NSString *))success failure:(void (^)())failure {
    
    //网络请求七牛token
     //服务器地址
    NSString *aPath = [NSString stringWithFormat:@"%@api/getQiniuUpToken",@""];
    
     //获取七牛token
    
    [HttpClient POST:@"user/getQiniuToken" parameters:nil success:^(NSURLSessionDataTask *operation, id jsonObject) {
        
        if (IsRequestTrue) {
            NSString *qiniuToken = jsonObject[@"data"];
            success(qiniuToken);

        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        [SVProgressHUD dismiss];
    }];


//    [[VCOAPIClient sharedClient] requestJsonDataWithPath:aPath withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
//        
//        if (data) {
//            
//            if (success) {
//                
//                success([data objectForKey:@"data"]);
//            }
//            
//        }
//        else {
//            
//            if (failure) {
//                
//                failure();
//            }
//            
//        }
//    }];
}


@end
