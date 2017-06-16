//
//  SystemModel.m
//  newHaierCash
//
//  Created by Will on 2017/5/25.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "UIColor+DefineNew.h"
#import "DefineSystemTool.h"

#import <CommonCrypto/CommonDigest.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <YYWebImage.h>
#import "AppDelegate.h"
#import "HCMacro.h"
static NSString *HCUserLoginTel = @"HCUserLoginTel";

static NSString *HCUserId = @"HCUserId";

static NSString *HCUserPassword = @"HCUserPassword";

static NSString *HCUserTel = @"HCUserTel";

static NSString *HCUserRememberPsd = @"HCUserRememberPsd";

static NSString *HCSystemTimeRecord = @"HCSystemTimeRecord";

static NSString *HCUserAccessToken = @"HCUserAccessToken";

@implementation DefineSystemTool

#pragma mark - 系统数据获取
#pragma mark --换肤颜色--
+ (UIColor *)dotColor {
    UIColor *color = [UIColor colorWithRed:33.0 / 225.0 green:152.0 / 255.0 blue:228.0 / 255.0 alpha:1.0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ChangeSkin" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (dictionary && dictionary.count != 0) {
        NSString *strDot = [dictionary objectForKey:@"DotColor"];
        if (strDot) {
            UIColor *colorCon = [UIColor UIColorWithHexColorString:strDot AndAlpha:1];
            if (colorCon) {
                color = colorCon;
            }
        }
    }
    return color;
}

+ (UIColor *)sepColorSkin {
    UIColor *color = [UIColor colorWithRed:33.0 / 225.0 green:152.0 / 255.0 blue:228.0 / 255.0 alpha:1.0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ChangeSkin" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (dictionary && dictionary.count != 0) {
        NSString *strDot = [dictionary objectForKey:@"SepColor"];
        if (strDot) {
            UIColor *colorCon = [UIColor UIColorWithHexColorString:strDot AndAlpha:1];
            if (colorCon) {
                color = colorCon;
            }
        }
    }
    return color;
}

+ (UIColor *)naviColor {
    UIColor *color = [UIColor colorWithRed:2.0 / 225.0 green:140.0 / 255.0 blue:229.0 / 255.0 alpha:1.0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ChangeSkin" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (dictionary && dictionary.count != 0) {
        NSString *strDot = [dictionary objectForKey:@"NaviColor"];
        if (strDot) {
            UIColor *colorCon = [UIColor UIColorWithHexColorString:strDot AndAlpha:1];
            if (colorCon) {
                color = colorCon;
            }
        }
    }
    return color;
}

+ (UIColor *)tabBarColor {
    UIColor *color = [UIColor colorWithRed:2.0 / 225.0 green:140.0 / 255.0 blue:229.0 / 255.0 alpha:1.0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ChangeSkin" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (dictionary && dictionary.count != 0) {
        NSString *strDot = [dictionary objectForKey:@"TabBarColor"];
        if (strDot) {
            UIColor *colorCon = [UIColor UIColorWithHexColorString:strDot AndAlpha:1];
            if (colorCon) {
                color = colorCon;
            }
        }
    }
    return color;
}

#pragma mark --系统数据获取--

+(BOOL)isGetCameraPermission{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusAuthorized){
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}

+(BOOL)isGetPhotoPermission{
    
    if (IOS9_OR_LATER) {
        
        PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
        
        if (photoAuthorStatus == PHAuthorizationStatusAuthorized) {
            
            return YES;
            
        }else{
            
            return NO;
            
        }
        
        
    }else{
        
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        
        if (status == ALAuthorizationStatusAuthorized) {
            
            return YES;
        }else{
            
            return NO;
        }
        
    }
    
}



+ (NSString *)VersionShort{
    NSString *localVer = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    return localVer;
}

#pragma mark - 数据存取
#pragma mark --YYCache--
- (void) requestImageFrom:(YYCache *)imageCache WithStr:(NSString *)imageStr completion:(ImageComplationBlock)complation {
    id object = [imageCache objectForKey:imageStr];
    if ([object isKindOfClass:[UIImage class]]) {
        complation(YES,(UIImage *)object);
    } else if ([object isKindOfClass:[NSData class]]) {
        UIImage *image = [UIImage imageWithData:(NSData *)object];
        complation(YES,image);
    } else {
        [[YYWebImageManager sharedManager]requestImageWithURL:[NSURL URLWithString:imageStr] options:YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (image) {
                [imageCache setObject:image forKey:url.absoluteString];
                complation(YES,image);
            }
            complation(NO,nil);
        }];
        
    }
}


#pragma mark --NSUserDefault--

//登录手机号存取 可为nil
+ (void)storeLastLoginTel:(NSString *)LoginTel {
    [[NSUserDefaults standardUserDefaults]setValue:LoginTel forKey:HCUserLoginTel];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+ (NSString *)getLastLoginTel {
    return [[NSUserDefaults standardUserDefaults]valueForKey:HCUserLoginTel];
}

//用户ID 可为nil
+ (void)storeLastUserLoginId:(NSString *)LoginId {
    [[NSUserDefaults standardUserDefaults]setValue:LoginId forKey:HCUserId];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString *)getLastUserLoginId {
    return [[NSUserDefaults standardUserDefaults]valueForKey:HCUserId];
}

//密码 可为nil
+ (NSString *)userPassword {
    return [[NSUserDefaults standardUserDefaults]objectForKey:HCUserPassword];
}

+ (void)setUserPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults]setObject:password forKey:HCUserPassword];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//用户绑定手机号存取 可为nil
+ (void)storeLastUserTel:(NSString *)UserTel {
    [[NSUserDefaults standardUserDefaults]setValue:UserTel forKey:HCUserTel];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString *)getLastUserTel {
    return [[NSUserDefaults standardUserDefaults]valueForKey:HCUserTel];
}

+ (BOOL)isRemeberPwd{

    NSString *isRemeber = [[NSUserDefaults standardUserDefaults]objectForKey:HCUserRememberPsd];
    if ([isRemeber isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}

+ (void)setRemeberPwd:(BOOL)bRemeberYes{
    if (bRemeberYes) {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:HCUserRememberPsd];
    }else {
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:HCUserRememberPsd];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

//存储进入后台的时候
+ (void)storeEnterBackTime {
    NSDate *nowDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults]setObject:nowDate forKey:HCSystemTimeRecord];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
//从后台进入后台的时候
+ (BOOL)judgeFiveMActive {
    NSDate *nowDate = [NSDate date];
    NSDate *preDate = [[NSUserDefaults standardUserDefaults]objectForKey:HCSystemTimeRecord];
    if (preDate) {
        NSTimeInterval second = [nowDate timeIntervalSinceDate:preDate];
        if (second > 5*60) {
            return YES;
        }
    }
    return NO;
}
//走launch 的时候
+ (void)clearInitTime {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:HCSystemTimeRecord];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


//存取Token 不可为nil
+ (NSString *)getAccessToken {
    return [[NSUserDefaults standardUserDefaults]valueForKey:HCUserAccessToken];
}

+ (void)storeAccessToken:(NSString *)access_token {
    NSString *tempToken = @"";
    if ([access_token isKindOfClass:[NSString class]] && access_token.length != 0) {
        tempToken = access_token;
    }
    [[NSUserDefaults standardUserDefaults]setObject:tempToken forKey:HCUserAccessToken];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - PList

//code转化为文字
+(nullable NSString *)codeWithString:(NSString *)Name WithType:(NSString *)type{
    
    NSMutableArray *dictArr =  [self plistValuesWithType:type];
    NSString *string = [NSString string];
    if (dictArr.count==0) {
        return nil;
    }
    for (NSMutableDictionary  *dic in dictArr) {
        NSArray *arr = [dic allKeys];
        for (NSString *key in arr) {
            if ([Name isEqualToString:[dic valueForKey:key]]) {
                string = key;
            }
        }
        
    }
    return string;
    
}

//获取本地plist表
+(nullable NSMutableArray *)plistValuesWithType:(NSString *)type{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@person.plist",type]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    // 在这里做判断，看看plist中有没有东西
    if ([dict  valueForKey:type]) {
        return [dict  valueForKey:type];
    }else{
        return nil;
    }
    
}

+(nullable NSString *)stringForCode:(NSString *)code WithType:(NSString *)type{
    
    NSString *string = [NSString string];
    
    NSMutableArray *dictArr =  [self plistValuesWithType:type];
    if (dictArr.count==0) {
        return nil;
    }
    for (NSMutableDictionary  *dic in dictArr) {
        if ([[[dic allKeys] lastObject]isEqualToString:code]) {
            string = [dic valueForKey:code];
        }
    }
    
    return string;
    
}


#pragma mark - PList
+ (void)insert:(DictionarisModel *)model{
    BOOL haveDic1 = [self insert:model getArray:model.body.LOCAL_RESID AndType:@"LOCAL_RESID"];
    
    BOOL haveDic2 = [self insert:model getArray:model.body.POSITION AndType:@"POSITION"];
    
    BOOL haveDic3 = [self insert:model getArray:model.body.COM_KIND AndType:@"COM_KIND"];
    
    BOOL haveDic4 = [self insert:model getArray:model.body.POSITION_OPT AndType:@"POSITION_OPT"];
    
    BOOL haveDic5 = [self insert:model getArray:model.body.EDU_TYP AndType:@"EDU_TYP"];
    
    BOOL haveDic6 = [self insert:model getArray:model.body.MARR_STS AndType:@"MARR_STS"];
    
    BOOL haveDic7 = [self insert:model getArray:model.body.CURR_SITUATION AndType:@"CURR_SITUATION"];
    
    BOOL haveDic8 = [self insert:model getArray:model.body.PPTY_LIVE_OPT AndType:@"ppty_live_opt"];
    
    BOOL haveDic9 = [self insert:model getArray:model.body.MAIL_ADDR AndType:@"MAIL_ADDR"];
    
    BOOL haveDic10 = [self insert:model getArray:model.body.RELATION AndType:@"RELATION"];
    
    if (haveDic1 && haveDic2 && haveDic3 && haveDic4 && haveDic5 && haveDic6 && haveDic7 && haveDic8 && haveDic9 && haveDic10) {
        [AppDelegate delegate].userInfo.haveDictionary = YES;
    }else{
        [AppDelegate delegate].userInfo.haveDictionary = NO;
    }
}
//将数据写入沙盒中
+ (BOOL)insert:(DictionarisModel *)model getArray:(NSArray *)nameArray AndType:(NSString *)type{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@person.plist",type]];
    // 存放字典（code - name）的数组数组已经完成
    NSMutableArray *array = [NSMutableArray array];
    //    code 为key naem 为value
    if ([nameArray isEqualToArray:model.body.PPTY_LIVE_OPT]) {
        
        for ( Ppty_Live_Opt *oneBody in model.body.PPTY_LIVE_OPT) {
            
            if (![oneBody.code isEqualToString:@"20"] && ![oneBody.name isEqualToString:@"同自有房产地址"] ){
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:oneBody.name forKeyPath:oneBody.code];
                [array addObject:dict];
            }
        }
    }else if ([nameArray isEqualToArray:model.body.MAIL_ADDR]) {
        
        for (Mail_Addr * addr in model.body.MAIL_ADDR) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:addr.name forKeyPath:addr.code];
            [array addObject:dict];
            
        }
    }else if ([nameArray isEqualToArray:model.body.RELATION]) {
        
        for (Relation * relation in model.body.RELATION) {
            
            if (![relation.name isEqualToString:@"本人"]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:relation.name forKeyPath:relation.code];
                [array addObject:dict];
            }
        }
    }else if ([nameArray isEqualToArray:model.body.CURR_SITUATION]){
        
        for (Curr_Situation * body in model.body.CURR_SITUATION) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:body.name forKeyPath:body.code];
            [array addObject:dict];
        }
    }else if ([nameArray isEqualToArray:model.body.MARR_STS]){
        
        for (Marr_Sts * body in model.body.MARR_STS) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:body.name forKeyPath:body.code];
            [array addObject:dict];
        }
    }else if ([nameArray isEqualToArray:model.body.LOCAL_RESID]){
        
        for (Local_Resid * body in model.body.LOCAL_RESID) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:body.name forKeyPath:body.code];
            [array addObject:dict];
        }
    }else if ([nameArray isEqualToArray:model.body.EDU_TYP]){
        
        for (Edu_Typ * body in model.body.EDU_TYP) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:body.name forKeyPath:body.code];
            [array addObject:dict];
        }
    }else if ([nameArray isEqualToArray:model.body.POSITION_OPT]){
        
        for (Position_Opt * body in model.body.POSITION_OPT) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:body.name forKeyPath:body.code];
            [array addObject:dict];
        }
    }else if ([nameArray isEqualToArray:model.body.COM_KIND]){
        
        for (Com_Kind * body in model.body.COM_KIND) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:body.name forKeyPath:body.code];
            [array addObject:dict];
        }
    }else if ([nameArray isEqualToArray:model.body.POSITION]){
        
        for (Position * body in model.body.POSITION) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:body.name forKeyPath:body.code];
            [array addObject:dict];
        }
    }
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionary];
    //    最外层的字典key 是类型，value是字典（code - name）数组
    [plistDict setValue:array forKey:type];
    
    return [plistDict writeToFile:filePath atomically:YES];
}

#pragma mark 文件转换

+(NSString *)md5StringWithData:(NSData *)data{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
