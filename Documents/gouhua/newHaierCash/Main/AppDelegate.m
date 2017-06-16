//
//  AppDelegate.m
//  newHaierCash
//
//  Created by xuxie on 2017/4/19.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "AppDelegate.h"
#import "HCMacro.h"
#import "DefineSystemTool.h"
#import "BSVKHttpClient.h"

#import "HCRootTabController.h"
#import "HCUserModel.h"
#import "LoginViewController.h"
#import "DefineSystemTool.h"
#import "GetActivityInfo.h"
#import "GestureViewController.h"
#import "BSVKSyncHttpClient.h"
#import "EnterAES.h"
#import "SvUDIDTools.h"
#import "AtokenModel.h"
//第三方管理工具
#import "XGPush.h"
#import <Bugly/Bugly.h>
#import <IQKeyboardManager.h>
#import <YYWebImage.h>


static AppDelegate *selfDelegate = nil;
@interface AppDelegate () <BuglyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    selfDelegate = self;
    [self asyncInitSDK];
    [self baseInfoInit];
    [self initRootControl];
    [self syncInitSDK];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [DefineSystemTool storeEnterBackTime];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if(self.mapLocation.currentLocation && !self.mapLocation.strCity && !self.mapLocation.strProvince)
    {
        //如果当前位置存在,但编码失败,直接编码
        [self.mapLocation reverseGeocodeLocation];
    }else if (!self.mapLocation.currentLocation)
    {
        //如果位置都没有,重新定位
        [self.mapLocation openLocationService];
    }
    //手势密码弹出
    [self backgroundEnterFrontGesture];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- private Methods (自定义方法)

- (void)initRootControl {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    GetActivityInfo *lanchInfo = [[GetActivityInfo alloc]init];
    
    BOOL isSetGesture = [lanchInfo searchGestureInfo:self.userInfo];
    
    HCRootTabController *rootTabCon = [HCRootTabController new];
    rootTabCon.homeCon.advertModel = [lanchInfo getLanchActivityInfo];
    self.window.rootViewController = rootTabCon;
    [self.window makeKeyAndVisible];
    
    if (isSetGesture) {
        BSVKSyncHttpClient *clien = [[BSVKSyncHttpClient alloc]init];
        
        NSString *strID = [EnterAES simpleEncrypt:[NSString stringWithFormat:@"IOS-%@-%@",[SvUDIDTools UDID],[DefineSystemTool getLastLoginTel]]];
        NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)strID, NULL, (CFStringRef)@"!*’();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        NSString *string = [NSString stringWithFormat:@"app/appserver/token?client_id=%@&client_secret=%@&grant_type=client_credentials",encodedString,[DefineSystemTool userPassword]];
        
        NSDictionary *dic = [clien sendPutRequest:string postData:nil httpMethod:getMothed];
        AtokenModel *tokenModel = [AtokenModel mj_objectWithKeyValues:dic];
        if (!isEmptyString(tokenModel.access_token))
        {
            //将access_token放进请求头
            [[BSVKHttpClient shareInstance]setTokenInHead:tokenModel.access_token tokenType:tokenModel.token_type];
            GestureViewController *gestCon = [GestureViewController new];
            gestCon.type = GestureViewControllerTypeAutomatic;
            HCRootNavController *rootNav = [[HCRootNavController alloc] initWithRootViewController:gestCon];
            [rootNav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [rootTabCon presentViewController:rootNav animated:YES completion:nil];
        }
        
    } else {
        [rootTabCon.homeCon showKPController];
    }
}


- (void)baseInfoInit {
    self.userInfo = [[HCUserModel alloc]init];
    self.recordedInfo = [[HCRecordedModel alloc]init];
    self.imagePutCache = [[YYCache alloc]initWithName:@"PUTIMAGECATCH"];
    
    self.imageCacheM = [[SDImageCache alloc]initWithNamespace:@"PUTIMAGECATCH"];
    
    [DefineSystemTool clearInitTime];
}


- (GestureViewController *)verityGestureCon {
    if (_verityGestureCon == nil) {
        _verityGestureCon = [[GestureViewController alloc]init];
    }
    _verityGestureCon.type = GestureViewControllerTypeLogin;
    return _verityGestureCon;
}

//后台进入前台安全保护 手势密码 和 登录
- (void)backgroundEnterFrontGesture {
    if (_userInfo.bLoginOK && [DefineSystemTool judgeFiveMActive] && !self.recordedInfo.needBackCheck) {
        self.recordedInfo.needBackCheck = YES;
        if (self.userInfo.bsetGuestPwd) {
            GestureViewController *gesture = [[GestureViewController alloc]init];
            gesture.type = GestureViewControllerTypeLogin;
            [[self getCurrentVisibleControl] presentViewController:gesture animated:NO completion:nil];
        }else {
            LoginViewController *login = [[LoginViewController alloc]init];
            [[self getCurrentVisibleControl] presentViewController:login animated:NO completion:nil];
        }
    }
}

- (UIViewController *)getCurrentVisibleControl {
    HCRootTabController *rootTabCon = (HCRootTabController *)self.window.rootViewController;
    HCRootNavController *navi = (HCRootNavController *)rootTabCon.selectedViewController;
    return navi.visibleViewController;
}


#pragma mark -- 推送处理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (deviceToken && self.userInfo.userId) {
        NSString *deviceTokenStr = [XGPush registerDevice:deviceToken account:self.userInfo.userId successCallback:^{
            
        } errorCallback:^{
            NSLog(@"信鸽注册失败");
        }];
        NSLog(@"deviceToken %@",deviceTokenStr);
    };
}
//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"[XGPush Demo]%@",str);
    
}



#pragma mark -- 异步调用第三方类
- (void)asyncInitSDK {
    dispatch_queue_t selfQueue = dispatch_queue_create("com.haiercash.subsystem.taskXYZ", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(selfQueue, ^{
        _mapLocation = [[HCMapLocation alloc]init];
        [_mapLocation openLocationService];
//        //百融
//        [BrAgent setTimeoutInterval:300];
//        [BrAgent brInit:MyCid];
    });
}

#pragma mark -- 同步调用第三方类
- (void)syncInitSDK {
    //初始化信鸽
    [XGPush startApp:xingeAppId appKey:xingeAppKey];
    [XGPush unRegisterDevice:^{
        
    } errorCallback:^{
        NSLog(@"失败");
    }];
    [self buglyConfig];
   // [self setIQKeyboardManager];
    
}

#pragma mark - Bugly
- (void)buglyConfig {
    BuglyConfig *config = [[BuglyConfig alloc]init];
    if (DEBUG) {
        config.debugMode = YES;
        config.blockMonitorEnable = YES;
        config.delegate = self;
        config.channel = @"测试";
        config.reportLogLevel = BuglyLogLevelDebug;
    }else {
        config.channel = @"生产";
    }
    config.unexpectedTerminatingDetectionEnable = YES;
    [Bugly startWithAppId:buglyAppId config:config];
}

#pragma mark - IQKeyboardManager
- (void)setIQKeyboardManager {
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}


#pragma mark - BuglyDelegate
- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception {
    return exception.reason;
}


#pragma mark -->获取自身

+(AppDelegate *)delegate{
    
    return selfDelegate;
    
}

@end
