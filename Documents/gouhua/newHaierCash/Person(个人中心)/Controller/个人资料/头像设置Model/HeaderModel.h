//
//  HeaderModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/11.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class HeaderHead,HeaderBody;
@interface HeaderModel : NSObject


@property (nonatomic, strong) HeaderHead *head;

@property (nonatomic, strong) HeaderBody *body;


@end
@interface HeaderHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface HeaderBody : NSObject

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

