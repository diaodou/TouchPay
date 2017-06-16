//
//  SignModel.h
//  newHaierCash
//
//  Created by 张久健 on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class SignHead,SignBody,SignToken,SignRealInfo;
@interface SignModel : NSObject


@property (nonatomic, strong) SignHead *head;

@property (nonatomic, strong) SignBody *body;


@end
@interface SignHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface SignBody : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *userDesc;

@property (nonatomic, copy) NSString *registDt;

@property (nonatomic, copy) NSString *clientSecret;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *failedCount;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *provider;

@property (nonatomic, strong) SignToken *token;

@property (nonatomic, copy) NSString *isRealInfo;

@property (nonatomic, strong) SignRealInfo *realInfo;

//验证码信息
@property (nonatomic, copy) NSString *captchaImage;
@property (nonatomic, copy) NSString *captchaToken;

@end

@interface SignToken : NSObject

@property (nonatomic, copy) NSString *scope;

@property (nonatomic, copy) NSString *token_type;

@property (nonatomic, copy) NSString *access_token;

@property (nonatomic, assign) NSInteger expires_in;

@property (nonatomic, copy) NSString *refresh_token;

@end

@interface SignRealInfo : NSObject

@property (nonatomic, copy) NSString *acctName;

@property (nonatomic, copy) NSString *acctBankName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *custNo;

@property (nonatomic, copy) NSString *acctCity;

@property (nonatomic, copy) NSString *cardNo;

@property (nonatomic, copy) NSString *certType;

@property (nonatomic, copy) NSString *acctArea;

@property (nonatomic, copy) NSString *accBchName;

@property (nonatomic, copy) NSString *acctBankNo;

@property (nonatomic, copy) NSString *acctProvince;

@property (nonatomic, copy) NSString *certNo;

@property (nonatomic, copy) NSString *custName;

@property (nonatomic, copy) NSString *accBchCde;

@property (nonatomic, copy) NSString *acctNo;

@property (nonatomic, copy) NSString *faceValue;

@property (nonatomic, copy) NSString *faceCount;
@end
