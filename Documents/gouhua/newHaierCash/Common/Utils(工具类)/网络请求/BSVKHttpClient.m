//
//  BSVKHttpClient.m
//  Base
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 apple-2. All rights reserved.
//

#import "HCMacro.h"

#import "BSVKHttpClient.h"
#import "DefineSystemTool.h"
#import <YYWebImage.h>
#import "SvUDIDTools.h"
#import <UIImageView+WebCache.h>
#import "EnterAES.h"
#import "AppDelegate.h"

@implementation BSVKHttpClient
{
    BOOL bReflashToken;
}
+ (BSVKHttpClient *)shareInstance {
    static BSVKHttpClient *_shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:(NSString *)baseUrl];
        
        //设置配置
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _shareClient = [[BSVKHttpClient alloc] initWithBaseURL:url
                                          sessionConfiguration:config];
        _shareClient.responseSerializer = [AFJSONResponseSerializer serializer];
        [_shareClient setRequestSerializer:[AFJSONRequestSerializer serializer]];
        _shareClient.requestSerializer = [BSVKHttpClient setQuest];
        _shareClient.requestSerializer.timeoutInterval = 50;
        _shareClient.securityPolicy = [BSVKHttpClient setHttps];
        
    });
    return _shareClient;
}

- (NSURLSessionDataTask *)getInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className{
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    NSURLSessionDataTask *task = [self GET:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucess:requestResult:requestClass:)] && className) {
                [self.delegate requestSucess:tag requestResult:responseObject requestClass:className];
            }
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:requestError:httpCode: requestClass:)] && className) {
                [self.delegate requestFail:tag requestError:nil httpCode:httpResponse.statusCode requestClass:className];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //Token失效
        [self reflashToken:error];
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:requestError:httpCode:requestClass:)] && className) {
            [self.delegate requestFail:tag requestError:error httpCode:0 requestClass:className];
        }
    }];
    return task;
}

-(void)setDelegate:(id<BSVKHttpClientDelegate>)delegate{
    
    _delegate = delegate;
    
}

- (NSURLSessionDataTask *)postInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className{
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    NSURLSessionDataTask *task = [self POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucess:requestResult:requestClass:)] && className) {
                [self.delegate requestSucess:tag requestResult:responseObject requestClass:className];
            }
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:requestError:httpCode: requestClass:)] && className) {
                [self.delegate requestFail:tag requestError:nil httpCode:httpResponse.statusCode requestClass:className];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //Token失效
        [self reflashToken:error];
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:requestError:httpCode:requestClass:)] && className) {
            [self.delegate requestFail:tag requestError:error httpCode:0 requestClass:className];
        }
    }];
    return task;
}


- (NSURLSessionDataTask *)putInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className{
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    NSURLSessionDataTask *task = [self PUT:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucess:requestResult:requestClass:)] && className) {
                [self.delegate requestSucess:tag requestResult:responseObject requestClass:className];
            }
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:requestError:httpCode:requestClass:)]&& className) {
                [self.delegate requestFail:tag requestError:nil httpCode:httpResponse.statusCode requestClass:className];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //Token失效
        [self reflashToken:error];
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:requestError:httpCode:requestClass:)] && className) {
            [self.delegate requestFail:tag requestError:error httpCode:0 requestClass:className];
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)deleteInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className {
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    NSURLSessionDataTask *task = [self DELETE:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucess:requestResult:requestClass:)] && className) {
                [self.delegate requestSucess:tag requestResult:responseObject requestClass:className];
            }
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:requestError:httpCode:requestClass:)]&& className) {
                [self.delegate requestFail:tag requestError:nil httpCode:httpResponse.statusCode requestClass:className];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self reflashToken:error];
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:requestError:httpCode:requestClass:)] && className) {
            [self.delegate requestFail:tag requestError:error httpCode:0 requestClass:className];
        }
    }];
    return task;
}




- (NSURLSessionDownloadTask *)downFile:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className{
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    __block NSString *strName;
    if (params.allValues.count > 0) {
        strName = params.allValues[0];
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *urlPath = [documentsDirectoryURL URLByAppendingPathComponent:strName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:urlPath.path]){
            if ([[NSFileManager defaultManager] isDeletableFileAtPath:urlPath.path]) {
                [[NSFileManager defaultManager]removeItemAtPath:urlPath.path error:nil];
            }
        }
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request setValue:[self.requestSerializer.HTTPRequestHeaders valueForKey:@"Authorization"]forHTTPHeaderField:@"Authorization"];
    [request setValue:[self.requestSerializer.HTTPRequestHeaders valueForKey:@"access_token"]forHTTPHeaderField:@"access_token"];
    [request setValue:[self.requestSerializer.HTTPRequestHeaders valueForKey:@"channel"]forHTTPHeaderField:@"channel"];
    /*if ([AppDelegate delegate].userInfo.whiteType&&[AppDelegate delegate].userInfo.whiteType!=WhiteNoCheck) {
        if ([AppDelegate delegate].userInfo.whiteType == WhiteA) {
            
            [request setValue:@"17" forHTTPHeaderField:@"channel_no"];
            
        }else if ([AppDelegate delegate].userInfo.whiteType == WhiteB){
            
            [request setValue:@"18" forHTTPHeaderField:@"channel_no"];
            
        }else{
            
            [request setValue:@"19" forHTTPHeaderField:@"channel_no"];
            
        }

    }*/
    NSProgress *kProgress = nil;
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (200 == httpResponse.statusCode) {
            if (!strName) {
                strName = [response suggestedFilename];
            }
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:strName];
        }else {
            return nil;
        }
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self reflashToken:error];
        //[kProgress removeObserver:self forKeyPath:@"fractionCompleted"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(downFile:theFilePath:requestError:)]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (200 != httpResponse.statusCode) {
                 NSError *errorTemp = [NSError errorWithDomain:error.domain code:httpResponse.statusCode userInfo:error.userInfo];
                [self.delegate downFile:tag theFilePath:filePath requestError:errorTemp];

            }else{
                NSError *errorTemp = [NSError errorWithDomain:@"" code:httpResponse.statusCode userInfo:nil];
                [self.delegate downFile:tag theFilePath:filePath requestError:errorTemp];
            }
        }
    }];
    
    [self setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
    }];
    
    [kProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    
    [downloadTask resume];
    return downloadTask;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        // NSProgress *progress = (NSProgress *)object;
        //        NSLog(@"Progress is %f", progress.fractionCompleted);
        
    }
}




- (NSURLSessionDataTask *)upFile:(NSString *)requestUrl requestArgument:(NSString *)fileParam requestTag:(NSInteger)tag requestClass:(NSString *)className{
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,fileParam);
    
    NSURL *URL = [NSURL URLWithString:requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:fileParam];
    NSURLSessionUploadTask *uploadTask = [self uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(upFile:theFilePath:requestError:)]) {
            [self.delegate upFile:tag theFilePath:fileParam requestError:error];
        }
        if (error) {
            //Token失效
            [self reflashToken:error];
        }
    }];
    [uploadTask resume];
    return uploadTask;
}


- (NSURLSessionDataTask *)getInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion {
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    NSURLSessionDataTask *task = [self GET:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            completion(responseObject, nil);
        }else {
            completion(nil, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            //Token失效
            [self reflashToken:error];
        }
        completion(nil, error);
    }];
    return task;
}

- (NSURLSessionDataTask *)postInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion {
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    NSURLSessionDataTask *task = [self POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (completion) {
            if (httpResponse.statusCode == 200) {
                completion(responseObject, nil);
            }else {
                completion(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            //Token失效
            [self reflashToken:error];
        }
        if (completion) {
            completion(nil, error);
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)putInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion {
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    NSURLSessionDataTask *task = [self PUT:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (completion) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            if (httpResponse.statusCode == 200) {
                completion(responseObject, nil);
            }else {
                completion(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            //Token失效
            [self reflashToken:error];
        }
        if (completion) {
            completion(nil, error);
        }
    }];
    return task;
}




- (NSURLSessionDataTask *)upFiles:(NSString *)requestUrl requestArgument:(NSArray *)filesParam requestTag:(NSInteger)tag requestClass:(NSString *)className{
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,filesParam);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString *filePath in filesParam) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
        }
        
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [self uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            //Token失效
            [self reflashToken:error];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(upFiles:requestError:)]) {
            [self.delegate upFiles:tag requestError:error];
        }
    }];
    
    [uploadTask resume];
    return uploadTask;
}


- (NSURLSessionDataTask *)puFile:(NSString *)requestUrl requestArgument:(NSDictionary *)params fileData:(NSData *)fData fileName:(NSString *)filename name:(NSString *)passName mimeType:(NSString *)mimeType requestTag:(NSInteger)tag requestClass:(NSString *)className {
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    NSURLSessionDataTask *task = [self POST:requestUrl parameters:params  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fData name:passName fileName:filename mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucess:requestResult:requestClass:)] && className) {
            [self.delegate requestSucess:tag requestResult:responseObject requestClass:className];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            //Token失效
            [self reflashToken:error];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(upFiles:requestError:)]) {
            [self.delegate upFiles:tag requestError:error];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail:requestError:httpCode:requestClass:)]) {
            [self.delegate requestFail:tag requestError:error httpCode:0 requestClass:className];
        }
        
    }];
    return task;
}


- (NSURLSessionDataTask *)puFile:(NSString *)requestUrl requestArgument:(NSDictionary *)params fileData:(NSData *)fData fileName:(NSString *)filename name:(NSString *)passName mimeType:(NSString *)mimeType requestTag:(NSInteger)tag arrIndex:(NSInteger)index requestClass:(NSString *)className{
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    NSURLSessionDataTask *task = [self POST:requestUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fData name:passName fileName:filename mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(putFileSucess:requestResult:requestClass:arrIndex:)] && className) {
            [self.delegate putFileSucess:tag requestResult:responseObject requestClass:className arrIndex:index];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            //Token失效
            [self reflashToken:error];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(putFileSucess:requestResult:requestClass:arrIndex:)] && className) {
            [self.delegate putFileFail:tag requestError:error requestClass:className arrIndex:index];
        }
        
    }];
    return task;
}



- (NSURLSessionDataTask *)puFile:(NSString *)requestUrl requestArgument:(NSDictionary *)params fileData:(NSData *)fData fileName:(NSString *)filename name:(NSString *)passName mimeType:(NSString *)mimeType completion:( void (^)(id results, NSError *error) )completion {
    
    //打印接口和请求参数
    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
    
    NSURLSessionDataTask *task = [self POST:requestUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fData name:passName fileName:filename mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (completion) {
            completion (responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            //Token失效
            [self reflashToken:error];
        }
        if (completion) {
            completion (nil,error);
        }
    }];
    return task;
}

+ (AFJSONRequestSerializer *)setQuest {
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    //系统版本
    [requestSerializer setValue:[NSString stringWithFormat:@"IOS-P-%@",[DefineSystemTool VersionShort]] forHTTPHeaderField:@"APPVersion"];
    //APP 设备型号
    [requestSerializer setValue:[NSString stringWithFormat:@"IOS-P-%@",[[UIDevice currentDevice]model]] forHTTPHeaderField:@"DeviceModel"];
    //APP 设备分辨率
    NSString *deviceR = [NSString stringWithFormat:@"IOS-P-%f,%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height];
    [requestSerializer setValue:deviceR forHTTPHeaderField:@"DeviceResolution"];
    //APP 系统版本号
    [requestSerializer setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"SysVersion"];
    ;
    [requestSerializer setValue:@"14" forHTTPHeaderField:@"channel"];
    
    return requestSerializer;
}



+ (AFSecurityPolicy *)setHttps {
    #define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy defaultPolicy];
   // [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO
    //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    securityPolicy.validatesDomainName = NO;

    return securityPolicy;
}

#pragma mark - header 把token放进请求头
- (void)setTokenInHead :(NSString *)strToken tokenType:(NSString *)type{
    if (strToken && ![strToken isEqualToString:@""]) {
        [self.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",type,strToken] forHTTPHeaderField:@"Authorization"];
        [self.requestSerializer setValue:[NSString stringWithFormat:@"%@",strToken] forHTTPHeaderField:@"access_token"];
         [self.requestSerializer setValue:@"14" forHTTPHeaderField:@"channel"];
        [YYWebImageManager sharedManager].headers = self.requestSerializer.HTTPRequestHeaders;
        [YYWebImageManager sharedManager].cache = nil;
        NSLog(@"Authorization%@",[NSString stringWithFormat:@"%@ %@",type,strToken]);
        NSLog(@"access_token%@",[NSString stringWithFormat:@"%@",strToken]);
    }else {
        [self.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
}

- (void)reflashToken:(NSError *)error {
    NSLog(@"%@",[self.requestSerializer.HTTPRequestHeaders objectForKey:@"access_token"]);
    //Token失效
    //Token失效
    NSDictionary *dict = error.userInfo;
    if (dict) {
        if ([[dict valueForKey:@"NSLocalizedDescription"]isEqualToString:TkokenError]) {
            if (!bReflashToken) {
                [self.operationQueue cancelAllOperations];
                bReflashToken = YES;
            }
            NSString *strClientId = [DefineSystemTool getLastLoginTel];
            NSString *strClientPwd = [DefineSystemTool userPassword];
            [self setTokenInHead:@"" tokenType:@""];
            if (strClientId && strClientPwd)
            {
                NSString *string = [EnterAES simpleEncrypt:[NSString stringWithFormat:@"IOS-%@-%@",[SvUDIDTools UDID],strClientId]];
                NSDictionary *dict = @{@"grant_type":@"client_credentials",@"client_secret":strClientPwd,@"client_id":string};
                [self GET:@"app/appserver/token" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    NSDictionary *bodyDic = (NSDictionary *)responseObject;
                    if (bodyDic) {
                        [self setTokenInHead:[bodyDic objectForKey:@"access_token"]tokenType:[bodyDic objectForKey:@"token_type"]];
                    }
                    bReflashToken = NO;
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    bReflashToken = NO;
                }];
            }
        }
    }
}

- (void)putSyncInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion
{
    self.requestSerializer.timeoutInterval = 5;
    dispatch_queue_t queque = dispatch_queue_create("com.haier.crash",DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queque, ^{
        
        __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        __block BOOL isSuccess           = NO;
        __block NSError *error = nil;
        __block id result = nil;
        
        [self PUT:requestUrl
       parameters:params
          success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"加载成功 %@",responseObject);
             
             isSuccess = YES;
             result = responseObject;
             completion(result,nil);
             if (completion) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                 if (httpResponse.statusCode == 200) {
                     result = responseObject;
                 }
             }else {
                 
             }
             
             dispatch_semaphore_signal(sem);
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             
             NSLog(@"加载失败 %@",error);
             
             isSuccess = NO;
             
             dispatch_semaphore_signal(sem);
         }];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /* 回到主线程做进一步处理 */
            
            if(isSuccess) {
                completion(result,nil);
                result = nil;
            }else {
                completion(nil,error);
                error = nil;
            }
        });
    });
}


- (NSURLSessionDataTask *)puFileIndex:(NSString *)requestUrl requestArgument:(NSDictionary *)params fileData:(NSData *)fData fileName:(NSString *)filename name:(NSString *)passName mimeType:(NSString *)mimeType requestTag:(NSInteger)tag arrIndex:(NSInteger)index requestClass:(NSString *)className{
    NSURLSessionDataTask *task = [self POST:requestUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"%@",formData);
        
        [formData appendPartWithFileData:fData name:passName fileName:filename mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(putFileSucess:requestResult:requestClass:arrIndex:)] && className) {
            NSLog(@"------%@",responseObject);
            [self.delegate putFileSucess:tag requestResult:responseObject requestClass:className arrIndex:index];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucessWithParam:requestResult:requestClass:withParam:)] && className) {
            [self.delegate requestSucessWithParam:tag requestResult:responseObject requestClass:className withParam:params];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self reflashToken:error];
        if (self.delegate && [self.delegate respondsToSelector:@selector(putFileFail:requestError:requestClass:arrIndex:)] && className) {
            [self.delegate putFileFail:tag requestError:error requestClass:className arrIndex:index];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFailWithParam:requestError:httpCode:requestClass:withParam:)]&& className) {
            [self.delegate requestFailWithParam:tag requestError:error httpCode:0 requestClass:className withParam:params];
        }
        
    }];
    return task;
}


- (NSURLSessionDataTask *)deleteInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className with:(NSDictionary *)dict {
    NSURLSessionDataTask *task = [self DELETE:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucess:requestResult:requestClass:)] && className) {
                [self.delegate requestSucess:tag requestResult:responseObject requestClass:className];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestSucessWithParam:requestResult:requestClass:withParam:)] && className) {
                [self.delegate requestSucessWithParam:tag requestResult:responseObject requestClass:className withParam:dict];
            }
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestFailWithParam:requestError:httpCode:requestClass:withParam:)]&& className) {
                [self.delegate requestFailWithParam:tag requestError:nil httpCode:httpResponse.statusCode requestClass:className withParam:dict];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self reflashToken:error];
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFailWithParam:requestError:httpCode:requestClass:withParam:)] && className) {
            [self.delegate requestFailWithParam:tag requestError:error httpCode:0 requestClass:className withParam:dict];
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)putFile:(NSString *)requestUrl requestArgument:(NSDictionary *)params fileData:(NSData *)fData fileName:(NSString *)filename name:(NSString *)passName mimeType:(NSString *)mimeType completion:( void (^)(id results, NSError *error) )completion {
    NSURLSessionDataTask *task = [self POST:requestUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fData name:passName fileName:filename mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (completion) {
            completion (responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self reflashToken:error];
        if (completion) {
            completion (nil,error);
        }
    }];
    return task;
}

@end
