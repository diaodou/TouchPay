//
//  LoginViewController.h
//  newHaierCash
//
//  Created by 张久健 on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignModel.h"
typedef enum{
    fromLogin,  //来自正常登录
    fromForgetGesture,  //来自忘记手势
    fromGesture,//来自手势找好登录
    fromOther  //来自个人中心修改登录密码,退出登录
}FromLoginType;

@interface LoginViewController : UIViewController

@property (nonatomic, assign) FromLoginType fromType;

//这2个属性的初始状态决定是否显示验证码行
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,strong)SignModel *model;

@end
