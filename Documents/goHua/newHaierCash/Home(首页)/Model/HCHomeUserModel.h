//
//  CheckEdApplModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/10/12.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HCHomeUserHead,HCHomeUserBody;
@interface HCHomeUserModel : NSObject


@property (nonatomic, strong) HCHomeUserHead *head;

@property (nonatomic, strong) HCHomeUserBody *body;


@end
@interface HCHomeUserHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface HCHomeUserBody : NSObject

@property (nonatomic, copy) NSString *custNo;

@property (nonatomic, copy) NSString *acctBankName;

@property (nonatomic, copy) NSString *cardNo;

@property (nonatomic, copy) NSString *certNo;

@property (nonatomic, copy) NSString *acctBankNo;

@property (nonatomic, copy) NSString *custname;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *acctCity;

@property (nonatomic, copy) NSString *acctProvince;

@property (nonatomic, copy) NSString *crdAmt;

@property (nonatomic, copy) NSString *crdNorAmt;

@property (nonatomic, copy) NSString *crdNorAvailAmt;

@property (nonatomic, copy) NSString *crdComAvailAnt;

@property (nonatomic, copy) NSString *crdComAmt;

@property (nonatomic, copy) NSString *crdSts;

@property (nonatomic, copy) NSString *outSts;

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *cardType;//不用了

@property (nonatomic, copy) NSString *certType;

@property (nonatomic, copy) NSString *applType;

@property (nonatomic, copy) NSString *outStsName;

@property (nonatomic, copy) NSString *crdSeq;

@property (nonatomic, copy) NSString *expectCredit;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *totalPoints;


@end

