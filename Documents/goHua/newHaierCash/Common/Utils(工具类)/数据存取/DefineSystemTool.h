//
//  SystemModel.h
//  newHaierCash
//
//  Created by Will on 2017/5/25.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YYCache.h>
#import "DictionarisModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^ImageComplationBlock)(BOOL isSuccess,UIImage *image);

@interface DefineSystemTool : NSObject

#pragma mark - 系统数据获取
#pragma mark --换肤颜色--
+ (UIColor *)dotColor;

+ (UIColor *)sepColorSkin;

+ (UIColor *)naviColor;

+ (UIColor *)tabBarColor;

#pragma mark --系统数据获取--
+ (NSString *)VersionShort;

//是否开启系统相机权限
+ (BOOL)isGetCameraPermission;

//是否开启系统相册权限
+ (BOOL)isGetPhotoPermission;


#pragma mark - 数据存取
#pragma mark -- YYCache --
- (void) requestImageFrom:(YYCache *)imageCache WithStr:(NSString *)imageStr completion:(ImageComplationBlock)complation;

#pragma mark --NSUserDefault--
//登录手机号 存取
+ (NSString *)getLastLoginTel;
+ (void)storeLastLoginTel:(NSString *)LoginTel;

/*
 保存最后一次登录用户的登录账号
 */
+ (void)storeLastUserLoginId:(NSString *)LoginId;
+ (NSString *)getLastUserLoginId;

//存取密码
+ (NSString *)userPassword;
+ (void)setUserPassword:(NSString *)password;

//用户绑定手机号存取
+ (void)storeLastUserTel:(NSString *)UserTel;
+ (NSString *)getLastUserTel;


+ (BOOL)isRemeberPwd;
+ (void)setRemeberPwd:(BOOL)bRemeberYes;


//时间
//存储进入后台的时候
+ (void)storeEnterBackTime;
//从后台进入后台的时候
+ (BOOL)judgeFiveMActive;
//走launch 的时候
+ (void)clearInitTime;

/*
 access_tokne
 */
+ (NSString *)getAccessToken;
+ (void)storeAccessToken:(NSString *)access_token;

#pragma mark - PList

//将code转成字符
+(nullable NSString *)stringForCode:(NSString *_Nullable)code WithType:(NSString *_Nullable)type;

//code码转化为文字

+(nullable NSString *)codeWithString:(NSString *_Nullable)Name WithType:(NSString *_Nullable)type;

//获取本地plist表
+(nullable NSMutableArray *)plistValuesWithType:(NSString *_Nullable)type;


//字典项存入字典
+ (void)insert:(DictionarisModel *)model;

+ (BOOL)insert:(DictionarisModel *)model getArray:(NSArray *)nameArray AndType:(NSString *)type;

#pragma mark 文件转换
//将文件转换为MD5
+(NSString *)md5StringWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END

