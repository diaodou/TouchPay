//
//  contectModel.h
//  personMerchants
//
//  Created by 张久健 on 16/5/7.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContactHead,ContactBody,ContactInfo;
@interface contectModel : NSObject

@property (nonatomic, strong) ContactHead *head;

@property (nonatomic, strong) ContactBody *body;

@end
@interface ContactHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface ContactBody : NSObject

@property (nonatomic, copy) NSArray <ContactInfo *>*lxrList;

@end

@interface ContactInfo : NSObject

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *contactNo;

@property (nonatomic, copy) NSString *contactAddr;

@property (nonatomic, copy) NSString *custNo;

@property (nonatomic, copy) NSString *contactMobile;

@property (nonatomic, copy) NSString *contactName;

@property (nonatomic, copy) NSString *certType;

@property (nonatomic, copy) NSString *createUser;

@property (nonatomic, copy) NSString *createDt;

@property (nonatomic, copy) NSString *officeName;

@property (nonatomic, copy) NSString *relationType;

@property (nonatomic, copy) NSString *certNo;

@property (nonatomic, copy) NSString *updateDt;

@property (nonatomic, copy) NSString *updateUser;

@property (nonatomic, copy) NSString *apptType;

@property (nonatomic, copy) NSString *status;

@end

