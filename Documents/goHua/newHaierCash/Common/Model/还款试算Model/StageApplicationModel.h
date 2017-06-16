//
//  StageApplicationModel.h
//  personMerchants
//
//  Created by 张久健 on 16/5/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StageApplicationModelHead,StageApplicationModelBody,StageApplicationModelMx;
@interface StageApplicationModel : NSObject

@property (nonatomic, strong) StageApplicationModelHead *head;

@property (nonatomic, strong) StageApplicationModelBody *body;

@end
@interface StageApplicationModelHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface StageApplicationModelBody : NSObject

@property (nonatomic,copy) NSString *totalFees;

@property (nonatomic, copy) NSString *totalFeeAmt;

@property (nonatomic, copy) NSString *repaymentTotalAmt;

@property (nonatomic, copy) NSString *totalNormInt;

@property (nonatomic, copy) NSString *actualArriveAmt;

@property (nonatomic, copy) NSString *deductAmt;

@property (nonatomic, strong) NSArray<StageApplicationModelMx *> *mx;

@end

@interface StageApplicationModelMx : NSObject

@property (nonatomic, assign) NSInteger psPerdNo;

@property (nonatomic, copy) NSString *instmAmt;

@end

