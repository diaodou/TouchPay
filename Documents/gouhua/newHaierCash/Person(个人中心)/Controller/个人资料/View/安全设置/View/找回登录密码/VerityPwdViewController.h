//
//  ViewController.h
//  密码设置
//
//  Created by 百思为科iOS on 16/4/4.
//  Copyright © 2016年 百思为科iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
typedef NS_ENUM(NSInteger,VerityPwdType) {

    VerityPwdChangeDealPwdByRemeber = 1,  //通过记住支付修改交易密码
    VerityPwdChangeDealPwdByNoRemeber     //通过实名认证修改交易密码
};
@interface VerityPwdViewController : HCBaseViewController
@property (nonatomic,copy)NSString *telNum;//手机号
@property (nonatomic,copy)NSString *verifyNo;//验证码
@property (nonatomic,assign)VerityPwdType verityPwdType; //枚举区分
@property(nonatomic,strong)NSString *oldPayPassWord;//旧支付密码

@end

