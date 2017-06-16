//
//  ActivePayErModel.h
//  personMerchants
//
//  Created by 张久健 on 16/6/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ERMsgall;
@interface ActivePayErModel : NSObject

@property (nonatomic, strong) ERMsgall *msgall;

@end
@interface ERMsgall : NSObject

@property (nonatomic, copy) NSString *COMM_INT;

@property (nonatomic, copy) NSString *errorMsg;

@property (nonatomic, copy) NSString *PaymentShdList;

@property (nonatomic, copy) NSString *FEE_AMT;

@property (nonatomic, copy) NSString *OD_INT;

@property (nonatomic, copy) NSString *ActvPayShdTryList;

@property (nonatomic, copy) NSString *REL_PERD_CNT;

@property (nonatomic, copy) NSString* errorCode;

@property (nonatomic, copy) NSString *PRCP_AMT;

@property (nonatomic, copy) NSString *ACTV_PRCP;

@property (nonatomic, copy) NSString *LOAN_NO;

@property (nonatomic, copy) NSString *ACTV_NORM_INT;

@property (nonatomic, copy) NSString *NORM_INT;

@end

