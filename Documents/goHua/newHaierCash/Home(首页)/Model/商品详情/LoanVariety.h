//
//  LoanVariety.h
//  personMerchants
//
//  Created by 张久健 on 16/6/10.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoanVeretyHead,LoanVerietyBody;
@interface LoanVariety : NSObject

@property (nonatomic, strong) LoanVeretyHead *head;

@property (nonatomic, strong) LoanVerietyBody *body;

@end
@interface LoanVeretyHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface LoanVerietyBody : NSObject

@property (nonatomic, copy) NSString *typGrp;

@property (nonatomic, copy) NSString *docChannel;

@property (nonatomic, copy) NSString *typFreq;

@property (nonatomic, copy) NSString *typCde;

@property (nonatomic, copy) NSString *dueDayOpt;

@property (nonatomic, copy) NSString *dnOpt;

@property (nonatomic, copy) NSString *minAmt;

@property (nonatomic, copy) NSString *tnrMaxTnr;

@property (nonatomic, copy) NSString *startDt;

@property (nonatomic, copy) NSString *goodMaxNum;

@property (nonatomic, assign) NSInteger dueDay;

@property (nonatomic, copy) NSString *dnTyp;

@property (nonatomic, copy) NSString *levelTwo;

@property (nonatomic, copy) NSString *typSts;

@property (nonatomic, copy) NSString *tnrOpt;

@property (nonatomic, copy) NSString *custTyp;

@property (nonatomic, copy) NSString *maxAmt;

@property (nonatomic, copy) NSString *tnrMaxDays;

@property (nonatomic, copy) NSString *payMtdDesc;

@property (nonatomic, copy) NSString *autoDnInd;

@property (nonatomic, copy) NSString *typCdeShort;

@property (nonatomic, copy) NSString *typDesc;

@property (nonatomic, assign) NSInteger typSeq;

@property (nonatomic, copy) NSString *payTyp;

@property (nonatomic, copy) NSString *payMtd;

@property (nonatomic, assign) NSInteger typVer;

@property (nonatomic, copy) NSString *levelOne;

@property (nonatomic, copy) NSString *payOpt;

@property (nonatomic, copy) NSString *endDt;

@end

