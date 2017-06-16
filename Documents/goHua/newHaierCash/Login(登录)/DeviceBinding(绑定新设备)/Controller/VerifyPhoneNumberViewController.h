//
//  VerifyPhoneNumberViewController.h
//  personMerchants
//
//  Created by 张久健 on 17/3/6.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
@interface VerifyPhoneNumberViewController : HCBaseViewController
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *fieldName;
@property (nonatomic, copy) NSString *fieldPass;//登录密码
@property (nonatomic, assign) BOOL boRemember;//是否记住密码
@end
