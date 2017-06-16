//
//  ChangePasswordRealNameModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/8/25.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChangePasswordRealNameHead,ChangePasswordRealNamebody;
@interface ChangePasswordRealNameModel : NSObject

@property (nonatomic, strong) ChangePasswordRealNameHead *head;

@property (nonatomic, strong) ChangePasswordRealNamebody *body;

@end

@interface ChangePasswordRealNameHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface ChangePasswordRealNamebody : NSObject

@property (nonatomic, copy) NSString *mobile;

@end