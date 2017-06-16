//
//  IndetityStore.h
//  personMerchants
//
//  Created by xuxie on 16/6/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IdentityStoreHead,IdentityStoreBody;
@interface IndetityStore : NSObject

@property (nonatomic, strong) IdentityStoreHead *head;

@property (nonatomic, strong) NSArray<IdentityStoreBody *> *body;

@end
@interface IdentityStoreHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface IdentityStoreBody : NSObject

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *merchName;

@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, copy) NSString *storeNo;

@property (nonatomic, copy) NSString *invitTagid;

@property (nonatomic, copy) NSString *merchNo;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userId;

@end

