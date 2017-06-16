//
//  ArrearsModel.h
//  personMerchants
//
//  Created by 张久健 on 16/6/12.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArrwarsModelMsgall;
@interface ArrearsModel : NSObject

@property (nonatomic, strong) ArrwarsModelMsgall *msgall;

@end
@interface ArrwarsModelMsgall : NSObject

@property (nonatomic, copy) NSString *errorCode;

@property (nonatomic, copy) NSString* OD_INT;

@property (nonatomic, copy) NSString* PRCP_AMT;

@property (nonatomic, copy) NSString *errorMsg;

@property (nonatomic, copy) NSString  *NORM_INT;

@property (nonatomic, copy) NSString *LOAN_NO;

@property (nonatomic, copy) NSString * FEE_AMT;

@property (nonatomic, copy) NSString * COMM_INT;

@property (nonatomic, copy) NSString * OD_AMT;

@end

