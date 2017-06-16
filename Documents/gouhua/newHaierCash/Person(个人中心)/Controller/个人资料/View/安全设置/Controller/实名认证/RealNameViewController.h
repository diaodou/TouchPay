//
//  RealNameViewController.h
//  personMerchants
//
//  Created by LLM on 2017/1/3.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
typedef NS_ENUM(NSInteger,RealNameChageBindPhoneNumType)
{
    RealNameChageBindPhoneNumByRealNameType = 1, //实名认证修改绑定手机号
    RealNameChangeDealPwdByNoRemeber,            //实名认证修改支付密码
    RealNameChangeLoginPwdByRealName             //实名认证修改登录密码
};

@interface RealNameViewController : HCBaseViewController

@property (nonatomic, assign)RealNameChageBindPhoneNumType realNameChageBindPhoneNumType;
@property (nonatomic, copy) NSString *strTel;//输入的登录号

@end
