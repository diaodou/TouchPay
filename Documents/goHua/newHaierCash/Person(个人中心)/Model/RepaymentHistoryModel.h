//
//  RepaymentHistoryModel.h
//  personMerchants
//
//  Created by 王晓栋 on 16/5/29.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RepaymentHistoryHead,RepaymentHistoryBody;
@interface RepaymentHistoryModel : NSObject

@property (nonatomic, strong) RepaymentHistoryHead *head;

@property (nonatomic, strong) NSArray<RepaymentHistoryBody *> *body;


@end

@interface RepaymentHistoryHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface RepaymentHistoryBody : NSObject

@property (nonatomic, copy) NSString *setlRecvAmt;

@property (nonatomic, copy) NSString *setlValDt;

@property (nonatomic, copy) NSString *setlTyp;

@property (nonatomic, copy) NSString *sendSts;

@end

