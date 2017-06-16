//
//  VerifyPhoneModel.h
//  personMerchants
//
//  Created by 张久健 on 17/3/7.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PhoneHead,PhoneBody;
@interface VerifyPhoneModel : NSObject
@property (nonatomic, strong) PhoneHead *head;

@property (nonatomic, strong) PhoneBody *body;

@end

@interface PhoneHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface PhoneBody : NSObject

@property (nonatomic, copy) NSString *clientSecret;

@end
