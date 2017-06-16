//
//  GetActivityInfo.m
//  newHaierCash
//
//  Created by xuxie on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "GetActivityInfo.h"
#import "BSVKSyncHttpClient.h"
#import "HCMacro.h"
#import <MJExtension.h>
#import "DefineSystemTool.h"
#import <UIKit/UIKit.h>
#import "EnterAES.h"
#import "UserSettingModel.h"
#import "HCUserModel.h"

@implementation GetActivityInfo
- ( AdvertSelectModel * _Nullable )getLanchActivityInfo {
    BSVKSyncHttpClient *clien = [[BSVKSyncHttpClient alloc]init];
    NSDictionary *dic;
    if(iphone6P)
    {
        dic = [clien sendPutRequest:@"app/appserver/ad/getAdInfoCheck?sizeType=IOS736" postData:nil httpMethod:getMothed];
    }else if (iphone6)
    {
        dic = [clien sendPutRequest:@"app/appserver/ad/getAdInfoCheck?sizeType=IOS667" postData:nil httpMethod:getMothed];
    }else if ([UIScreen mainScreen].bounds.size.height == 568)
    {
        dic = [clien sendPutRequest:@"app/appserver/ad/getAdInfoCheck?sizeType=IOS568" postData:nil httpMethod:getMothed];
    }else if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        dic = [clien sendPutRequest:@"app/appserver/ad/getAdInfoCheck?sizeType=IOS480" postData:nil httpMethod:getMothed];
    }
    
    return [AdvertSelectModel mj_objectWithKeyValues:dic];
}



- (BOOL)searchGestureInfo:(HCUserModel *_Nonnull)userInfo {
    //获取到登录账号
    if (!isEmptyString([DefineSystemTool getLastLoginTel]) && !isEmptyString([DefineSystemTool userPassword]))
    {
        //获取是否有手势密码 userId 手机号
        BSVKSyncHttpClient *clien = [[BSVKSyncHttpClient alloc]init];
        NSDictionary *dic = [clien sendPutRequest:[NSString stringWithFormat:@"app/appserver/uauth/validateUserFlag?userId=%@",[EnterAES simpleEncrypt:[DefineSystemTool getLastUserLoginId]]] postData:nil httpMethod:getMothed];
        
        UserSettingModel *model = [UserSettingModel mj_objectWithKeyValues:dic];
        if ([model.head.retFlag isEqualToString:@"00000"]) {
            if ([model.body.payPasswdFlag isEqualToString:@"0"]) {
                //没有设置支付密码
                userInfo.bsetPayPwd = NO;
            }else {
                //设置了支付密码
                userInfo.bsetPayPwd = YES;
            }
            if ([model.body.gestureFlag isEqualToString:@"0"])
            {
                userInfo.bsetGuestPwd = NO;
            }else {
                //设置了手势密码
                userInfo.bsetGuestPwd = YES;
                return YES;
            }
        }
    }
    return NO;

}
@end
