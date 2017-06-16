//
//  StartBrAgent.m
//  personMerchants
//
//  Created by 百思为科 on 16/10/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "StartBrAgent.h"
#import "HCMacro.h"
#import "AppDelegate.h"
#import "SvUDIDTools.h"
#import "BrAgent.h"
#import "EnterAES.h"
#import "BSVKHttpClient.h"
#import "UpdateRiskInfoModel.h"
#import "RMUniversalAlert.h"
#import <AdSupport/AdSupport.h>
#import <sys/sysctl.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <Bugly/Bugly.h>
static NSString *_type; //判断是哪种模式

@interface StartBrAgent()<BSVKHttpClientDelegate>

@end

@implementation StartBrAgent
//登录（实名，登录，手势登录）
+ (NSString *)startBrAgentLogin
{
    NSString *latitude = [NSString stringWithFormat:@"%f",[AppDelegate delegate].mapLocation.myCoordinate2D.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",[AppDelegate delegate].mapLocation.myCoordinate2D.longitude];
    
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc]init];
    [loginInfo setObject:MyCid forKey:@"cid"];
    [loginInfo setObject:@"antifraud" forKey:@"app"];
    [loginInfo setObject:@"login" forKey:@"event"];
    [loginInfo setObject:@"web" forKey:@"plat_type"];
    [loginInfo setObject:StringOrNull(latitude) forKey:@"latitude"];
    [loginInfo setObject:StringOrNull(longitude) forKey:@"longitude"];
    [loginInfo setObject:[NSNumber numberWithBool:YES] forKey:@"grab"];
    [loginInfo setObject:[[UIDevice currentDevice]model] forKey:@"model"];
    [loginInfo setObject:@"apple" forKey:@"brand"];
    [loginInfo setObject:StringOrNull([self getIDFA]) forKey:@"IDFA"];
    [loginInfo setObject:StringOrNull([SvUDIDTools UDID]) forKey:@"UUID"];
    [loginInfo setObject:@"false" forKey:@"is_simulator"];
    [loginInfo setObject:StringOrNull([self getCurrentWifiName]) forKey:@"wafi_name"];
    [loginInfo setObject:StringOrNull([self getCurrentWifiAddress]) forKey:@"wafi_mac"];
//    [loginInfo setObject:StringOrNull([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]) forKey:@"packageName"];
//    [loginInfo setObject:StringOrNull([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]) forKey:@"appVersion"];
    
    [BrAgent onFraud:loginInfo completion:^(NSError* error,id feedback)
    {
        NSLog(@"feedback is %@",feedback);
        if(!error)
        {
            if ([[feedback objectForKey:@"code"]isEqualToString:@"true"])
            {
                _type = @"antifraud_login";
                NSArray *array = [(NSDictionary *)feedback objectForKey:@"response"];
                NSString *str = [array[0] objectForKey:@"af_swift_number"];
                [AppDelegate delegate].userInfo.af_swift_number = str;
                //NSString *event = @"A501";
               // [blockSelf sendStr:str event:event];
            }
        }else
        {
            [Bugly reportError:error];
            NSLog(@"百融error=%@",error);
        }
    }];
    return nil;
}
//借款（额度申请，提交订单）
+ (NSString *)startBrAgentlend
{
    
    NSString *latitude = [NSString stringWithFormat:@"%f",[AppDelegate delegate].mapLocation.myCoordinate2D.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",[AppDelegate delegate].mapLocation.myCoordinate2D.longitude];
    
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc]init];
    [loginInfo setObject:MyCid forKey:@"cid"];
    [loginInfo setObject:@"lend" forKey:@"event"];
    [loginInfo setObject:@"antifraud" forKey:@"app"];
    [loginInfo setObject:@"web" forKey:@"plat_type"];
    [loginInfo setObject:StringOrNull(latitude) forKey:@"latitude"];
    [loginInfo setObject:StringOrNull(longitude) forKey:@"longitude"];
    [loginInfo setObject:[NSNumber numberWithBool:YES] forKey:@"grab"];
    [loginInfo setObject:[[UIDevice currentDevice]model] forKey:@"model"];
    [loginInfo setObject:@"apple" forKey:@"brand"];
    [loginInfo setObject:StringOrNull([self getIDFA]) forKey:@"IDFA"];
    [loginInfo setObject:StringOrNull([SvUDIDTools UDID]) forKey:@"UUID"];
    [loginInfo setObject:@"false" forKey:@"is_simulator"];
    [loginInfo setObject:StringOrNull([self getCurrentWifiName]) forKey:@"wafi_name"];
    [loginInfo setObject:StringOrNull([self getCurrentWifiAddress]) forKey:@"wafi_mac"];

    __block StartBrAgent * blockSelf = [[StartBrAgent alloc] init];
    
    blockSelf.postHttpNum = 0;
    
    [BrAgent onFraud:loginInfo completion:^(NSError* error,id feedback)
    {
        NSLog(@"feedback is %@",feedback);
        if(!error)
        {
            if ([[feedback objectForKey:@"code"]isEqualToString:@"true"])
            {
                _type = @"antifraud_lend";
                NSArray *array = [(NSDictionary *)feedback objectForKey:@"response"];
                NSString *str = [array[0] objectForKey:@"af_swift_number"];
                NSString *event = @"A501";
                [blockSelf sendStr:str event:event];
            }
        }else
        {
            [Bugly reportError:error];
            NSLog(@"百融error=%@",error);
        }
    }];
    return nil;
}
//注册（实名）
+ (NSString *)startBrAgentregister
{
    NSString *latitude = [NSString stringWithFormat:@"%f",[AppDelegate delegate].mapLocation.myCoordinate2D.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",[AppDelegate delegate].mapLocation.myCoordinate2D.longitude];
    
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc]init];
    [loginInfo setObject:MyCid forKey:@"cid"];
    [loginInfo setObject:@"register" forKey:@"event"];
    [loginInfo setObject:@"antifraud" forKey:@"app"];
    [loginInfo setObject:@"web" forKey:@"plat_type"];
    [loginInfo setObject:StringOrNull(latitude) forKey:@"latitude"];
    [loginInfo setObject:StringOrNull(longitude) forKey:@"longitude"];
    [loginInfo setObject:[NSNumber numberWithBool:YES] forKey:@"grab"];
    [loginInfo setObject:[[UIDevice currentDevice]model] forKey:@"model"];
    [loginInfo setObject:@"apple" forKey:@"brand"];
    [loginInfo setObject:StringOrNull([self getIDFA]) forKey:@"IDFA"];
    [loginInfo setObject:StringOrNull([SvUDIDTools UDID]) forKey:@"UUID"];
    [loginInfo setObject:@"false" forKey:@"is_simulator"];
    [loginInfo setObject:StringOrNull([self getCurrentWifiName]) forKey:@"wafi_name"];
    [loginInfo setObject:StringOrNull([self getCurrentWifiAddress]) forKey:@"wafi_mac"];
    
    __block StartBrAgent * blockSelf = [[StartBrAgent alloc] init];
    
    blockSelf.postHttpNum = 0;
    
    [BrAgent onFraud:loginInfo completion:^(NSError* error,id feedback)
     {
        NSLog(@"feedback is %@",feedback);
        if(!error)
        {
            if ([[feedback objectForKey:@"code"]isEqualToString:@"true"])
            {
                _type = @"antifraud_register";
                NSArray *array = [(NSDictionary *)feedback objectForKey:@"response"];
                NSString *str = [array[0] objectForKey:@"af_swift_number"];
                NSString *event = @"A501";
                [blockSelf sendStr:str event:event];
            }
        }else
        {
           [Bugly reportError:error];
        }
    }];
    return nil;
}

- (void)sendStr:(NSString *)str event:(NSString *)event{
    
    _postHttpNum++;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realId] forKey:@"idNo"];
    [dic setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realTel] forKey:@"mobile"];
    [dic setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realName] forKey:@"name"];
    [dic setObject:event forKey:@"dataTyp"];
    [dic setObject:@"2" forKey:@"source"];
    [dic setObject:_type forKey:@"reserved7"];
    NSMutableArray *listArray = [[NSMutableArray alloc]init];
    [listArray addObject:str];
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSString *jack=[EnterAES simpleEncrypt:listArray[0]];
    
    if([_type isEqualToString:@"antifraud_lend"]){
        NSMutableArray *judgeArray  = [[NSMutableArray alloc]init];
        [dic setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"reserved6"];
        if ([AppDelegate delegate].userInfo.applSeq.length > 0) {
            
            [dic setObject:[AppDelegate delegate].userInfo.applSeq forKey:@"applSeq"];
            
        }
        
        NSMutableDictionary *parmOne = [[NSMutableDictionary alloc]init];
        
        if ([AppDelegate delegate].userInfo.af_swift_number.length > 0){
            
            NSString *rose = [EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.af_swift_number];
            
            [parmOne setObject:rose forKey:@"content"];
            
            [parmOne setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"reserved6"];
            
            [parmOne setObject:@"antifraud_login" forKey:@"reserved7"];
            
        }
        
        NSMutableDictionary *parmTwo = [[NSMutableDictionary alloc]init];
        
        [parmTwo setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"reserved6"];
        
        [parmTwo setObject:@"antifraud_lend" forKey:@"reserved7"];

        [parmTwo setObject:jack forKey:@"content"];
        
        [judgeArray addObject:parmOne];
        
        [judgeArray addObject:parmTwo];
        
        [array addObject:judgeArray];
        
    }else{
        
        [array addObject:jack];
    }

    [dic setObject:array forKey:@"content"];
    
    [[BSVKHttpClient shareInstance] POST:@"app/appserver/updateRiskInfo" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        UpdateRiskInfoModel *infoModel = [UpdateRiskInfoModel mj_objectWithKeyValues:responseObject];
        
        if ([infoModel.response.head.retFlag isEqualToString:SucessCode])
        {
             NSLog(@"百融风险采集成功啦");
            
            _postHttpNum = 0;
            
            
        }else{
            
            if (_postHttpNum == 1) {
                
                if ([event isEqualToString:@"antifraud_lend"]){
                    
                    [StartBrAgent startBrAgentlend];
                    
                }else{
                    
                    [StartBrAgent startBrAgentregister];
                    
                }
                
                
            }else{
                
                _postHttpNum = 0;
                
            }
  
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (_postHttpNum == 1) {
            
            if ([event isEqualToString:@"antifraud_lend"]){
              
                [StartBrAgent startBrAgentlend];
                
            }else{
                
                [StartBrAgent startBrAgentregister];
                
            }
            
            
        }else{
            
            _postHttpNum = 0;
            
        }
        
        [Bugly reportError:error];
        
    }];
}

#pragma mark - 得到广告标示
+ (NSString *)getIDFA
{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if(idfa && ![idfa isEqualToString:@""])
    {
        return idfa;
    }else
        return @"";
}

#pragma mark - 当前连接的wafi的名称
+ (NSString *)getCurrentWifiName
{
    NSString *wifiName = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
        }
        CFRelease(myArray);
    }
    NSLog(@"wifiName:%@", wifiName);
    return wifiName;
}

#pragma mark - 当前连接wafi的ip地址
+ (NSString *)getCurrentWifiAddress
{
    NSString *wifiAddress = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiAddress = [dict valueForKey:@"BSSID"];
        }
        CFRelease(myArray);
    }
    return wifiAddress;
}

@end
