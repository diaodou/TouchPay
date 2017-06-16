//
//  ApplyModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/6.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApplyHead,ApplyBody;
@interface ApplyModel : NSObject


@property (nonatomic, strong) ApplyHead *head;

@property (nonatomic, strong) ApplyBody *body;


@end
@interface ApplyHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface ApplyBody : NSObject

@property (nonatomic, copy) NSString *crdAmt;

@property (nonatomic, copy) NSString *crdNorAvailAmt;

@property (nonatomic, copy) NSString *crdSts;

@property (nonatomic, copy) NSString *crdComAvailAnt;

@property (nonatomic, copy) NSString *contDt;

@property (nonatomic, copy) NSString *crdComAmt;

@property (nonatomic, copy) NSString *crdNorUsedAmt;

@property (nonatomic, copy) NSString *crdComUsedAmt;

@property (nonatomic, copy) NSString *surplusAmt;

@property (nonatomic, copy) NSString *crdNorAmt;

@property (nonatomic, copy) NSString *haierCredit;
@end

