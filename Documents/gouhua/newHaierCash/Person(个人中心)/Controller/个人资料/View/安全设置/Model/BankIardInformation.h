//
//  BankIardInformation.h
//  personMerchants
//
//  Created by 王晓栋 on 16/6/2.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BankInfoHead,BankInfoBody;
@interface BankIardInformation : NSObject

@property (nonatomic, strong) BankInfoHead *head;

@property (nonatomic, strong) BankInfoBody *body;

@end
@interface BankInfoHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface BankInfoBody : NSObject

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *bankNo;

@property (nonatomic, copy) NSString *cardType;

@end

