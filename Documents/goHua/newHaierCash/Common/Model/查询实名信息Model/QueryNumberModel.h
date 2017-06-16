//
//  QueryNumberModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/27.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QueryNumberHead,QueryNumberBody;
@interface QueryNumberModel : NSObject

@property (nonatomic, strong) QueryNumberHead *head;

@property (nonatomic, strong) QueryNumberBody *body;

@end

@interface QueryNumberHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface QueryNumberBody : NSObject

@property (nonatomic, copy) NSString *acctName;

@property (nonatomic, copy) NSString *acctBankName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *custNo;

@property (nonatomic, copy) NSString *acctCity;

@property (nonatomic, copy) NSString *cardNo;

@property (nonatomic, copy) NSString *certType;

@property (nonatomic, copy) NSString *acctArea;

@property (nonatomic, copy) NSString *accBchName;

@property (nonatomic, copy) NSString *acctBankNo;

@property (nonatomic, copy) NSString *acctProvince;

@property (nonatomic, copy) NSString *certNo;

@property (nonatomic, copy) NSString *custName;

@property (nonatomic, copy) NSString *accBchCde;

@property (nonatomic, copy) NSString *acctNo;

@property (nonatomic, copy) NSString *faceValue;

@property (nonatomic, copy) NSString *faceCount;

@end

