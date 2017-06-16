//
//  ActivePayLoanModel.h
//  personMerchants
//
//  Created by 张久健 on 16/6/11.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActivePayLoanHead,ActivePayLoanBody,ActivePayLoanInfo;
@interface ActivePayLoanModel : NSObject

@property (nonatomic, strong) ActivePayLoanHead *head;

@property (nonatomic, strong) ActivePayLoanBody *body;

@end
@interface ActivePayLoanHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface ActivePayLoanBody : NSObject

@property (nonatomic, strong) NSArray<ActivePayLoanInfo *> *activePayLoanList;

@end

@interface ActivePayLoanInfo : NSObject

@property (nonatomic, copy) NSString *loanNo;

@property (nonatomic, copy) NSString *isSuccess;

@property (nonatomic, copy) NSString *realPayMoney;


@end

