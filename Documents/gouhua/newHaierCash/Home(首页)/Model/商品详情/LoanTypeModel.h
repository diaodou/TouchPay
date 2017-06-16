//
//  LoanTypeModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/1.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoanTypeHead,LoanTypeBody,LoanTypeInfo,LoanVariety;
@interface LoanTypeModel : NSObject


@property (nonatomic, strong) LoanTypeHead *head;

@property (nonatomic, strong) LoanTypeBody *body;


@end
@interface LoanTypeHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface LoanTypeBody : NSObject



@property (nonatomic, strong) NSArray<LoanTypeInfo *> *info;

@end

@interface LoanTypeInfo : NSObject

@property (nonatomic, copy) NSString *typCde;

@property (nonatomic, copy) NSString *mtdCde;

@property (nonatomic, copy) NSString *maxAmt;

@property (nonatomic, copy) NSString *typSeq;

@property (nonatomic, copy) NSString *minAmt;

@property (nonatomic, copy) NSString *tnrOpt;

@property (nonatomic, copy) NSString *tnrMaxDays; //最大天数

@property (nonatomic, copy) NSString *tnrMinDays; //最小天数

@property (nonatomic, copy) NSString *mtdDesc;

@property (nonatomic, copy) NSString *typLvlCde;//小类代码

@property (nonatomic, copy) NSString *typLvlDesc;//小类名

+ (LoanTypeInfo *)initFrom:(LoanVariety *)model;


@end

