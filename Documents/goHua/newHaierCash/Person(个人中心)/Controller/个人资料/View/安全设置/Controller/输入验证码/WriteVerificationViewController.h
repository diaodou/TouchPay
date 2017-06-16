//
//  WriteVerificationViewController.h
//  personMerchants
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
typedef NS_ENUM(NSInteger,WriteVerificationChageBindPhoneNumType)
{
    WriteVerificationChanageTelByCheckCode = 1, //通过短信验证修改绑定手机号
    
    WriteVerificationChangeSecondTelByCheckCode,//通过短信验证第二次输入验证码
    
//    WriteVerificationChanageTelByCheckCode,     //通过短信验证修改绑定手机号
    
    WriteVerificationChangeDealPwdByNoRemeber,  //通过实名认证修改支付密码
    
    WriteVerificationChangeDealPwdByRemeber,    //通过记住支付修改支付密码
    
    WriteVerificationChangeLoginPwdByCheckCode, //通过短信验证修改登录密码
    
    WriteVerificationChangeLoginPwdByRealName   //通过实名认证修改登录密码
};

@interface WriteVerificationViewController : HCBaseViewController

@property(nonatomic,copy)NSString *getCodeTel; //实名接受验证码的手机号

@property(nonatomic,copy)NSString *strTel;//未登录传的输入登录的手机号
@property (nonatomic,assign)WriteVerificationChageBindPhoneNumType writeVerificationChageBindPhoneNumType;
@end
