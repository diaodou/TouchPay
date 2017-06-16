//
//  AllLoanModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class AllLoanHead,AllLoanBody,AllLoanOrders;
@interface AllLoanModel : NSObject


@property (nonatomic, strong) AllLoanHead *head;

@property (nonatomic, strong) AllLoanBody *body;


@end
@interface AllLoanHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface AllLoanBody : NSObject

@property (nonatomic, strong) NSArray<AllLoanOrders *> *orders;

@end

@interface AllLoanOrders : NSObject

@property (nonatomic, copy) NSString *outSts;

@property (nonatomic, copy) NSString *mthAmt;

@property (nonatomic, copy) NSString *typGrp;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, copy) NSString *applyDt;

@property (nonatomic, copy) NSString *applSeq;

@property (nonatomic, copy) NSString *applyAmt;

@property (nonatomic, copy) NSString *applyTnr;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *applyTnrTyp;

@property (nonatomic, copy) NSString *apprvAmt;

@property (nonatomic, copy) NSString *ifSettled;

@property (nonatomic, copy) NSString *formTyp;
@end

