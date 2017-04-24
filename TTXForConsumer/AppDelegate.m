//
//  AppDelegate.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/16.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocialWechatHandler.h"
#import "UMessage.h"
//#import "ZWIntroductionViewController.h"
#import "WXApi.h"
#import "WeXinPayObject.h"
#import "RootViewController.h"
#import "MineViewController.h"
#import "HomeViewController.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>



#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface AppDelegate ()<BaiduMobAdSplashDelegate,UNUserNotificationCenterDelegate>



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
// Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc]init];
//    RootViewController *mainController  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Root"];
    [self.window makeKeyAndVisible];
    
    [self SetTheThirdParty:launchOptions];
    [TTXUserInfo shareUserInfos].token = @"";
    if (launchOptions) {
        NSDictionary *info = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if (info &&[info isKindOfClass:[NSDictionary class]]) {
            [UMessage didReceiveRemoteNotification:info];
            [TTXUserInfo shareUserInfos].islaunchFormNotifi = YES;
            [TTXUserInfo shareUserInfos].notificationParms = info;
        }
    }
    //百度广告
    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    splash.delegate = self;
    splash.AdUnitTag = @"2828600";
    splash.canSplashClick = YES;
    [BaiduMobAdSetting sharedInstance].supportHttps = YES;
//    [splash loadAndDisplayUsingKeyWindow:self.window];
    self.splash = splash;
    //可以在customSplashView上显示包含icon的自定义开屏
    self.customSplashView = [[UIView alloc]initWithFrame:self.window.frame];
    self.customSplashView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.customSplashView];
    
    CGFloat screenWidth = self.window.frame.size.width;
    CGFloat screenHeight = self.window.frame.size.height;
//在baiduSplashContainer用做上展现百度广告的容器，注意尺寸必须大于200*200，并且baiduSplashContainer需要全部在window内，同时开机画面不建议旋转
    UIView * baiduSplashContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.customSplashView addSubview:baiduSplashContainer];
    [splash loadAndDisplayUsingContainerView:baiduSplashContainer];
    return YES;
}

#pragma mark - 设置一些第三方库的key
- (void)SetTheThirdParty:(NSDictionary*)launchOptions{
    //高德地图
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = MAP_APPKEY_APPSTORE;
    //友盟分享的key
    [[UMSocialManager defaultManager] setUmSocialAppkey:YoumengKey];
    
    //set AppKey and LaunchOptions
    //友盟推送设置
    [UMessage startWithAppkey:YoumengKey launchOptions:launchOptions httpsenable:YES];
    //友盟统计设置
    UMConfigInstance.appKey = YoumengKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
//        [MobClick startWithAppkey:YoumengKey reportPolicy:BATCH   channelId:nil];
    
//    
//    //微信支付
    [WXApi registerApp:@"wxcc1bde9f6a54571b" withDescription:@"com.ttx.tiantianxin"];
//    //友盟推送的key
    [self setUMPush:launchOptions];
//
//    //设置微信AppId，设置分享url，默认使用友盟的网址
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxcc1bde9f6a54571b" appSecret:@"171a3f441c98d00c3d48790758a3a41c" redirectURL:@"http://mobile.umeng.com/social"];
    [TTXUserInfo shareUserInfos].devicetoken = @"1ab38c03b38f4461725d39d8fb143b898279eaa0ee59ea90e057a536a1aecfbd";
}

#pragma mark - 设置友盟推送

- (void)setUMPush:(NSDictionary *)launchOptions
{
    
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    }else
    {
        [UMessage registerForRemoteNotifications:categories];
    }
    
    //如果对角标，文字和声音的取舍，请用下面的方法
    //UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    //UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    //[UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    //for log
    [UMessage setLogEnabled:YES];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WeXinPayObject shareWexinPayObject]];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:[WeXinPayObject shareWexinPayObject]];
    }
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:UPPayResult object:nil userInfo:@{@"code":code}];

        
        
//        if([code isEqualToString:@"success"]) {
//            
//            //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
//            if(data != nil){
//                //数据从NSDictionary转换为NSString
//                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
//                                                                   options:0
//                                                                     error:nil];
//                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
//                
//                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
//            }
//            
//            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
//        }
//        else if([code isEqualToString:@"fail"]) {
//            //交易失败
//        }
//        else if([code isEqualToString:@"cancel"]) {
//            //交易取消
//        }
    }];
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([NullToSpace(options[@"UIApplicationOpenURLOptionsSourceApplicationKey"]) isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:[WeXinPayObject shareWexinPayObject]];
    }
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        [[NSNotificationCenter defaultCenter]postNotificationName:UPPayResult object:nil userInfo:@{@"code":code}];

//        if([code isEqualToString:@"success"]) {
//            
//            //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
//            if(data != nil){
//                //数据从NSDictionary转换为NSString
//                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
//                                                                   options:0
//                                                                     error:nil];
//                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
//                
//                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
//            }
//            
//            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
//        }
//        else if([code isEqualToString:@"fail"]) {
//            //交易失败
//        }
//        else if([code isEqualToString:@"cancel"]) {
//            //交易取消
//        }
    }];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //    NSLog(@"-------%@",userInfo);
    //关闭友盟的弹窗
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter]postNotificationName:Upush_Notifi object:nil userInfo:userInfo];
}

#pragma mark - 私有方法-获取deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *str = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [TTXUserInfo shareUserInfos].devicetoken = str;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:AutoLoginAfterGetDeviceToken object:nil userInfo:nil];
    NSLog(@"deviceToken:%@", str);
    // [3]:向个推服务器注册deviceToken
    //    if (_gexinPusher) {
    //        [_gexinPusher registerDeviceToken:_deviceToken];
    //    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

#pragma mark - UNUserNotificationCenterDelegate
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
        [[NSNotificationCenter defaultCenter]postNotificationName:Upush_Notifi object:nil userInfo:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
        [[NSNotificationCenter defaultCenter]postNotificationName:Upush_Notifi object:nil userInfo:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}




#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ttx.TTXForConsumer" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TTXForConsumer" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TTXForConsumer.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - 百度广告delegate
/**
 *  应用的APPID
 */
- (NSString *)publisherId
{
    return @"dad9db17";
}

- (void)splashDidClicked:(BaiduMobAdSplash *)splash {
    [self removeSplash];
    NSLog(@"splashDidClicked");
}

- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissLp");
}

- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissScreen");
    [self removeSplash];
}

- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashSuccessPresentScreen");
}

- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason)reason {
    NSLog(@"splashlFailPresentScreen withError %d", reason);
    [self removeSplash];
}

/**
 *  展示结束or展示失败后, 手动移除splash和delegate
 */
- (void) removeSplash {
    if (self.splash) {
        self.splash.delegate = nil;
        self.splash = nil;
        [self.customSplashView removeFromSuperview];
    }
}

@end
