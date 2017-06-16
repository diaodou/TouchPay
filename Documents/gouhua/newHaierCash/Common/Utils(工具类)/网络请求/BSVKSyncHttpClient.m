//
//  BSVKSyncHttpClient.m
//  HaiercashMerchantsAPP
//
//  Created by xuxie on 16/4/27.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "BSVKSyncHttpClient.h"
#import "BSVKHttpClient.h"
#import "DefineSystemTool.h"
#import "AppDelegate.h"
@implementation BSVKSyncHttpClient

- (NSDictionary *)sendPutRequest:(NSString *)strUrl postData:(NSDictionary *)dictParam httpMethod:(httpMethods)method{
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",strUrl,dictParam);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,strUrl]]];
    if (getMothed == method) {
        [request setHTTPMethod:@"GET"];
    }
    if (postMethod == method) {
        [request setHTTPMethod:@"POST"];
    }
    if (putMethod == method) {
        [request setHTTPMethod:@"PUT"];
    }
    request.timeoutInterval = 2;
    NSError *error;
    
    if (dictParam) {
        if (![request valueForHTTPHeaderField:@"Content-Type"]) {
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
        //应用版本号
        NSString *strVersion = [NSString stringWithFormat:@"IOS-P-%@",[DefineSystemTool VersionShort]];
        
        if (strVersion.length > 0 && strVersion) {
            
            [request setValue:strVersion forHTTPHeaderField:@"APPVersion"];
            
        }
        
        //设备号
        NSString *strDevice = [NSString stringWithFormat:@"IOS-P-%@",[[UIDevice currentDevice]model]];
        
        if (strDevice && strDevice.length > 0) {
            
            [request setValue:strDevice forHTTPHeaderField:@"DeviceModel"];
            
        }
        
        [request setValue:@"14" forHTTPHeaderField:@"channel"];
        //系统版本
        NSString *string =  [[UIDevice currentDevice]model];
        
        if (string && string.length > 0) {
            
            [request setValue:string forHTTPHeaderField:@"SysVersion"];
            
        }
        
        //设备分辨率
        int iWidth = [UIScreen mainScreen].bounds.size.width;
        
        int iHeight = [UIScreen mainScreen].bounds.size.height;
        
        NSString *strR = [NSString stringWithFormat:@"IOS-P-%d,%d",iWidth,iHeight];
        if (strR && strR.length > 0) {
            
            [request setValue:strR forHTTPHeaderField:@"DeviceResolution"];
            
        }
       /* if ([AppDelegate delegate].userInfo.whiteType&&[AppDelegate delegate].userInfo.whiteType!=WhiteNoCheck) {
            if ([AppDelegate delegate].userInfo.whiteType == WhiteA) {
                
                [request setValue:@"17" forHTTPHeaderField:@"channel_no"];
                
            }else if ([AppDelegate delegate].userInfo.whiteType == WhiteB){
                
                [request setValue:@"18" forHTTPHeaderField:@"channel_no"];
                
            }else{
                
                [request setValue:@"19" forHTTPHeaderField:@"channel_no"];
                
            }
        }*/
        
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dictParam options:0 error:&error]];
    }
    request.HTTPShouldUsePipelining = YES;
    
    __block NSDictionary *dict;
    __block NSError *requestError;
    
    dispatch_semaphore_t disp = dispatch_semaphore_create(0);
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      {
                                          if(error)
                                          {
                                              requestError = error;
                                          }else
                                          {
                                              dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          }
                                          
                                          dispatch_semaphore_signal(disp);
                                      }];
    
    [dataTask resume];
    
    dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
    
    if(requestError)
    {
        return nil;
    }else
    {
        return dict;
    }
}

@end
