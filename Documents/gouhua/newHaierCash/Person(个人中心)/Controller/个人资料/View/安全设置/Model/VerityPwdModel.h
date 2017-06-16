//
//  VerityPwdModel.h
//  personMerchants
//
//  Created by 张久健 on 16/4/28.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VerityHead,VerityBody;
@interface VerityPwdModel : NSObject

@property (nonatomic, strong) VerityHead *head;

@property(nonatomic,strong)   VerityBody *body;
@end
@interface VerityHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end
@interface VerityBody : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *userDesc;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *registDt;

@end

