//
//  NewNumberViewController.h
//  personMerchants
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
//实名认证的状态
typedef NS_ENUM(NSInteger,ChangeBindPhoneNumType)
{
    ChangeBindPhoneNumByRealNameType = 1, //实名认证修改绑定手机号
    ChangeBindPhoneNumTypeByCheckCode     //短信验证修改绑定手机号
};

@interface NewNumberViewController : HCBaseViewController
@property (nonatomic, copy) NSString *veriNo;//验证码

@property (nonatomic, assign) ChangeBindPhoneNumType chageBindNumType;  //修改绑定手机号的模式

@end
