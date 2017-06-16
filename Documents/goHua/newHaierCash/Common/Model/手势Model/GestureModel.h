//
//  GestureModel.h
//  personMerchants
//
//  Created by 张久健 on 16/5/11.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GestureModelHead,GestureModelBody;
@interface GestureModel : NSObject

@property (nonatomic, strong) GestureModelHead *head;

@property (nonatomic, strong) GestureModelBody *body;

@end
@interface GestureModelHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface GestureModelBody : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userDesc;

@property (nonatomic, copy) NSString *registDt;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *provider;
@end

