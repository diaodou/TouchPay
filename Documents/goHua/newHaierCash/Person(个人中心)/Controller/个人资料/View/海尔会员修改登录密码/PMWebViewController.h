//
//  PMWebViewController.h
//  personMerchants
//
//  Created by Will on 17/4/1.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <IMYWebView.h>
#import "MBProgressHUD.h"
#import "RMUniversalAlert.h"
#import "HCMacro.h"

typedef NS_ENUM(NSUInteger,PMWebVeiwControllerType) {
   PMWebVeiwControllerTypeCommon,          //普通页面
   PMWebVeiwControllerTypeForgotPassword,   // 海尔会员忘记密码Web页面 登录界面
   PMWebVeiwControllerTypeChangedPassword   // 海尔会员修改密码Web页面 安全设置页面

};

@protocol PMWebViewControllerDelegate;

@interface PMWebViewController : UIViewController

@property (nonatomic) PMWebVeiwControllerType webType;  //web页面类型

@property (nonatomic, strong) NSString *webUrlStr;      //链接web的Url

@property (nonatomic, strong) NSString *returnUrlStr;

@property (nonatomic,weak)id<PMWebViewControllerDelegate> webConDelegate;
@end

@protocol PMWebViewControllerDelegate <NSObject>

@optional
// 判断修改密码后是否成功
- (void) PMWebViewControllerResetPasswordWithSuccess:(BOOL)isSuccess;

@end
