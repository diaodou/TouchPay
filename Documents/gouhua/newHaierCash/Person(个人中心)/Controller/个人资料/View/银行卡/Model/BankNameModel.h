//
//  BankNameModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/19.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BankNameHead,BankNameBody;
@interface BankNameModel : NSObject


@property (nonatomic, strong) BankNameHead *head;

@property (nonatomic, strong) NSArray<BankNameBody *> *body;


@end
@interface BankNameHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface BankNameBody : NSObject

@property (nonatomic, copy) NSString *bankCode;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *singleCollLimited; //单笔代收限额

@property (nonatomic, copy) NSString *singleTransLimited; //单笔代付限额

@end

