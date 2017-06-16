//
//  BSVKHttpClient.h
//  Base
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 apple-2. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/*
 封测环境
 */


//static NSString const *baseUrl = @"http://10.164.194.123:9001/";
//
//#define ImageUrl(str) ([NSString stringWithFormat:@"http://10.164.194.123:9001/app/appserver/attachPic?attachId=%@",str])

/*
 9000测试
 */

//static NSString const *baseUrl = @"https://testpm.haiercash.com:9000/";
//
//#define ImageUrl(str) ([NSString stringWithFormat:@"https://testpm.haiercash.com:9000/app/appserver/attachPic?attachId=%@",str])

/*
 新版测试环境
 */

static NSString const *baseUrl = @"http://10.164.194.123:9000/";

#define ImageUrl(str) ([NSString stringWithFormat:@"http://10.164.194.123:9000/app/appserver/attachPic?attachId=%@",str])

/*
 正式环境
 */

//static NSString const *baseUrl = @"https://app.haiercash.com:6688/";

//#define ImageUrl(str) ([NSString stringWithFormat:@"https://app.haiercash.com:6688/app/appserver/attachPic?attachId=%@",str])

/*
 错误提示
 */

#define TkokenError @"Request failed: unauthorized (401)"

@protocol BSVKHttpClientDelegate <NSObject>

@optional
//成功
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className;
//失败
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className;



//文件成功
- (void)putFileSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className arrIndex:(NSInteger)index;

//文件失败
- (void)putFileFail:(NSInteger)requestTag requestError:(NSError *)error requestClass:(NSString *)className arrIndex:(NSInteger)index;



//下载文件
- (void)downFile:(NSInteger)requestTag theFilePath:(NSURL *)filePath requestError:(NSError *)error;
- (void)downFileProgress:(NSInteger)requestTag bytesWritten:(int64_t)totalBytesWritten expectedWrite:(int64_t)totalBytesExpectedToWrite;

//上传单个文件
- (void)upFile:(NSInteger)requestTag theFilePath:(NSString *)filePath requestError:(NSError *)error;
//上传多个文件
- (void)upFiles:(NSInteger)requestTag requestError:(NSError *)error;



//带返回参数

//成功
- (void)requestSucessWithParam:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className withParam:(NSDictionary *)dict;
//失败
- (void)requestFailWithParam:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className withParam:(NSDictionary *)dict;


@end

/*
 文件下载的目录  //缓存中  NSCachesDirectory  不备份 许手动删除
 */

@interface BSVKHttpClient : AFHTTPSessionManager

@property (nonatomic, weak)id <BSVKHttpClientDelegate> delegate;

+ (BSVKHttpClient *)shareInstance;
+ (AFSecurityPolicy *)setHttps;

- (void)setTokenInHead :(NSString *)strToken tokenType:(NSString *)type;


// GET 请求
- (NSURLSessionDataTask *)getInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className;
// POST 请求
- (NSURLSessionDataTask *)postInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className;

// PUT 请求
- (NSURLSessionDataTask *)putInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className;

//Delete 请求
- (NSURLSessionDataTask *)deleteInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className;


// 下载文件
- (NSURLSessionDownloadTask *)downFile:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className;

// 上传单个文件
//- (NSURLSessionDataTask *)upFile:(NSString *)requestUrl requestArgument:(NSString *)fileParam requestTag:(NSInteger)tag requestClass:(NSString *)className;


//上传文件
- (NSURLSessionDataTask *)puFile:(NSString *)requestUrl requestArgument:(NSDictionary *)params fileData:(NSData *)fData fileName:(NSString *)filename name:(NSString *)passName mimeType:(NSString *)mimeType requestTag:(NSInteger)tag requestClass:(NSString *)className;

- (NSURLSessionDataTask *)puFile:(NSString *)requestUrl requestArgument:(NSDictionary *)params fileData:(NSData *)fData fileName:(NSString *)filename name:(NSString *)passName mimeType:(NSString *)mimeType requestTag:(NSInteger)tag arrIndex:(NSInteger)index requestClass:(NSString *)className;



//// 上传单个文件
//- (NSURLSessionDataTask *)upFileWithData:(NSString *)requestUrl withParam:(NSDictionary *)dictParma fileInfo:(NSData *)file requestTag:(NSInteger)tag requestClass:(NSString *)className;



// 上传多个文件
- (NSURLSessionDataTask *)upFiles:(NSString *)requestUrl requestArgument:(NSArray *)filesParam requestTag:(NSInteger)tag requestClass:(NSString *)className;


//上传文件
- (NSURLSessionDataTask *)puFile:(NSString *)requestUrl requestArgument:(NSDictionary *)params fileData:(NSData *)fData fileName:(NSString *)filename name:(NSString *)passName mimeType:(NSString *)mimeType completion:( void (^)(id results, NSError *error) )completion;


- (NSURLSessionDataTask *)puFileIndex:(NSString *)requestUrl requestArgument:(NSDictionary *)params fileData:(NSData *)fData fileName:(NSString *)filename name:(NSString *)passName mimeType:(NSString *)mimeType requestTag:(NSInteger)tag arrIndex:(NSInteger)index requestClass:(NSString *)className;


//GET 请求
- (NSURLSessionDataTask *)getInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion;

//POST 请求
- (NSURLSessionDataTask *)postInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion;

//PUT 请求
- (NSURLSessionDataTask *)putInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion;


//- (void)putSyncInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion;

// 影像删除 适用于影像的情况

//Delete 请求
- (NSURLSessionDataTask *)deleteInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params requestTag:(NSInteger)tag requestClass:(NSString *)className with:(NSDictionary *)dict;


//上传文件
- (NSURLSessionDataTask *)putFile:(NSString *)requestUrl requestArgument:(NSDictionary *)params fileData:(NSData *)fData fileName:(NSString *)filename name:(NSString *)passName mimeType:(NSString *)mimeType completion:( void (^)(id results, NSError *error) )completion;

@end
