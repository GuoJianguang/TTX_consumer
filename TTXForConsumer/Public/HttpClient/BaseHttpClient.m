//
//  BaseHttpClient.m
//  TeacherResponder
//
//  Created by tongbu_jinzhongjun on 14/11/6.
//  Copyright (c) 2014年 tongbu_jinzhongjun. All rights reserved.
//

#import "BaseHttpClient.h"
#import "HttpClientAlertViewHelper.h"
#import "AppDelegate.h"

@interface BaseHttpClient()

@end

@implementation BaseHttpClient

+(AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSString *fullUrlString = [[self class] fullUrlWith:URLString];
    return [[self class] POSTWithFullUrl:fullUrlString parameters:parameters success:success failure:failure];
}

+(AFHTTPRequestOperation *)POSTWithFullUrl:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    Class class = [self class];
    AFHTTPRequestOperationManager *manager = [class defaultManager];
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [class additionalOperatingWithManager:manager parameter:mutalbleParameter];
//    [SVProgressHUD showWithStatus:@"正在加载..."];

    return [manager POST:URLString parameters:mutalbleParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [SVProgressHUD dismiss];
        [[self class] handleWithOperation:operation responseObject:responseObject success:success];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD dismiss];

        [[self class] failureHandleWithOperation:operation error:error callBack:failure];
    }];
}

+(AFHTTPRequestOperation *)POST:(NSString *)URLString header:(id)headerPara body:(id)bodyPara success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSString *fullUrlString = [[self class] fullUrlWith:URLString];
    return [self POSTWithFullUrl:fullUrlString header:headerPara body:bodyPara success:success failure:failure];
}

+(AFHTTPRequestOperation *)POSTWithFullUrl:(NSString *)URLString header:(id)headerPara body:(id)bodyPara success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {

    Class class = [self class];
    AFHTTPRequestOperationManager *manager = [class defaultManager];
    NSArray *keys = [headerPara allKeys];
    for (NSString *key in keys) {
        [manager.requestSerializer setValue:[headerPara valueForKey:key] forHTTPHeaderField:key];
    }
    
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:bodyPara];
    [class additionalOperatingWithManager:manager parameter:mutalbleParameter];
    
    return [manager POST:URLString parameters:mutalbleParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[self class] handleWithOperation:operation responseObject:responseObject success:success];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[self class] failureHandleWithOperation:operation error:error callBack:failure];
    }];
    
}

+(AFHTTPRequestOperation *)GETWithFullUrl:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {

    Class class = [self class];
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    AFHTTPRequestOperationManager *manager = [class defaultManager];
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [class additionalOperatingWithManager:manager parameter:mutalbleParameter];
    
    return [manager GET:URLString parameters:mutalbleParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [SVProgressHUD dismiss];
        [[self class]handleWithOperation:operation responseObject:responseObject success:success];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD dismiss];
        [[self class] failureHandleWithOperation:operation error:error callBack:failure];
    }];
}

+(AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSString *fullUrlString = [[self class] fullUrlWith:URLString];
    
    return [self GETWithFullUrl:fullUrlString parameters:parameters success:success failure:failure];
}

+(AFHTTPRequestOperation *)GET:(NSString *)URLString header:(id)headerPara body:(id)bodyPara success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {

    Class class = [self class];
    return  [class GETWithFullUrl:[class fullUrlWith:URLString] header:headerPara body:bodyPara success:success failure:failure];
}

+(AFHTTPRequestOperation *)GETWithFullUrl:(NSString *)URLString header:(id)headerPara body:(id)bodyPara success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {

    Class class = [self class];
    AFHTTPRequestOperationManager *manager = [class defaultManager];
    NSArray *keys = [headerPara allKeys];
    for (NSString *key in keys) {
        [manager.requestSerializer setValue:[headerPara valueForKey:key] forHTTPHeaderField:key];
    }
    
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:bodyPara];
    [class additionalOperatingWithManager:manager parameter:mutalbleParameter];
    
    return [manager GET:URLString parameters:mutalbleParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[self class] handleWithOperation:operation responseObject:responseObject success:success];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[self class] failureHandleWithOperation:operation error:error callBack:failure];
    }];
}

+(AFHTTPRequestOperation *)POSTWithToken:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSString *fullUrlString = [[self class] fullUrlWith:URLString];
    Class class = [self class];
    AFHTTPRequestOperationManager *manager = [class defaultManager];
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [class addTokenWithParameter:mutalbleParameter manager:manager];
    
    [class additionalOperatingWithManager:manager parameter:mutalbleParameter];
    
    return [manager POST:fullUrlString parameters:mutalbleParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[self class] handleWithOperation:operation responseObject:responseObject success:success];
        
    } failure:failure];
}

+(AFHTTPRequestOperation *)GETWithToken:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSString *fullUrlString = [[self class] fullUrlWith:URLString];
    Class class = [self class];
   
    AFHTTPRequestOperationManager *manager = [class defaultManager];
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [class addTokenWithParameter:mutalbleParameter manager:manager];
    [class additionalOperatingWithManager:manager parameter:mutalbleParameter];

    return [manager GET:fullUrlString parameters:mutalbleParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[self class] handleWithOperation:operation responseObject:responseObject success:success];
        
    } failure:failure];
}

+(AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(id)parameters images:(NSArray *)images success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    Class class = [self class];
    NSString *fullUrlString = [class fullUrlWith:URLString];
    AFHTTPRequestOperationManager *manager = [class defaultManager];
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [class additionalOperatingWithManager:manager parameter:mutalbleParameter];
    
    return [manager POST:fullUrlString parameters:mutalbleParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        for (int i = 0; i < [images count]; i++) {
            UIImage *image = [images objectAtIndex:i];
            NSString *imageSuffix = @"jpg";
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
            if (!imageData) {
                imageData = UIImagePNGRepresentation(image);
                imageSuffix = @"png";
            }
            
            [formData appendPartWithFileData:imageData name:@"filesimg" fileName:[NSString stringWithFormat:@"image%d.%@",i,imageSuffix] mimeType:@"image/jpeg"];
        }
    } success:success failure:failure];
}


+(AFHTTPRequestOperation *)POSTWithToken:(NSString *)URLString parameters:(id)parameters images:(NSArray *)images success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {

    Class class = [self class];
    NSString *fullUrlString = [class fullUrlWith:URLString];
    AFHTTPRequestOperationManager *manager = [class defaultManager];
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [class additionalOperatingWithManager:manager parameter:mutalbleParameter];
    [class addTokenWithParameter:mutalbleParameter manager:manager];
    
    return [manager POST:fullUrlString parameters:mutalbleParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        for (int i = 0; i < [images count]; i++) {
            UIImage *image = [images objectAtIndex:i];
            NSString *imageSuffix = @"jpg";
            NSData *imageData = UIImageJPEGRepresentation(image, 0.4f);
            if (!imageData) {
                imageData = UIImagePNGRepresentation(image);
                imageSuffix = @"png";
            }
            
            [formData appendPartWithFileData:imageData name:@"upload" fileName:[NSString stringWithFormat:@"image2222%d.%@",i,imageSuffix] mimeType:@"image/jpeg"];
        }
    } success:success failure:failure];
}

+(void)uploadFileAtPath:(NSString*)filePath toUrl:(NSString *)urlString
               progress:(NSProgress*)progress completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:fileUrl progress:&progress completionHandler:completionHandler];
    [uploadTask resume];
}

+(void)uploadFiles:(NSData *)data toUrl:(NSString *)urlString progress:(NSProgress *)progress completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:data progress:&progress completionHandler:completionHandler];
    [uploadTask resume];
}

+(void)downloadWithUrl:(NSString *)urlString fileName:(NSString *)fileName downloadBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadBlock success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    [[self class] downloadWithUrl:urlString fileName:fileName needUnzip:NO downloadBlock:downloadBlock success:success failure:failure];
}

//+(void)downloadWithUrl:(NSString *)urlString fileName:(NSString *)fileName needUnzip:(BOOL)needUnzip downloadBlock:(void (^)(NSUInteger, long long, long long))downloadBlock success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
//    
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)objectAtIndex:0];
//    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setDownloadProgressBlock:downloadBlock];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (needUnzip) {
//            BOOL unzipStatus = [SSZipArchive unzipFileAtPath:filePath toDestination:documentPath];
//            if (unzipStatus) {
//                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//            }
//        }
//        success(operation,responseObject);
//    } failure:failure];
//    [operation start];
//    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
//}



+(void)load {
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    [reachManager startMonitoring];
    [reachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                if (ShowErrorMessage) {
                    [[HttpClientAlertViewHelper sharedAlterHelper] showTint:NetworkConnectFailure duration:1.f];
                }
            break;
                
            default:
                break;
        }
    }];
}

+(AFHTTPRequestOperationManager*) defaultManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.stringEncoding = RequestSerializerEncoding;
    requestSerializer.timeoutInterval = TimeoutInterval;
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.stringEncoding = ResponseSerializerEncoding;
    
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = responseSerializer;
    
    return manager;
}

+(void) handleWithOperation:(AFHTTPRequestOperation*)operation responseObject:(id) responseObject success:(void (^)(AFHTTPRequestOperation *, id))success
{
    @try {
        NSError *error = nil;
        //    id jsonObject = [responseObject objectFromJSONData];//
        id jsonObject=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:ResponseSerializerEncoding];
        NSString *err_string = [NSString stringWithFormat:@"json 格式错误.返回字符串：%@",responseString];
        NSAssert(error==nil, err_string);
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            if ([NullToNumber(jsonObject[@"code"]) isEqualToString:@"-300"]) {
                [TTXUserInfo shareUserInfos].currentLogined = NO;
                UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您的登录信息已过期，请重新登录" delegate:[UIApplication sharedApplication].keyWindow.rootViewController cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [aler show];
                success(operation,jsonObject);
                return;
            }
            if (![NullToNumber(jsonObject[@"code"]) isEqualToString:@"0"]) {
                [[JAlertViewHelper shareAlterHelper]showTint:jsonObject[@"message"] duration:1.5];
            }
        }
        success(operation,jsonObject);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
}



+(void) failureHandleWithOperation:(AFHTTPRequestOperation*)operation error:(NSError*)error callBack:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    // 检测有无网络
     AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    if (!reachManager.reachable) {
        NSDictionary *userInfor = error.userInfo;
        NSString *domain = error.domain;
        NSInteger code = error.code;
        NSMutableDictionary *newErrorInfor = [NSMutableDictionary dictionaryWithDictionary:userInfor];
        [newErrorInfor setObject:@"无网络连接..." forKey:@"response"];
        NSError *newError = [NSError errorWithDomain:domain code:code userInfo:newErrorInfor];
        failure(operation,newError);
        return;
    }
    NSString *errorString = [error.userInfo objectForKey:TimeoutErrorKey];
    if([errorString isEqualToString:TimeoutErrorValue]){
        if (ShowErrorMessage) {
             [[HttpClientAlertViewHelper sharedAlterHelper] showTint:TimeoutErrorTintString duration:1.5f];
        }
    }else if ([errorString isEqualToString:CouldNotConnectServerValue] || [errorString isEqualToString:TimeoutErrorValue] || [errorString isEqualToString:@"未能连接到服务器。"]) {
        [[HttpClientAlertViewHelper sharedAlterHelper]showTint:CouldNotConnectServerTint duration:1.5f];
    }
    else if ([errorString isEqualToString:NetworkConnectLostValue]) {
        if (ShowErrorMessage) {
            [[HttpClientAlertViewHelper sharedAlterHelper]showTint:NetworkConnectLostTint duration:1.5f];
        }
    }else if ([errorString isEqualToString:NetWorkBusy]){
        if (ShowErrorMessage) {
            [[HttpClientAlertViewHelper sharedAlterHelper]showTint:@"服务器忙" duration:1.5f];
        }
    }else {
        NSData *responseData = operation.responseObject;
        if (responseData) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            // 得到失败的提示
            NSString *errInfo = [[[responseDic objectForKey:@"detail"]objectForKey:@"non_field_errors"]firstObject] ? :@"";
            
            NSDictionary *userInfor = error.userInfo;
            NSString *domain = error.domain;
            NSInteger code = error.code;
            NSMutableDictionary *newErrorInfor = [NSMutableDictionary dictionaryWithDictionary:userInfor];
            [newErrorInfor setObject:errInfo forKey:@"response"];
            NSError *newError = [NSError errorWithDomain:domain code:code userInfo:newErrorInfor];
            
//            NSString *detailStr = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
//            [[JAlertViewHelper shareAlterHelper]showTint:detailStr duration:1.5];
            failure(operation,newError);
            return;
        }
    }
    failure(operation,error);
}

+(BOOL) isNetworkAvailable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+(NSString*)fullUrlWith:(NSString*)address {
    return [NSString stringWithFormat:@"%@%@",HttpClient_BaseUrl,address];
}

+(void)addTokenWithParameter:(NSMutableDictionary *)parameters manager:(id)manager {
    [((AFHTTPRequestOperationManager *)manager).requestSerializer setValue:[TTXUserInfo shareUserInfos].token forHTTPHeaderField:@"Authorization"];
}

+(void)additionalOperatingWithManager:(AFHTTPRequestOperationManager *)manager parameter:(NSMutableDictionary *)parameters {

}


@end

