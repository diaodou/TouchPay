//
//  RegisterModel.h
//  personMerchants
//
//  Created by 张久健 on 16/5/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class RegisterModelHead,RegisterModelBody;
@interface RegisterModel : NSObject

@property (nonatomic, strong) RegisterModelHead *head;

@property (nonatomic, strong) RegisterModelBody *body;

@end
@interface RegisterModelHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface RegisterModelBody : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, assign) long long registDt;

@property (nonatomic, copy) NSString *provider;

@property (nonatomic, copy) NSString *alterPwd; //是否可通过手机端修改

@property (nonatomic, copy) NSString *userDesc;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *externUid;

@property (nonatomic, copy) NSString *lastFreezeDt;

@property (nonatomic, copy) NSString *gesture;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *lastLoginDt;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *payPasswd;

@property (nonatomic, copy) NSString *email;

@property(nonatomic, copy) NSString *isRegister;//手机号是否被注册过

@property (nonatomic, copy) NSString *alterPwdIn;//海尔会员重置密码入口地址

@property (nonatomic, copy) NSString *alterPwdOut;//海尔会员重置密码出口地址（返回主页地址）


@end

