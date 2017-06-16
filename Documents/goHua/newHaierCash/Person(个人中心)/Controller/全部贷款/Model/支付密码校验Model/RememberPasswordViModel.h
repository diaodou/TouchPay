//
//  RememberPasswordViModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RemenmberPwdModelHead,RemenberPwdModelBody;
@interface RememberPasswordViModel : NSObject

@property (nonatomic, strong) RemenmberPwdModelHead *head;

@property (nonatomic, strong) RemenberPwdModelBody *body;

@end
@interface RemenmberPwdModelHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface RemenberPwdModelBody : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userDesc;

@property (nonatomic, copy) NSString *registDt;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *state;

@end

