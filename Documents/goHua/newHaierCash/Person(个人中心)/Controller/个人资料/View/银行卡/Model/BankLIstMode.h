//
//  BankLIstMode.h
//  personMerchants
//
//  Created by xuxie on 16/5/27.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BankListHead,BankListBody,BankInfo;
@interface BankLIstMode : NSObject

@property (nonatomic, strong) BankListHead *head;

@property (nonatomic, strong) BankListBody *body;

@end
@interface BankListHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end


@interface BankListBody : NSObject

@property(nonatomic, strong) NSArray<BankInfo*> *info;

@end

@interface BankInfo : NSObject

@property (nonatomic, copy) NSString *bankCode;

@property (nonatomic, copy) NSString *isDefaultCard;

@property (nonatomic, copy) NSString *cardTypeName;

@property (nonatomic, copy) NSString *isRealnameCard;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *accBchCde;

@property (nonatomic, copy) NSString *accBchName;

@property (nonatomic, copy) NSString *cardNo;

@property (nonatomic, copy) NSString *acctProvince;

@property (nonatomic, copy) NSString *acctCity;

@property (nonatomic, copy) NSString *acctArea;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *singleCollLimited;

@property (nonatomic, copy) NSString *singleTransLimited;

@end

