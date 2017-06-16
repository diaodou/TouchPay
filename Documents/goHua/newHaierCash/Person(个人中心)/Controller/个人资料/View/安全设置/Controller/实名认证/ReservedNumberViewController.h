//
//  ReservedNumberViewController.h
//  personMerchants
//
//  Created by LLM on 2017/1/3.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
typedef NS_ENUM(NSInteger,ReservedNumberChageBindPhoneNumType)
{
    ReservedNumberChageBindPhoneNumByRealNameType = 1, //实名认证修改绑定手机号
    ReservedNumberChangeDealPwdByNoRemeber,            //实名认证修改支付密码
    ReservedNumberChangeLoginPwdByRealName             //实名认证修改登录密码

};
@interface ReservedNumberViewController : HCBaseViewController

@property (nonatomic,assign)ReservedNumberChageBindPhoneNumType reservedNumberChageBindPhoneNumType;            //枚举区分

@property (nonatomic,copy) NSString *nameText;      //姓名

@property (nonatomic,copy) NSString *idText;        //身份证

@property (nonatomic,copy) NSString *cardText;      //卡号

@property (nonatomic,copy) NSString *bankName;      //银行名称

@property (nonatomic,copy) NSString *bankType;      //银行卡类型

@property (nonatomic,copy) NSString *bankCode;

@property (nonatomic,copy) NSString *stateStr;

@property (nonatomic,copy) NSString *acctCityCode;

@property (nonatomic,copy) NSString *acctProvinceCode;

@property (nonatomic,copy) NSString *realTelNumber;

@property (nonatomic,copy) NSString *bankTel;

@property (nonatomic,copy) NSString *strTel;//输入的登录手机号

@property (nonatomic,strong) NSMutableDictionary *bankDict;

@end
